clear
% [origin_whitenoise,fsw] = audioread('whitenoise.wav');
% [vertical,fs] = audioread('data\20170608\uni_vertical_20.wav');
% [horizental,fs0] = audioread('data\20170608\uni_horizon_20.wav');
% [vertical,fs] = audioread('data\20170615\vertical_20_new.wav');
% [horizental,fs0] = audioread('data\20170615\horizontal_20_new.wav');
% [vertical,fs] = audioread('filterednoise.wav');
% [horizental,fs0] = audioread('data\20180110\p150.wav');
[whitenoise,fs1] = audioread('data\20181009(SC VOWEL CLEAN)\whitenoise_SC.wav');
[whitevocal,fs2] = audioread('data\20181009(SC VOWEL CLEAN)\whitevocal_SC.wav');
% [whitenoise,fs1] = audioread('data\20170608\uni_whitenoise_20_R.wav');
% [whitevocal,fs2] = audioread('data\20170608\uni_vocal_20_R.wav');
fs_used = 44100;
M = 120;

Nframe = 44100;
Nfft = 4*Nframe;
nstart = 122000;
axis_length = 8000/(fs_used/Nfft);

friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs_used/Nfft);


% envelopes_vertical = zeros(1,Nfft);
% envelopes_horizental = zeros(1,Nfft);
envelopes_whitenoise = zeros(1,Nfft);
envelopes_whitevocal = zeros(1,Nfft);
for i=1:10
    start = 200000+i*Nframe/2;
    alpha = 1.0;
    nIter = 3;
    ws = 're';

%     spectrum_vertical = getspectrum(vertical,Nframe,Nfft,fs_used,start);
%     cepenv_vertical = getcepstrum(spectrum_vertical,M);
%     envelopes_vertical = envelopes_vertical+cepenv_vertical;
%     imai_noise = imai_peak(spectrum_noise,M,alpha,nIter,ws)
    
%     spectrum_horizental = getspectrum(horizental,Nframe,Nfft,fs_used,start);
%     cepenv_horizental = getcepstrum(spectrum_horizental,M);
%     envelopes_horizental = envelopes_horizental+cepenv_horizental;
%     imai_noise = imai_peak(spectrum_noise,M,alpha,nIter,ws)

    spectrum_whitenoise = getspectrum(whitenoise,Nframe,Nfft,fs_used,start);
    cepenv_whitenoise = getcepstrum(spectrum_whitenoise,M);
    envelopes_whitenoise = envelopes_whitenoise+cepenv_whitenoise;
%     imai_noise = imai_peak(spectrum_noise,M,alpha,nIter,ws)
    
    spectrum_whitevocal = getspectrum(whitevocal,Nframe,Nfft,fs_used,start);
    cepenv_whitevocal = getcepstrum(spectrum_whitevocal,M);
    envelopes_whitevocal = envelopes_whitevocal+cepenv_whitevocal;
%     imai_noise = imai_peak(spectrum_noise,M,alpha,nIter,ws)
end

% envelopes_vertical = envelopes_vertical/10;
% env_vertical_show = envelopes_vertical(1:axis_length);
% envelopes_horizental = envelopes_horizental/10;
% env_horizental_show = envelopes_horizental(1:axis_length);

envelopes_whitenoise = envelopes_whitenoise/10;
inverse = -spectrum_whitenoise;
envelopes_whitenoise_show = envelopes_whitenoise(1:axis_length);
[locn,valn] = findpeaks(envelopes_whitenoise_show);
valn = valn(:)*(fs_used/Nfft);
envelopes_whitevocal = envelopes_whitevocal/10;
envelopes_whitevocal_show = envelopes_whitevocal(1:axis_length);

% inverse_one = ones(1,Nfft);
% inverse_whitenoise = -envelopes_whitenoise;
% inverse_whitenoise = inverse_whitenoise/max(abs(inverse_whitenoise));
% spectrum_wholesignal = fft(origin_whitenoise);
% spectrum_wholesignal_filtered = spectrum_wholesignal.*inverse_whitenoise;
% spectrum_wholesignal_filtered_show = spectrum_wholesignal_filtered(1:axis_length);
% inverse_noise = real(ifft(spectrum_wholesignal_filtered,Nfft));
% audiowrite('inverse_noise.wav',inverse_noise,44100);
% % spectrum_wholesignal_filtered = spectrum_wholesignal_filtered/max(abs(spectrum_wholesignal_filtered));

% env_sub = abs(envelopes_horizental - envelopes_vertical);
% env_sub = envelopes_horizental - envelopes_vertical;
% env_sub_show = env_sub(1:axis_length);
% env_truewhitenoise = envelopes_whitenoise + env_sub;
% env_truewhitenoise_show = env_truewhitenoise(1:axis_length);

spectrum_whitevocal_show = spectrum_whitevocal(1:axis_length);
spectrum_whitenoise_show = spectrum_whitenoise(1:axis_length);

env_transfer = envelopes_whitevocal - envelopes_whitenoise;
env_transfer_show = env_transfer(1:axis_length);
[loc,val] = findpeaks(env_transfer_show);
val = val(:)*(fs_used/Nfft);


% figure(5);
% 
% plot(friency_axis,env_vertical_show,'LineWidth',2.0);
% 
% hold on;
% % plot(friency_axis,env_vertical_show,'LineWidth',2.0);
% ylabel('db');xlabel('Frequency(Hz)');
% % title('environment compare');

figure(5);
% plot(friency_axis,spectrum_whitenoise_show,'LineWidth',1.0);

plot(friency_axis,env_transfer_show,'LineWidth',3.0);
hold on
% plot(friency_axis,envelopes_whitenoise_show,'LineWidth',2.0);
% plot(friency_axis,envelopes_whitenoise_show,'LineWidth',2.0);
% title('Transfer function, 25cm');
% plot(friency_axis,envelopes_whitevocal_show,'LineWidth',2.0);
% hold on;
scatter(val,loc,'k');

ylabel('db');xlabel('Frequency(Hz)');
% hold off;



