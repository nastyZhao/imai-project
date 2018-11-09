function [deviative,ceps_env]=imai_propose_script(wavfile)
y=1;
%%%preprocessing of the wavfile
%wavfile:.wav file                                                               
fs=10000;
[wav_origin,fs_origin,bt] = wavread(wavfile);
wav_resample=resample(wav_origin,fs,fs_origin);
wav_filtered=filter([1,-0.99],[1],wav_resample);
Length_wav=length(wav_filtered);
wav_normalized=wav_filtered /(max(abs(wav_filtered)));%normalization
% figure(1),
% plot(wav_normalized); 

%%%FFT trasform
fft_origin = fft(wav_normalized);
fft_log = log10(abs(fft_origin).^2);
fft_display = fft_log(1:5000);%just analyse 0~5000Hz
% figure(1),
% plot(fft_origin);

%%%caculate the imai_peak cepstrum envlope
% figure(1),
% plot(fft_display);hold on;
% for i=1:3
%     [imai_penv,ceps_env,c]=imai_peak(fft_origin,60,3.0,i);
%     imai_penv = imai_penv(1:5000);
%     plot(imai_penv,'LineWidth',1.5);hold on;
% end
% ceps_env = ceps_env(1:5000);
% plot(ceps_env,'LineWidth',3);hold off;

%%%caculate the imai_base cepstrum envlope
% figure(2),
% plot(fft_display);hold on;
% for i=1:20
%     [imai_benv,ceps_env,c]=imai_base(fft_origin,60,i);
%     imai_benv = imai_benv(1:5000);
%     plot(imai_benv,'LineWidth',1.5);
% end
% ceps_env = ceps_env(1:5000);
% plot(ceps_env,'LineWidth',3);hold off;

%%%caculate the devation envlope
% [imai_benv1,ceps_env,c]=imai_base(fft_origin,60,1);
% [imai_benv20,ceps_env,c]=imai_base(fft_origin,60,20);
% imai_benv1 = imai_benv1(1:5000);
% imai_benv20 = imai_benv20(1:5000);
% deviation=zeros(1,5000);
% deviation(:) = imai_benv1 - imai_benv20;
% 
% ceps_env = ceps_env(1:5000);
% maxceps = max(ceps_env);
% minceps = min(ceps_env);
% ceps_scale = maxceps - minceps;
% maxdev = max(deviation);
% mindev = min(deviation);
% dev_scale = maxdev - mindev;
% scale_ratio = ceps_scale/dev_scale;
% deviation(:) = deviation*scale_ratio-ceps_scale/2;
% figure(3),
% plot(fft_display);hold on;
% plot(deviation,'LineWidth',1.5);hold on;
% plot(ceps_env,'LineWidth',3);hold off;

%%%caculate the rate of change envlope
[imai_benv1,ceps_env,c]=imai_base(fft_origin,60,1);
[imai_benv20,ceps_env,c]=imai_base(fft_origin,60,20);
imai_benv1 = imai_benv1(1:5000);
imai_benv20 = imai_benv20(1:5000);
deviative=zeros(1,5000);
ceps_env = ceps_env(1:5000);
deviative(:) = (imai_benv1 - imai_benv20)/20;
deviative_ceps_env = zeros(1,5000);
for i=1:5000
    deviative_ceps_env(i) = deviative(i)* ceps_env(i)*20;
end
figure(5),
plot(fft_display);hold on;
plot(deviative_ceps_env,'LineWidth',1.5);hold on;
plot(ceps_env,'LineWidth',3);hold off;

%%%caculate the imai_valley cepstrum envlope
% figure(5),
% plot(fft_display);hold on;
% for i=1:8
%     [imai_venv,ceps_env,c]=imai_valley(fft_origin,60,0.6,i);
%     imai_venv = imai_venv(1:5000);
%     plot(imai_venv,'LineWidth',1.5);hold on;
% end
% ceps_env = ceps_env(1:5000);
% plot(ceps_env,'LineWidth',3);hold off;


end