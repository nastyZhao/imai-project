% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
%% global paramaters
global fs;
global Nframe;
global Nfft;
global axis_length;
global friency_axis;

%% initial data settings
[wave_origin,fs_origin] = ...
    audioread('..\data\20181009(SC VOWEL CLEAN)\SC_550_clean.wav');
% ..\data\20181009(SC VOWEL CLEAN)\SC_150.wav
% ..\data\CR_A_30HNR_JITTER\CR_A_650.wav
fs = 20000;
vowel_resample=resample(wave_origin,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 600;
Nfft = 4096;
nstart = 10000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);

low_boundry = floor(fs/900);

%% time averaging
env_cep_pool = [];
env_DT_pool = [];
spec_pool = [];
spec_subed_pool = [];

for Iter = 1:100:10000
    
    vowel_slice = vowel_filtered(nstart+Iter+1:nstart+Iter+Nframe);
    spec_slice = getspectrum(vowel_slice,Nframe,Nfft,'bla');
    ceps_slice = real(ifft(spec_slice));
    
    [l_bonds,r_bonds,rah_used] = rah_bound(vowel_slice);
    [ceps_peak_subed,sp_subed,sp_delta] = ...
    subtraction(ceps_slice,rah_used,l_bonds,r_bonds,Nfft,5,low_boundry);
    sp_subed = sp_subed + 0*sp_delta;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [cc,ee,env_DP_slice] = get_peak_cepstrum(sp_subed,Nfft,5,100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [env_cep,cep_slice] = getcepstrum(spec_slice,25);
    env_cep_pool = [env_cep_pool,env_cep'];
    
    env_DT_pool = [env_DT_pool,env_DP_slice'];
    spec_pool = [spec_pool,spec_slice];
    spec_subed_pool = [spec_subed_pool,sp_subed];
end

%     len_constant = 100;
%     len_damp = 25;
%     win_damp = window(@blackman,2*len_damp)';
%     win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
%         zeros(1,Nfft-2*(len_constant+len_damp))...
%         win_damp(1:len_damp) ones(1,len_constant)];
%     cep_peak_env = win_env.*ceps_peak_subed';
%     env_DP_11 = real(fft(cep_peak_env));


env_cep = mean(env_cep_pool,2);
env_DT = mean(env_DT_pool,2);
% 
[peak_val_cep,peak_loc_cep] = findpeaks(env_cep(1:peak_pick_len));
peak_loc_cep = peak_loc_cep*(fs/Nfft);

[peak_val_DT,peak_loc_DT] = findpeaks(env_DT(1:peak_pick_len));
peak_loc_DT = peak_loc_DT*(fs/Nfft);
% 
[dip_val_cep,dip_loc_cep] = findpeaks(-env_cep(1:dip_pick_len));
dip_loc_cep = dip_loc_cep*(fs/Nfft);
[dip_val_DT,dip_loc_DT] = findpeaks(-env_DT(1:dip_pick_len));
dip_loc_DT = dip_loc_DT*(fs/Nfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figures
sp_sub_show = spec_subed_pool(:,10);
spectrum_raw_show = spec_pool(:,10);

figure(58)
plot(ceps_slice(1:150));

% figure(10)
% plot(friency_axis,spectrum_raw_show(1:axis_length),'LineWidth',1.0);
% hold on
% plot(friency_axis,sp_sub_show(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,env_DT(1:axis_length),'LineWidth',2.0);
% % % scatter(peak_loc_DT,peak_val_DT,'k');
% hold off

%% functions

function [l_bonds,r_bonds,rah_used] = rah_bound(signal)
global fs;
global Nfft;
global Nframe;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%spectrum calculating%
spec_blac = getspectrum(signal,Nframe,Nfft,'bla');
ceps_bla = real(ifft(spec_blac));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cepstrum Editor
low_boundry = floor(fs/900);
ceps_search = ceps_bla(1:Nfft/2);
ceps_search(1:low_boundry) = 0;
[val_P1,loc_P1] = max(ceps_search);
M = low_boundry;

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spec_blac,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spec_blac,Nfft,7,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spec_blac,Nfft,9,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spec_blac,Nfft,11,M);

delta1 = (sub_cep1 - sub_cep2).^2;
delta2 = (sub_cep1 - sub_cep3).^2;
delta3 = (sub_cep1 - sub_cep4).^2;
deltasum = delta1+delta2+delta3;

deltasumCache = deltasum;
deltamean = mean(deltasumCache);
deltasumCache(1:floor(loc_P1/2)) = 0;
anti_deltasum = -deltasumCache;

loc_Rams = [];
l_bonds = [];
r_bonds = [];
ceps_peak_subed = ceps_bla';


rah_used = 0;
i = 0;
while 1
    i = i+1;
    if i == 1
        loc_Ram = loc_P1;
        val_Ram = deltasumCache(loc_Ram);
    else
        [val_Ram,loc_Ram] = max(deltasumCache(loc_Rams(i-1)+loc_P1-floor(low_boundry/2):... 
            loc_Rams(i-1)+loc_P1+floor(low_boundry/2)));
        loc_Ram = loc_Ram + loc_Rams(i-1)+loc_P1-floor(low_boundry/2)-1;
    end
    
    if val_Ram <= deltamean
        rah_used = i-1;
        break
    end
 
    loc_Rams = [loc_Rams,loc_Ram];
    
    [var_l_zeros,loc_l_zeros] = findpeaks(anti_deltasum(loc_Rams(i)-10:loc_Rams(i)));
    [var_r_zeros,loc_r_zeros] = findpeaks(anti_deltasum(loc_Rams(i):loc_Rams(i)+10));
    
    l_bond = loc_Rams(i)-10+loc_l_zeros(length(loc_l_zeros))-1;
    r_bond = loc_Rams(i)+loc_r_zeros(1)-1;
    
    l_bonds = [l_bonds,l_bond];
    r_bonds = [r_bonds,r_bond];
end
% [ceps_peak_subed,sp_subed,sp_delta] = ...
%     subtraction(ceps_bla,rah_used,l_bonds,r_bonds,Nfft,10,M);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Envelope calculation
% lifter = lift_order;
% damper = damp_order;
% [cc,ee,env_imai] = get_peak_cepstrum(spec_subed',Nfft,3,lifter);
% env_delta_sub = spec_subed;
end


function [cep_subed,sp_subed,sp_delta] = subtraction(ceps_raw,rah_num,l_bonds,r_bonds,Nfft,Iter,M);

sp_delta = zeros(1,Nfft)';
sp_raw = real(fft(ceps_raw));
for iter = 1:Iter
    cep_subed = ceps_raw;
    [ceps_rah,base_spec,base_env] = get_invertImai_peak(real(fft(ceps_raw)),0,M);
    for j = 1:rah_num
        l_mirror = Nfft - r_bonds(j) + 1;
        r_mirror = Nfft - l_bonds(j) + 1;
        
        cep_subed(l_bonds(j):r_bonds(j))=...
            ceps_raw(l_bonds(j):r_bonds(j))'- ...
            ceps_rah(l_bonds(j):r_bonds(j));
        
        cep_subed(l_mirror:r_mirror) = ...
            ceps_raw(l_mirror:r_mirror)'...
            -ceps_rah(l_mirror:r_mirror);
    end
    sp_subed = real(fft(cep_subed));
    if iter ~= 1
        sp_delta = sp_delta + sp_subed - sp_raw;
    end
    sp_raw = sp_subed;
    ceps_raw = cep_subed;
end
sp_delta = 2*sp_delta ./(Iter-1);
end