% y = wgn(20000,1,0);
% audiowrite('white_noise_test.wav',y,44100);

y = randn(1,100000)/sqrt(1);
audiowrite('white_noise_test.wav',y,44100);