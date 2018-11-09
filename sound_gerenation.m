clear;

period=294;

tt =1:1/period:3000;
% yy = glotlf(0,tt);
% audiowrite('glottal125.wav',yy,16000);
% sound(yy);

snr=30;

waveros = glotros(0,tt);

% Ps=sum(abs(waveros(:)).^2)/length(waveros(:));
% 
% waveos_noise=awgn(waveros,snr,'measured','db');%以分布为单位，此时snr=10*log10(Ps/Pn)
% noise=waveos_noise-waveros;
% Pn=sum(abs(noise(:)).^2)/length(noise(:));
% snr_out1=10*log10(Ps/Pn);

% cycle = 176;
% newwave = [];
% for i=1:cycle:748000
%     strenchRand = unidrnd(5)-1;
%     newCycle = [];
%     if strenchRand == 0
%         newCycle = waveros(i:i+cycle-1);
%     elseif strenchRand == 1
%         newCycle = waveros(i:i+cycle-1);
%     elseif strenchRand == 2
%         newCycle = waveros(i:i+cycle-1);
%     elseif strenchRand == 3
%         newCycle = waveros(i:i+cycle);
%     else
%         newCycle = waveros(i:i+cycle);
%     end
%     newwave = [newwave';newCycle']';       
% end




% waveros = jitter(waveros,4,1);
% t=(0:1/44100:5);
% y = zeros(1,220501);
% for j = 1:5000/10
%     f=50*j;
%     x=sin(2*pi*f*t+(mod(j,3)+1)*2*pi/3);
%     y = y+x;
% end
% y = y/max(abs(y));
% sound(newwave,44100);
audiowrite('glottal150_clean.wav',waveros,44100);