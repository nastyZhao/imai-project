clear

[sidetest,fs_origin] = audioread('..\data\20180828(CR vowel a test)\CR_a_750Hz.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
% vowel_filtered=filter([1,-0.99],[1],vowel_resample);

pitch = 750;
pitch_period = 21;

Nframe = 19;
Nfft = 1024;
nstart = 32;

iterator = 4;
period_pool = [];
average_period = zeros(pitch_period,1);

figure(1)
hold on
for i=1:1:iterator
   
   selected_period = vowel_resample(nstart:nstart+pitch_period-1);
   nstart = nstart+pitch_period;
   plot(selected_period);
   period_pool(:,i) = selected_period;
   average_period = average_period+selected_period;
end

average_period = average_period/iterator;
Pw_average = iterator*sum(average_period.^2);

Pw_noise = 0;
for j=1:1:iterator
   noise = period_pool(:,j)- average_period;
   Pw_noise_period = sum(noise.^2);
   Pw_noise = Pw_noise+Pw_noise_period;
end

HNR_ratio = 10*log10(Pw_average/Pw_noise);