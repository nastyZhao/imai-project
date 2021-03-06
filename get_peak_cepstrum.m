function [peak_cepstrum,peak_spec,peak_env] = get_peak_cepstrum(spectrum,Nfft,nIter,M)

% M =38;
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)

cepstrum = real(ifft(spectrum'));
cep_liftered = h.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));

peak_hat = zeros(1,Nfft);
residual_spectrum=max(spectrum'-envelope,0);
V = envelope;

for i=1:nIter
  c=h.*real(ifft(residual_spectrum));
  peak_hat(:)=real(fft(c));
  V(:)=V+peak_hat;
  residual_spectrum(:)=max(residual_spectrum-peak_hat,0);
end

peak_cepstrum = real(ifft(residual_spectrum));
peak_spec = residual_spectrum;
peak_env = V;

end