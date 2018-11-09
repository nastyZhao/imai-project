% Specify formant resonances for an "ah" [a] vowel:
F = [700, 1220, 2600]; % Formant frequencies in Hz
B = [130,   70,  160]; % Formant bandwidths in Hz

fs = 8192;  % Sampling rate in Hz
	    % ("telephone quality" for speed)
        


R = exp(-pi*B/fs);     % Pole radii
theta = 2*pi*F/fs;     % Pole angles
poles = R .* exp(j*theta);
[B,A] = zp2tf(0,[poles,conj(poles)],1);

f0 = 200; % Fundamental frequency in Hz
w0T = 2*pi*f0/fs;

nharm = floor((fs/2)/f0); % number of harmonics
nsamps = fs;  % make a second's worth
sig = zeros(1,nsamps);
n = 0:(nsamps-1);
% Synthesize bandlimited impulse train:
for i=1:nharm,
    sig = sig + cos(i*w0T*n);
end;
sig = sig/max(sig);
soundsc(sig,fs); % Let's hear it

% Now compute the speech vowel:
speech = filter(1,A,sig);
soundsc([sig,speech],fs); % "buzz", "ahh"
% (it would sound much better with a little vibrato)

Nframe = 2^nextpow2(fs/25); % frame size = 40 ms
w = hamming(Nframe)';
winspeech = w .* speech(1:Nframe);
Nfft = 4*Nframe; % factor of 4 zero-padding
sspec = fft(winspeech,Nfft);
dbsspecfull = 20*log(abs(sspec));
rcep = ifft(dbsspecfull);  % real cepstrum
rcep = real(rcep); % eliminate round-off noise in imag part
period = round(fs/f0) % 41
nspec = Nfft/2+1;
aliasing = norm(rcep(nspec-10:nspec+10))/norm(rcep) % 0.02
nw = period-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd
w = boxcar(nw)'; % rectangular window
wzp = [w(((nw+1)/2):nw),zeros(1,Nfft-nw), ...
       w(1:(nw-1)/2)];  % zero-phase version
wrcep = wzp .* rcep;  % window the cepstrum ("lifter")
rcepenv = fft(wrcep); % spectral envelope
rcepenvp = real(rcepenv(1:nspec)); % should be real
% rcepenvp = rcepenvp - mean(rcepenvp); % normalize to zero mean


M = 6; % Assume three formants and no noise

% compute Mth-order autocorrelation function:
rx = zeros(1,M+1)';
for i=1:M+1,
  rx(i) = rx(i) + speech(1:nsamps-i+1) ...
                * speech(1+i-1:nsamps)';
end

% prepare the M by M Toeplitz covariance matrix:
covmatrix = zeros(M,M);
for i=1:M,
  covmatrix(i,i:M) = rx(1:M-i+1)';
  covmatrix(i:M,i) = rx(1:M-i+1);
end

% solve "normal equations" for prediction coeffs:

Acoeffs = - covmatrix \ rx(2:M+1)

Alp = [1,Acoeffs']; % LP polynomial A(z)

axis_length = 4096/(fs/Nfft);
friency_axis = (1:1025);
friency_axis = friency_axis(:)*(fs/Nfft);

dbenvlp = 20*log10(abs(freqz(1,Alp,nspec)'));
dbsspecn = dbsspecfull(1:nspec) + ones(1,nspec)*(max(dbenvlp) - max(dbsspecfull(1:nspec))); % normalize

figure(2)
plot(friency_axis,dbsspecfull(1:nspec)); grid;
hold on
plot(friency_axis,rcepenvp,'LineWidth',2.0);
ylabel('Õñ·ù£¨db£©');xlabel('ÆµÂÊ(Hz)');

