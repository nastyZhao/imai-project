function spectrum_x=getspectrum(x,Nframe,Nfft,fs,nstart)

x_windowed = x(nstart+1:nstart+Nframe);
winblac = window(@blackman,Nframe);
winnuttall = window(@nuttallwin,Nframe);
winham = window(@hamming,Nframe);
winrec = boxcar(Nframe);
x_windowed = winblac.* x_windowed;

spectrum_x = 20*log10(abs(fft(x_windowed,Nfft)));
% spectrum_x = spectrum_x_o(1:3000/(fs/Nfft));

friency_axis = (1:6000/(fs/Nfft));
friency_axis = friency_axis(:)*(fs/Nfft);

% figure(n+10);
% plot(friency_axis,spectrum_x);
% title('boosttest');
end
