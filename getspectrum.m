function spectrum_x=getspectrum(x,Nframe,Nfft,win_func)

winblac = window(@blackman,Nframe);
winnuttall = window(@nuttallwin,Nframe);
winham = window(@hamming,Nframe);
winhan = window(@hanning,Nframe);
winrec = boxcar(Nframe);
if win_func == 'ham'
    winfunc = window(@hamming,Nframe);
elseif win_func == 'han'
    winfunc = window(@hanning,Nframe);
elseif win_func == 'bla'
    winfunc = window(@blackman,Nframe);
elseif win_func == 'nut'
    winfunc = window(@nuttallwin,Nframe);
else
    winfunc = window(@blackman,Nframe);
end

x_blocked = x;
x_nonDC= x_blocked - mean(x_blocked);
x_windowed = winfunc.* x_nonDC;

spectrum_x = 20*log10(abs(fft(x_windowed,Nfft)));

end
