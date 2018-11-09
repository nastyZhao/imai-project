clear;
[m_fx32_L,fsl] = audioread('m_fx32_L.wav');
[m_fx32_R,fsr] = audioread('m_fx32_R.wav');
[jitter110,fsj] = audioread('glottal500jitter.wav');
[p110,fsp] = audioread('glotrosp110.wav');
jitter110=resample(jitter110,12000,fsj);
Nframe = 2205;
Nfft = 4096;
m_fx32_R = m_fx32_R(1.039e+05+1:1.039e+05+Nframe);
m_fx32_L = m_fx32_L(2.088e+05+1:2.088e+05+Nframe);
jitter110 = jitter110(1000+1:1000+Nframe);
p110 = p110(1000+1:1000+Nframe);
winblac = window(@blackman,Nframe);
winnuttall = window(@nuttallwin,Nframe);
m_fx32_R_windled = winblac.* m_fx32_R;
m_fx32_L_windled = winblac.* m_fx32_L;
jitter110_windled = winblac.* jitter110;

spectrum_jitter110_o = 20*log10(abs(fft(jitter110_windled)));
spectrum_m_fx32_R = 20*log10(abs(fft(m_fx32_R_windled)));
spectrum_m_fx32_L = 20*log10(abs(fft(m_fx32_L_windled)));

spectrum_jitter110 = spectrum_jitter110_o(1:1500/(fsl/Nfft));
spectrum_m_fx32_R = spectrum_m_fx32_R(1:1500/(fsl/Nfft));
spectrum_m_fx32_L = spectrum_m_fx32_L(1:1500/(fsl/Nfft));
% 
friency_axisj = (1:1500/(fsj/Nfft));
friency_axisj = friency_axisj(:)*(fsj/Nfft);

friency_axish = (1:1500/(fsl/Nfft));
friency_axish = friency_axish(:)*(fsl/Nfft);
figure(1);
subplot(211);plot(friency_axish,spectrum_jitter110);title('new jitter windowlength:50ms blackmanwindow');
ylabel('db');xlabel('Hz');
subplot(212);plot(friency_axish,spectrum_m_fx32_R);title('300Hz windowlength:50ms blackmanwindow');
ylabel('db');xlabel('Hz');
% 
% winnuttall = window(@nuttallwin,Nframe);
% sample_windled = winnuttall.* whitenoise;
% fft_whitenoise = fft(sample_windled,Nfft);
% spectrum_whole =20*log10(abs(fft_whitenoise));
% spectrum_show = spectrum_whole(1:6000/(fs/Nfft));
% figure(1);
% plot(friency_axis,spectrum_show);
% title('spectrum from whitenoise genrenated by program(window length:60ms nuttallwindow)');
% ylabel('db');
% xlabel('Frequency(Hz)');