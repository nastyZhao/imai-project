% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)
clear;
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
% [sidetest,fs_origin] = audioread('400.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 400;
Nfft = 2048;
nstart = 55000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

%spectrum calculating%
spectrum = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';


%% cepstrum method

M =38;
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)
anti_h = [zeros(1,M+1) ones(1,Nfft-2*M-1) zeros(1,M)];
cepstrum = real(ifft(spectrum'));
cep_liftered = h.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));










%% imai peak 
peak_lifter_spectrum = spectrum;
cepstrum_tolifter = real(ifft(spectrum'));

a = get_peak_cepstrum(peak_lifter_spectrum,Nfft,1,M);
b = get_peak_cepstrum(peak_lifter_spectrum,Nfft,2,M);
c = get_peak_cepstrum(peak_lifter_spectrum,Nfft,3,M);

b1 = [zeros(1,38) b(39:44) zeros(1,1962) b(2006:2011) zeros(1,37)];
b2 = [zeros(1,78) b(79:86) zeros(1,1878) b(1964:1971) zeros(1,77)];
b3 = [zeros(1,118) b(119:125) zeros(1,1800) b(1925:1931) zeros(1,117)];
b4 = [zeros(1,158) b(159:163) zeros(1,1724) b(1887:1891) zeros(1,157)];
% 
sp_b1 = real(fft(b1));
sp_b2 = real(fft(b2));
sp_b3 = real(fft(b3));
sp_b4 = real(fft(b4));
% 
% add1=sp_b1+sp_b2;
% add2=sp_b1+sp_b2+sp_b3;
add3=b1+b2+b3+b4;
add3_p = max(add3,0);
b_p = max(b,0);
anti_bp = anti_h.*(b_p);
sp_b = real(fft(b_p));
sp_antib = real(fft(b_p));
% 
true_env = imai_peak(spectrum,M,1.5,4,'re');

peak_spectrum = spectrum-true_env;

peak_env = imai_peak(spectrum,M,0,2,'re');
spectrum_har = max(spectrum - peak_env,0);

[ori_val,ori_loc] = findpeaks(sp_b);

windowSize = 20; 
averagewin = (1/windowSize)*triang(windowSize);
base = 1;
y = filter(averagewin,base,sp_b);
[val,loc] = findpeaks(y(1:axis_length));
loc_show = loc(:)*(fs/Nfft);

peak_distance = loc(1)-ori_loc(1);
fix_peak = circshift(y,-peak_distance); 
fix_peak = fix_peak*(max(spectrum_har)/max(fix_peak));


base_spectrum = max(envelope'-spectrum,0)
% NIter = 1;
% for i = 1:1:NIter
%     
%     peak_env = imai_peak(spectrum_har,M,0,1,'re');
%     delta_sp = max(spectrum_har-max(peak_env),0);
% 
% %     peak_sp_recover = max(spectrum-peak_env)/max(peak_sp)*peak_sp;
    pspectrum = spectrum - fix_peak;
% end



%% results

figure(7);
plot(friency_axis,spectrum_har(1:axis_length),'color',[96 96 96]/255);

% plot(friency_axis,add3(1:axis_length),'LineWidth',1.0);
hold on
% scatter(loc,val,'k');
% plot(friency_axis,true_env(1:axis_length),'LineWidth',2.0);
% plot(friency_axis,peak_env(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,sp_b3(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,delta_env(1:axis_length),'LineWidth',1.0);

% plot(friency_axis,peak_1(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,peak_3(1:axis_length),'LineWidth',1.0);
hold off

figure(8)
plot(friency_axis,sp_b(1:axis_length),'color',[96 96 96]/255);
hold on
plot(friency_axis,y(1:axis_length),'LineWidth',1.0);
hold off

figure(3);
plot(anti_bp(1:1024));
% 
% % plot(residual_peak_cepstrum(1:200));
% hold on
% plot(a(1:200));
% plot(b(1:200));
% hold off
% % % 
% figure(4);
% plot(a(1:200));
% hold on
% plot(b(1:200));
% plot(c(1:200));
% hold off
% % % end
