clear
%% spectrum
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
% vowel_filtered=filter([1,-0.7],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 800;
Nfft = 2048;
nstart = 15000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

%spectrum calculating%
spectrum = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
cepstrum = real(ifft(spectrum'));
%% cepstrum

M =39;

nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd

w = boxcar(nw)';

rec_wzp = [w(((nw+1)/2):nw),zeros(1,Nfft-nw), w(1:(nw-1)/2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_rec = w(((nw+1)/2)+3:nw);
f_wzp = 0:1:2;
f_lifter = power(0.8,f_wzp(:))';

m_lifter = 0.1*boxcar(Nfft-nw)'

b_rec = w(1:(nw-1)/2-3);
b_wzp = 0:1:2;
b_lifter = flip(power(0.8,b_wzp(:)))';

power_wzp = [f_rec f_lifter m_lifter b_lifter b_rec];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cep_liftered_power = power_wzp.*real(ifft(spectrum'));

cep_liftered_rec = rec_wzp.*real(ifft(spectrum'));
envelope_power = real(fft(cep_liftered_power));
envelope_rec = real(fft(cep_liftered_rec));




%% figure

figure(3)
plot(friency_axis,spectrum(1:axis_length));
hold on
plot(friency_axis,envelope_power(1:axis_length),'LineWidth',2.0);
plot(friency_axis,envelope_rec(1:axis_length));
hold off


