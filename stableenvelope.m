clear

[whitenoise,fs1] = audioread('..\data\CR_A_truth\NOISE_BOX.wav');
[whitevocal,fs2] = audioread('..\data\CR_A_truth\NOISE_VOCAL_CR.wav');

[whitenoise2,fs3] = audioread('..\data\20181009(SC VOWEL CLEAN)\whitenoise_SC.wav');
[whitevocal2,fs4] = audioread('..\data\20181009(SC VOWEL CLEAN)\whitevocal_SC.wav');

fs_used = 44100;
M = 120;

Nframe = 44100;
Nfft = 4*Nframe;
nstart = 122000;

axis_length = 8000/(fs_used/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs_used/Nfft);

envelopes_whitenoise = zeros(1,Nfft);
envelopes_whitevocal = zeros(1,Nfft);

envelopes_whitenoise2 = zeros(1,Nfft);
envelopes_whitevocal2 = zeros(1,Nfft);

for i=1:10
    
    start = 100000+i*Nframe/2;
    
    noise_frame = whitenoise(start+1:start+Nframe);
    spectrum_whitenoise = getspectrum(noise_frame,Nframe,Nfft,'bla');
    cepenv_whitenoise = getcepstrum(spectrum_whitenoise,M);
    envelopes_whitenoise = envelopes_whitenoise+cepenv_whitenoise;
    
    vocal_frame = whitevocal(start+1:start+Nframe);
    spectrum_whitevocal = getspectrum(vocal_frame,Nframe,Nfft,'bla');
    cepenv_whitevocal = getcepstrum(spectrum_whitevocal,M);
    envelopes_whitevocal = envelopes_whitevocal+cepenv_whitevocal;
    
    noise_frame2 = whitenoise2(start+1:start+Nframe);
    spectrum_whitenoise2 = getspectrum(noise_frame2,Nframe,Nfft,'bla');
    cepenv_whitenoise2 = getcepstrum(spectrum_whitenoise2,M);
    envelopes_whitenoise2 = envelopes_whitenoise2+cepenv_whitenoise2;
    
    vocal_frame2 = whitevocal2(start+1:start+Nframe);
    spectrum_whitevocal2 = getspectrum(vocal_frame2,Nframe,Nfft,'bla');
    cepenv_whitevocal2 = getcepstrum(spectrum_whitevocal2,M);
    envelopes_whitevocal2 = envelopes_whitevocal2+cepenv_whitevocal2;

end


envelopes_whitenoise = envelopes_whitenoise/10;
envelopes_whitenoise_show = envelopes_whitenoise(1:axis_length);

envelopes_whitevocal = envelopes_whitevocal/10;
envelopes_whitevocal_show = envelopes_whitevocal(1:axis_length);

envelopes_whitenoise2 = envelopes_whitenoise2/10;
envelopes_whitenoise_show2 = envelopes_whitenoise2(1:axis_length);

envelopes_whitevocal2 = envelopes_whitevocal2/10;
envelopes_whitevocal_show2 = envelopes_whitevocal2(1:axis_length);

spectrum_whitevocal_show = spectrum_whitevocal(1:axis_length);
spectrum_whitenoise_show = spectrum_whitenoise(1:axis_length);
transfer_spectrum_show = spectrum_whitevocal_show - spectrum_whitenoise_show;

env_transfer = envelopes_whitevocal - envelopes_whitenoise;
env_transfer_show = env_transfer(1:axis_length);
[loc,val] = findpeaks(env_transfer_show);
val = val(:)*(fs_used/Nfft);

env_transfer2 = envelopes_whitevocal2 - envelopes_whitenoise2;
env_transfer_show2 = env_transfer2(1:axis_length);

inverse_transfer_show = 32 - env_transfer_show;
[v_loc,v_val] = findpeaks(inverse_transfer_show);
v_val = v_val(:)*(fs_used/Nfft);

figure(5);
% plot(friency_axis,transfer_spectrum_show,'LineWidth',1.0);
% hold on
plot(friency_axis,env_transfer_show,'LineWidth',2.0);
% plot(friency_axis,env_transfer_show2,'LineWidth',3.0);
% title('Transfer function');
% scatter(val,loc,'k');
ylabel('Amplitude(db)');xlabel('Frequency(Hz)');
% hold off


% figure(2)
% ax1 = subplot(2,1,1); 
% plot(friency_axis,env_transfer(1:axis_length));
% 
% % xlabel(ax1,'Frequency(Hz)');
% ylabel(ax1,'Amplitude(db)');
% hold off
% 
% 
% ax2 = subplot(2,1,2); 
% plot(friency_axis,env_transfer2(1:axis_length));
% 
% xlabel(ax2,'Frequency(Hz)');
% ylabel(ax2,'Amplitude(db)');
% hold off


