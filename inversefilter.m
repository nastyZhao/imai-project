clear

fs_used = 44100;
M = 67;

Nframe = 44100;
Nfft = 4*Nframe;
nstart = 2000;
axis_length = 7000/(fs_used/Nfft);

friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs_used/Nfft);

% filter_length = 22050/(fs_used/Nfft);
% filter_axis = (1:filter_length);
% filter_axis = filter_axis(:)*(2/Nfft);
% f = filter_axis;
% f(1) = 0;
% load('inverse.mat');
% inverse = inverse(1:filter_length);


f = [0 0.03 0.08 0.09 0.095 0.1 0.12 0.13 0.15 1];
mhi = [2 0.5 1 1 1 0.1 5 5 1 1];
% mhi = [1 1 1 1 1 1 1 1 1 1];
bhi = fir2(500,f,mhi);

figure(2)
freqz(bhi,1)

[origin_whitenoise,fsw] = audioread('whitenoise.wav');
[whitenoise,fs1] = audioread('data\20170711\whitenoise_M.wav');

inversenoise = filter(bhi,1,origin_whitenoise);
inverse_final = filter(bhi,1,whitenoise);



spectrum_noise = getspectrum(inversenoise,Nframe,Nfft,fs_used,nstart);
spectrum_noise_show = spectrum_noise(1:axis_length);
cepenv_whitenoise = getcepstrum(spectrum_noise,M);
cepenv_noise_show = cepenv_whitenoise(1:axis_length);

spectrum_finalnoise = getspectrum(inverse_final,Nframe,Nfft,fs_used,nstart);
spectrum_finalnoise_show = spectrum_noise(1:axis_length);
cepenv_finalnoise = getcepstrum(spectrum_finalnoise,M);
cepenv_finalnoise_show = cepenv_finalnoise(1:axis_length);

figure(1);
hold on
plot(friency_axis,cepenv_finalnoise_show,'LineWidth',1.0);

% plot(friency_axis,spectrum_wholesignal_filtered_show,'LineWidth',2.0);
audiowrite('filterednoise.wav',inversenoise,44100);