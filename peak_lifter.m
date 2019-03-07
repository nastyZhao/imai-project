% function [spectrum,ceps_base,base_loc,base_val] = peak_lifter(FILENAME)

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
spectrum = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';


%% cepstrum method

M =38;
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)

cepstrum = real(ifft(spectrum'));
cep_liftered = h.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));
envelope_show = envelope(1:axis_length)';

base_spectrum = min(spectrum,envelope(:));

%% imai peak 
peak_lifter_spectrum = spectrum;
cepstrum_tolifter = real(ifft(spectrum'));
% nIter = 3;
% for i = 1:nIter
    residual_peak_cepstrum = get_peak_cepstrum(peak_lifter_spectrum,Nfft,0,M);
    
    a = get_peak_cepstrum(peak_lifter_spectrum,Nfft,1,M);
    b = get_peak_cepstrum(peak_lifter_spectrum,Nfft,3,M);
    
    
    remove_filter = max(b)/10;
    residual_b = max(b-remove_filter,0);
    [peak_val,peak_loc] = findpeaks(residual_b);
    
    for peak_Iter=1:1:2
    
     b(peak_loc(peak_Iter)) = cepstrum(peak_loc(peak_Iter));
    
    end
    
    b_left = cepstrum - b;
    sp_bleft = real(fft(b_left));
    [env,sdfsdalkf] = getcepstrum(sp_bleft,10);
    
%     cc = cepstrum_tolifter - 1.6*residual_peak_cepstrum;
%     peak_lifter_spectrum = real(fft(lifter_cepstrum))';
%     cepstrum_tolifter = lifter_cepstrum;
% end
b1 = [zeros(1,37) residual_peak_cepstrum(39:44) zeros(1,1962) residual_peak_cepstrum(2006:2011) zeros(1,36)];
b2 = [zeros(1,77) residual_peak_cepstrum(79:86) zeros(1,1878) residual_peak_cepstrum(1964:1971) zeros(1,76)];
b3 = [zeros(1,117) residual_peak_cepstrum(119:125) zeros(1,1800) residual_peak_cepstrum(1925:1931) zeros(1,116)];
b4 = [zeros(1,157) residual_peak_cepstrum(159:163) zeros(1,1724) residual_peak_cepstrum(1887:1891) zeros(1,156)];

sp_b1 = real(fft(b1));
sp_b2 = real(fft(b2));
sp_b3 = real(fft(b3));
sp_b4 = real(fft(b4));

add1=sp_b1+sp_b2;
add2=sp_b1+sp_b2+sp_b3;
add3=sp_b1+sp_b2+sp_b3+sp_b4;

nob1 = spectrum;

left_1 = cepstrum - residual_peak_cepstrum;
left_2 = cepstrum - a;
left_3 = cepstrum - b;

peak_1 = real(fft(residual_peak_cepstrum));
peak_2 = real(fft(a));
peak_3 = real(fft(b));


l_sp_1 = real(fft(left_1));
l_sp_2 = real(fft(left_2));
l_sp_3 = real(fft(left_3));

delta_1 = cepstrum-left_1;
delta_2 = left_1 - left_2;
delta_3 = left_2-left_3;
delta_all = delta_1+delta_2+delta_3;

delta_spectrum = real(fft(delta_all));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:1:1000
% 
% spectrum_slice = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
% cepstrum_slice = real(ifft(spectrum_slice'));
% spectrum_pool(:,i) = spectrum_slice;
% cepstrum_pool(:,i) = cepstrum_slice;
% nstart = nstart + 1;
% 
% end
% spectrum_mean = mean(spectrum_pool,2);
% cepstrum_mean = mean(cepstrum_pool,2);
% residual_peak_cepstrum = get_peak_cepstrum(spectrum_mean,Nfft,0,10);
% cc = cepstrum_tolifter - 1*residual_peak_cepstrum;
% % [liftered_envelope,liftered_cepstrum] = getcepstrum(peak_lifter_spectrum,70);
% peak_spectrum = real(fft(residual_peak_cepstrum))';
% % aa= spectrum - peak_spectrum-real(fft(b))';
% cc_spectrum = real(fft(cc))'
% [liftered_envelope,liftered_cepstrum] = getcepstrum(cc_spectrum,70)
%% results

figure(2);
% plot(friency_axis,delta_spectrum(1:axis_length),'color',[96 96 96]/255);

plot(friency_axis,sp_bleft(1:axis_length),'LineWidth',1.0);
hold on
plot(friency_axis,env(1:axis_length),'LineWidth',2.0);
% plot(friency_axis,sp_b3(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,sp_b4(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,peak_2(1:axis_length),'r','LineWidth',1.0);
% plot(friency_axis,peak_3(1:axis_length),'LineWidth',1.0);
% plot(friency_axis,envelope(1:axis_length),'LineWidth',2.0);
hold off

figure(3);
plot(cepstrum(1:200));

% plot(residual_peak_cepstrum(1:200));
hold on
% plot(a(1:200));
plot(b(1:200));
hold off
% % 
figure(4);
plot(b_left(1:200));
% hold on
% plot(delta_2(1:200));
% plot(delta_3(1:200));
% hold off
% % end
