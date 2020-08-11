clear;
%% initial data settings
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
% [sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_350.wav');
% ..\data\CR_A_30HNR_JITTER\CR_A_750.wav
% ..\data\yuke voice\YUKE_600.wav
% ..\data\CR_A_30HNR_JITTER\CR_A_550.wav
fs = 20000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.97],[1],vowel_resample);

%FFT paramaters setting% 
Nframe = 600;
Nfft = 4096;
nstart = 15000;
%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);
  
peak_pick_len = 4500/(fs/Nfft);
dip_pick_len = 6500/(fs/Nfft);

%spectrum calculating%
vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
spectrum_bla = getspectrum(vowel_blocked,Nframe,Nfft,'han');
ceps_bla = real(ifft(spectrum_bla));

%% Cepstrum Editor
low_boundry = floor(fs/900);
ceps_search = ceps_bla(1:Nfft/2);
ceps_search(1:low_boundry) = 0;
[val_P1,loc_P1] = max(ceps_search);
M = low_boundry;

[sub_cep1,sub_spec1,sub_env1] = get_peak_cepstrum(spectrum_bla,Nfft,0,M);
[sub_cep2,sub_spec2,sub_env2] = get_peak_cepstrum(spectrum_bla,Nfft,7,M);
[sub_cep3,sub_spec3,sub_env3] = get_peak_cepstrum(spectrum_bla,Nfft,9,M);
[sub_cep4,sub_spec4,sub_env4] = get_peak_cepstrum(spectrum_bla,Nfft,11,M);

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

val_lbond = [];
val_rbond = [];

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
    
    val_lbond = [val_lbond,ceps_bla(l_bond)];
    val_rbond = [val_rbond,ceps_bla(r_bond)];

end

[ceps_peak_subed,sp_subed,sp_delta] = ...
    subtraction(ceps_bla,rah_used,l_bonds,r_bonds,Nfft,20,M);
spec_subed = real(fft(ceps_peak_subed));

sp_sum = spec_subed + 4*sp_delta;

%% Envelope calculation
% [cc,ee,env_imai] = get_peak_cepstrum(spec_subed',Nfft,3,lifter);
% [cc1,ee1,env_i_imai] = get_invertImai_peak(spec_subed',1,lifter);
len_constant = 50;
len_damp = 0;
win_damp = window(@blackman,2*len_damp)';
win_env = [ones(1,len_constant) win_damp(len_damp+1:2*len_damp)...
    zeros(1,Nfft-2*(len_constant+len_damp))...
    win_damp(1:len_damp) ones(1,len_constant)];
cep_peak_env = win_env.*ceps_peak_subed';
env_peak_final = real(fft(cep_peak_env));

[cc,ee,env_imai] = get_peak_cepstrum(spectrum_bla,Nfft,30,27);

%% Figures
figure(31)
plot(ceps_bla(1:300));
hold on
% plot(ceps_peak_subed(1:150));
% scatter(l_bonds(1:3),val_lbond(1:3),'k');
% scatter(r_bonds(1:3),val_rbond(1:3),'k');
% xlabel('Quefrency(samples)');
% ylabel('Amplitude');
hold off

figure(71)
% plot(friency_axis,spectrum_bla(1:axis_length),'k');
plot(friency_axis,spec_subed(1:axis_length),'Linewidth',1.0);
hold on
% plot(friency_axis,spec_subed(1:axis_length),'Linewidth',1.0);
% plot(friency_axis,spec_subed2(1:axis_length));
% plot(friency_axis,env_imai(1:axis_length),'Linewidth',1.0);
plot(friency_axis,env_peak_final(1:axis_length),'Linewidth',2.0);
xlabel('Frequency(samples)');
ylabel('Amplitude');
hold off
% 
figure(41)
plot(friency_axis,env_imai(1:axis_length),'Linewidth',2.0);

%% Subtraction Function
function [cep_subed,sp_subed,sp_delta] = subtraction(ceps_raw,rah_num,l_bonds,r_bonds,Nfft,Iter,M)
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
sp_delta = sp_delta ./(Iter-1);

end


