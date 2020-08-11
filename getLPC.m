clear all;

[vowel,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_500.wav');
fs = 12000;
vowel_resample=resample(vowel,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

Nframe = 1200;
Nfft = Nframe*4;
nstart = 15000;

axis_length = 10000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

vowel_block = vowel_filtered(nstart+1:nstart+Nframe);
spectrum = getspectrum(vowel_block,Nframe,Nfft,'bla');
spectrum_show = spectrum(1:axis_length)';

% vowel= vowel_filtered(nstart+1:nstart+Nframe);
% wlen = length(vowel);
% p=22;
% a = lpc(vowel,p);
% LPC_envelope = lpcar2pf(a,8191);
% 
frequency = (0:8191)*fs/16384;
% df = fs/8192;
% LPC_log_envelope = 10*log10(LPC_envelope);
% [l_loc,l_val] = findpeaks(LPC_log_envelope);
% l_val = l_val(:)*(fs/16384);

p=20;
env_LPC_pool = [];
for timestamp = 1000:200:22000
    
    vowel= vowel_filtered(timestamp+1:timestamp+Nframe);
    wlen = length(vowel);
    a = lpc(vowel,p);
    LPC_envelope = lpcar2pf(a,8191);
    LPC_log_envelope = 20*log10(LPC_envelope);
    env_LPC_pool = [env_LPC_pool,LPC_log_envelope'];

end
env_LPC = mean(env_LPC_pool,2);
[l_loc,l_val] = findpeaks(env_LPC);
l_val = l_val(:)*(fs/16384);

figure(20);
plot(env_LPC,'color','k');
ylabel('Amplitude(db)');
xlabel('Frequency(Hz)');