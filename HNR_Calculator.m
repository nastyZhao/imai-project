clear

% [sidetest,fs_origin] = audioread('..\data\20181009(SC VOWEL CLEAN)\SC_200.wav');
[sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_400.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
% % vowel_filtered=filter([1,-0.99],[1],vowel_resample);

pitch = 400;
pitch_period = fix(fs/pitch);
% search_area = pitch_period + floor(pitch_period/4);
search_area = 480;

Nframe = 480;
Nfft = 2048;
nstart = 62;

axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

iterator = 100;
period_pool = [];
average_period = zeros(pitch_period,1);

figure(4)
% plot(vowel_resample);
hold on
for i=1:1:iterator

    search_period = vowel_resample(nstart:nstart+search_area);
    %     [peakval,peakloc] = findpeaks(search_period);
    %     if length(peakloc) > 1
    %         [maxpeak,maxpeakloc]=max(peakval);
    %         peakstamp = peakloc(maxpeakloc);
    %         period_stamp = peakloc(maxpeakloc) + nstart - 1;
    %     else
    %         peakstamp = peakloc(1);
    %         period_stamp = peakloc(1) + nstart - 1;
    %     end
    %     selected_period = vowel_resample(period_stamp+1:period_stamp+pitch_period);
    %     nstart = period_stamp;
    nstart = nstart+240;
    
    %     plot(selected_period);
    %     scatter(peakloc(maxpeakloc),maxpeak,'k');
    period_pool(:,i) = search_period;
end

average_period = mean(period_pool,2);
Pw_average = iterator*sum(average_period.^2);
spectrum = getspectrum(average_period,480,2048,16000,1);

demowithnoise = vowel_resample(nstart:nstart+search_area);
demo_spectrum = getspectrum(demowithnoise,480,2048,16000,1);

noise_spectrum = demo_spectrum - spectrum;
% Pw_noise = 0;

figure(1);
plot(friency_axis,noise_spectrum(1:axis_length));


% for j=1:1:iterator
%    noise = period_pool(:,j)- average_period;
%    Pw_noise_period = sum(noise.^2);
%    Pw_noise = Pw_noise+Pw_noise_period;
% end
% 
% HNR_ratio = 10*log10(Pw_average/Pw_noise);