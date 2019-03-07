clear;

% period=59;

% tt =1:1/period:15000;
% % yy = glotlf(0,tt);
% % audiowrite('glottal125.wav',yy,16000);
% % sound(yy);
% 
snr=30;
% 
% waveros = glotros(0,tt);
[sidetest,fs_origin] = audioread('glottal_jitter\glottal750_jitter.wav');
Ps=sum(abs(sidetest(:)).^2)/length(sidetest(:));

waveos_noise=awgn(sidetest,snr,'measured','db');%以分布为单位，此时snr=10*log10(Ps/Pn)
noise=waveos_noise-sidetest;
Pn=sum(abs(noise(:)).^2)/length(noise(:));
snr_out1=10*log10(Ps/Pn);

% cycle = 354;
% newwave = [];
% for i=1:cycle:748000
%     strenchRand = unidrnd(5)-1;
%     newCycle = [];
%     if strenchRand == 0
%         newCycle = waveros(i:i+cycle-1);
%     elseif strenchRand == 1
%         newCycle = waveros(i:i+cycle+1);
%     elseif strenchRand == 2
%         newCycle = waveros(i:i+cycle);
%     elseif strenchRand == 3
%         newCycle = waveros(i:i+cycle);
%     else
%         newCycle = waveros(i:i+cycle);
%     end
%     newwave = [newwave';newCycle']';       
% end


audiowrite('glottal_jitter\glottal750_jitter_30hnr.wav',waveos_noise,44100);