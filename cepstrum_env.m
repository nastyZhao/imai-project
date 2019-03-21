function [cepstrum_env_result] = cepstrum_env(FILENAME,lifterorder)

[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
% [sidetest,fs_origin] = audioread(FILENAME);
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 640;
Nfft = 2048;
nstart = 10000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

for m=1:1:30
    spectrum_slice = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart+m*3000);
    spectrum_show = spectrum_slice(1:axis_length)';
    spectrum_pool(:,m) = spectrum_show;
    Nfft=max(size(spectrum_slice));
    
    [ceps_env_slice,ceps_slice] = getcepstrum(spectrum_slice,21);
    ceps_env_slice = ceps_env_slice(1:axis_length)';
    ceps_env_pool(:,m) = ceps_env_slice;
    
end
spectrum = mean(spectrum_pool,2);
ceps_singleHZ = mean(ceps_env_pool,2);

[cep_loc,cep_val] = findpeaks(ceps_singleHZ);
cep_val = cep_val(:)*(fs/Nfft);

inverse_ceps = -ceps_singleHZ;
[i_cep_loc,i_cep_val] = findpeaks(inverse_ceps);
i_cep_val = i_cep_val(:)*(fs/Nfft);
i_cep_loc = -i_cep_loc;

cepstrum_env_result = {[cep_val',0,i_cep_val']};
% cepstrum_env_results(1,i) = cepstrum_env_result;
figure(3)
plot(friency_axis,spectrum_pool(:,5));
hold on
% plot(friency_axis,ceps_singleHZ,'LineWidth',2.0);
hold off
end
