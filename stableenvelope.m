clear

[whitenoise,fs1] = audioread('..\data\CR_A_truth\NOISE_BOX.wav');
[whitevocal,fs2] = audioread('..\data\CR_A_truth\NOISE_VOCAL_CR.wav');

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

for i=1:10
    
    start = 100000+i*Nframe/2;

    spectrum_whitenoise = getspectrum(whitenoise,Nframe,Nfft,fs_used,start);
    cepenv_whitenoise = getcepstrum(spectrum_whitenoise,M);
    envelopes_whitenoise = envelopes_whitenoise+cepenv_whitenoise;
    
    spectrum_whitevocal = getspectrum(whitevocal,Nframe,Nfft,fs_used,start);
    cepenv_whitevocal = getcepstrum(spectrum_whitevocal,M);
    envelopes_whitevocal = envelopes_whitevocal+cepenv_whitevocal;

end


envelopes_whitenoise = envelopes_whitenoise/10;
envelopes_whitenoise_show = envelopes_whitenoise(1:axis_length);

envelopes_whitevocal = envelopes_whitevocal/10;
envelopes_whitevocal_show = envelopes_whitevocal(1:axis_length);

spectrum_whitevocal_show = spectrum_whitevocal(1:axis_length);
spectrum_whitenoise_show = spectrum_whitenoise(1:axis_length);
transfer_spectrum_show = spectrum_whitevocal_show - spectrum_whitenoise_show;

env_transfer = envelopes_whitevocal - envelopes_whitenoise;
env_transfer_show = env_transfer(1:axis_length);
[loc,val] = findpeaks(env_transfer_show);
val = val(:)*(fs_used/Nfft);

inverse_transfer_show = 32 - env_transfer_show;
[v_loc,v_val] = findpeaks(inverse_transfer_show);
v_val = v_val(:)*(fs_used/Nfft);

figure(5);
plot(friency_axis,transfer_spectrum_show,'LineWidth',1.0);
hold on
plot(friency_axis,env_transfer_show,'LineWidth',3.0);
title('Transfer function');
scatter(val,loc,'k');
ylabel('db');xlabel('Frequency(Hz)');
hold off



