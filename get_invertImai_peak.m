function [peak_ceps,peak_spec,base_env] = get_invertImai_peak(spectrum,nIter,M)

Nfft = length(spectrum);
w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,Nfft-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)

cepstrum = real(ifft(spectrum'));
cep_liftered = h.*cepstrum;
envelope = real(fft(cep_liftered));

peak_spec = max(spectrum'- envelope,0);
iter_spec = min(spectrum',envelope);
iter_env = envelope;

for i=1:nIter
     iter_ceps = real(ifft(iter_spec));
     iter_env = real(fft(h.*iter_ceps));
     iter_spec = min(iter_spec,iter_env);
     peak_spec = max(spectrum'- iter_env,0);
end

base_spec = iter_spec;
peak_ceps = real(ifft(peak_spec));
base_env = iter_env;

end

