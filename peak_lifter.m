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
b = get_peak_cepstrum(spectrum,Nfft,2,M);
b_p = b;
anti_bp = anti_h.*(b_p);

sp_b = real(fft(b_p))';
sp_antib = real(fft(b_p));
% 
true_env = imai_peak(spectrum,30,1.5,4,'re');
lifter = true_env-3;

peak_env = imai_peak(spectrum,M,0,2,'re');
spectrum_har = max(spectrum - lifter,0);


windowSize = 5; 
averagewin = (1/windowSize)*ones(1,windowSize);
base = 1;
y = filter(averagewin,base,sp_b);


cpy = real(ifft(y));
for i=1:length(cpy)
    if cpy(i)<0;
        cpy(i) = 0;
    end
end
yy = real(fft(cpy));



base_spectrum = max(envelope'-spectrum,0)
% NIter = 1;
% for i = 1:1:NIter
%     
%     peak_env = imai_peak(spectrum_har,M,0,1,'re');
%     delta_sp = max(spectrum_har-max(peak_env),0);
% 
% %     peak_sp_recover = max(spectrum-peak_env)/max(peak_sp)*peak_sp;
    
% end


cep_sip = max(cepstrum,0);
spec_sip = real(fft(cep_sip));
bbbb = filter(averagewin,base,spec_sip);
cepbbbb = real(fft(bbbb));
spectrum_line = spec_sip - spectrum;


%% results

figure(7);
plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
hold on
% scatter(loc,val,'k');
plot(friency_axis,bbbb(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,true_env(1:axis_length),'LineWidth',2.0);
% plot(friency_axis,lifter(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,sp_b3(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,delta_env(1:axis_length),'LineWidth',1.0);

% plot(friency_axis,peak_1(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,peak_3(1:axis_length),'LineWidth',1.0);
hold off

figure(8)
% plot(friency_axis,sp_b(1:axis_length),'color',[96 96 96]/255);
hold on
plot(friency_axis,spectrum_line(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,yy(1:axis_length),'LineWidth',1.0);
hold off

figure(3);
plot(b(1:1024));
% 
% % plot(residual_peak_cepstrum(1:200));
hold on
plot(cpy(1:200));
% plot(b(1:200));
% hold off
% % % 
% figure(4);
% plot(a(1:200));
% hold on
% plot(b(1:200));
% plot(c(1:200));
hold off
% % % end
