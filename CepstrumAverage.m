clear;

[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 400;
Nfft = 2048;
nstart = 15000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

%spectrum calculating%
origin_spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
% spectrum_show = spectrum(1:axis_length)';


%% cepstrum method

M =39;
average_order = 40;
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)

origin_cepstrum = real(ifft(origin_spectrum'));
origin_cep_liftered = h.*real(ifft(origin_spectrum'));
cepstrum_envelope = real(fft(origin_cep_liftered));


figure(20)
for i=1:1:1000

spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
plot(friency_axis,spectrum(1:axis_length));
hold on
cepstrum = real(ifft(spectrum'));

spectrum_pool(:,i) = spectrum;
cepstrum_pool(:,i) = cepstrum;

nstart = nstart + 1;

end
hehe = cepstrum_pool(:,1);
spectrum_mean = mean(spectrum_pool,2);
cepstrum_mean = mean(cepstrum_pool,2);

residual_peak_cepstrum = get_peak_cepstrum(spectrum_mean,Nfft,3,30);

haha = residual_peak_cepstrum;
remove_filter = max(residual_peak_cepstrum)/10;
residual_peak_cepstrum = max(residual_peak_cepstrum-remove_filter,0);
[peak_val,peak_loc] = findpeaks(residual_peak_cepstrum);

figure(1)
plot(cepstrum_mean);
hold on
for peak_Iter=1:1:length(peak_loc)
    [leftzeros,rightzeros] = findZeroSide(cepstrum_mean,peak_loc(peak_Iter),10);
    left_lifter = leftzeros(1);
    right_lifter = rightzeros(1);
    scatter(left_lifter,cepstrum_mean(left_lifter),'filled','r');
    scatter(right_lifter,cepstrum_mean(right_lifter),'filled','r');

    cepstrum_pool((left_lifter:right_lifter),1) = cepstrum_pool((left_lifter:right_lifter),1) - ...
        cepstrum_mean(left_lifter:right_lifter);
end
% ceps = cepstrum_pool(:,1) - cepstrum_mean;
spec = real(fft(cepstrum_pool(:,1)));
[liftered_env,liftered_cepstrum]=getcepstrum(spec,40);

figure(4)
% plot(hehe(:,1),'LineWidth',2.0);
plot(cepstrum_pool(:,1),'LineWidth',1.0);
hold on
% scatter(peak_loc,cepstrum_pool(peak_loc),'k')
% plot(cepstrum_mean,'LineWidth',2.0);
% scatter(peak_loc,cepstrum_mean(peak_loc),'k')

hold off

figure(5)
% plot(friency_axis,spec(1:axis_length));
plot(friency_axis,spectrum_pool((1:axis_length),1));
hold on 
plot(friency_axis,spec(1:axis_length));
% plot(friency_axis,cepstrum_envelope(1:axis_length),'LineWidth',1.0);
plot(friency_axis,liftered_env(1:axis_length),'LineWidth',2.0);
hold off
