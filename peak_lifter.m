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
nstart = 15000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

%spectrum calculating%
spectrum = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';


%% time averaging

for timestamp = 1000:200:20000
    spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,timestamp);
end


%% cepstrum method

M =24;
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)
anti_h = [zeros(1,M+1)  ones(1,Nfft-2*M-1)  zeros(1,M)];

cepstrum = real(ifft(spectrum'));

cep_liftered = h.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));


%% imai peak 

spec_to_sub = spectrum;
Iteration = 1;
a = 1;
for iter = 1:Iteration
sub_cep = get_peak_cepstrum(spec_to_sub,Nfft,1,M)';
sub_cep_tune = (anti_h.*max(sub_cep,0)')';
sub_spec_tune = real(fft(sub_cep_tune));
spec_subed = spec_to_sub - a*sub_spec_tune;
spec_to_sub = spec_subed;
end
final_env = getcepstrum(spec_to_sub,40);
[peak_val,peak_loc] = findpeaks(final_env(1:axis_length));
peak_loc = peak_loc*(fs/Nfft);



%% results

figure(7);
plot(friency_axis,spectrum(1:axis_length),'color',[96 96 96]/255);
hold on

plot(friency_axis,spec_subed(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,final_env(1:axis_length),'LineWidth',2.0);
scatter(peak_loc,peak_val,'k');
% plot(friency_axis,y(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,sp_b3(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,delta_env(1:axis_length),'LineWidth',1.0);

plot(friency_axis,envelope(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,peak_3(1:axis_length),'LineWidth',1.0);
hold off

figure(8)
plot(friency_axis,sub_spec_tune(1:axis_length),'color',[96 96 96]/255);

hold on
% plot(friency_axis,y(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,yy(1:axis_length),'LineWidth',1.0);
hold off

figure(3);
plot(cepstrum(1:200));
% plot(cpy(1:200));
% % plot(residual_peak_cepstrum(1:200));
hold on
plot(sub_cep_tune(1:200));
hold off
% % % % 
% figure(4);
% plot(a(1:200));
% % hold on
% % plot(b(1:200));
% % plot(c(1:200));
% hold off
% % % end
