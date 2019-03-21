function [env_result] = imai_lifter(FILENAME,lifterorder)

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


nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd
w = boxcar(nw)'; % rectangular window
wzp = [w(((nw+1)/2):nw),zeros(1,Nfft-nw), ...
       w(1:(nw-1)/2)];


cepstrum = ifft(spectrum);
cep_liftered = wzp.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));


env_result = 0

end