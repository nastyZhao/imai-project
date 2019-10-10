% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
%% global paramaters
global fs;
global Nframe;
global Nfft;
global axis_length;
global friency_axis;

%% initial data settings
[wave_origin,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_450.wav');
% ..\data\20181009(SC VOWEL CLEAN)\SC_150.wav
fs = 24000;
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

%% time averaging

env_cep_pool = [];
env_DT_pool = [];

for Iter = 1:20
    vowel_slice = vowel_filtered(nstart+Iter+1:nstart+Iter+Nframe);
%     spec_slice = getspectrum(vowel_slice,Nframe,Nfft,'bla');
% 
    env_DP_slice = delta_cep_sub(vowel_slice,85,0);
%     [env_cep,cep_slice] = getcepstrum(spec_slice,M);
%     
%     env_cep_pool = [env_cep_pool,env_cep'];
    env_DT_pool = [env_DT_pool,env_DP_slice'];
    
end

% env_cep = mean(env_cep_pool,2);
env_DT = mean(env_DT_pool,2);
% 
% [peak_val_cep,peak_loc_cep] = findpeaks(env_cep(1:peak_pick_len));
% peak_loc_cep = peak_loc_cep*(fs/Nfft);

% [peak_val_DT,peak_loc_DT] = findpeaks(env_DT(1:peak_pick_len));
% peak_loc_DT = peak_loc_DT*(fs/Nfft);
% 
% [dip_val_cep,dip_loc_cep] = findpeaks(-env_cep(1:dip_pick_len));
% dip_loc_cep = dip_loc_cep*(fs/Nfft);
% [dip_val_DT,dip_loc_DT] = findpeaks(-env_DT(1:dip_pick_len));
% dip_loc_DT = dip_loc_DT*(fs/Nfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figures

vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'bla');

figure(10)
plot(friency_axis,spectrum_bla(1:axis_length),'LineWidth',1.0);
hold on
plot(friency_axis,env_DT(1:axis_length),'LineWidth',2.0);
% scatter(peak_loc_DT,peak_val_DT,'k');
hold off

%% functions

function env_delta_sub = delta_cep_sub(signal,lift_order,damp_order)
global fs;
global Nfft;
global Nframe;
global axis_length;
global friency_axis;

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

[base_ceps0,base_spec0,base_env0] = get_invertImai_peak(spec_blac,0,M);
[base_ceps1,base_spec1,base_env1] = get_invertImai_peak(spec_blac,1,M);
[base_ceps2,base_spec2,base_env2] = get_invertImai_peak(spec_blac,2,M);
[base_ceps3,base_spec3,base_env3] = get_invertImai_peak(spec_blac,3,M);

spec_overhar =  max(spec_blac'-base_env1,0);
% spec_overhar =  max(spectrum_bla'-base_env2,0);
% spec_overhar =  max(spectrum_bla'-base_env3,0);
% spec_overhar =  max(spectrum_bla'-base_env4,0);
ceps_overhar = real(ifft(spec_overhar));

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
%     if i == 1
%         l_bond = l_bond - 2;
%         r_bond = r_bond + 2;
%     end
    
    l_mirror = Nfft - r_bond + 1;
    r_mirror = Nfft - l_bond + 1;
    
    l_bonds = [l_bonds,l_bond];
    r_bonds = [r_bonds,r_bond];
    
    ceps_peak_subed(l_bond:r_bond)=...
        ceps_bla(l_bond:r_bond)'- ceps_overhar(l_bond:r_bond);
    ceps_peak_subed(l_mirror:r_mirror) = ceps_bla(l_mirror:r_mirror)'...
        -ceps_overhar(l_mirror:r_mirror);
end
spec_subed = real(fft(ceps_peak_subed));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Envelope calculation
lifter = lift_order;
damper = damp_order;
[cc,ee,env_imai] = get_peak_cepstrum(spec_subed',Nfft,3,lifter);
env_delta_sub = spec_subed;
end