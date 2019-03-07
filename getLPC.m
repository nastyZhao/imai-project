clear all;

[vowel,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
fs = 16000;
vowel_resample=resample(vowel,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

Nframe = 1600;
Nfft = Nframe*4;
nstart = 15000;

axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';

vowel= vowel_filtered(nstart+1:nstart+Nframe);
wlen = length(vowel);
p=24;
a = lpc(vowel,p);
LPC_envelope = lpcar2pf(a,8191);

frequency = (0:8191)*fs/16384;
df = fs/8192;
LPC_log_envelope = 10*log10(LPC_envelope);
[l_loc,l_val] = findpeaks(LPC_log_envelope);
l_val = l_val(:)*(fs/16384);

figure(20);
plot(friency_axis,spectrum_show);
hold on
plot(frequency,LPC_log_envelope);