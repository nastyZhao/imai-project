function [envelope,cepstrum]=getcepstrum(spectrum,M)

Nfft=max(size(spectrum));
% w=boxcar(2*M+1).';
% h=[w(M+1:-1:1) zeros(1,n-2*M-1) w(1:M)];

nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd
w = boxcar(nw)'; % rectangular window
wzp = [w(((nw+1)/2):nw),zeros(1,Nfft-nw), ...
       w(1:(nw-1)/2)];


cepstrum = ifft(spectrum);
cep_liftered = wzp.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));
% envelope = envelope - mean(envelope);
end