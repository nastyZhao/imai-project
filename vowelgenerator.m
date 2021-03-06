clear;
F =  [700, 1220, 2600]; % Formant frequencies (Hz)
BW = [130,  70,  160];  % Formant bandwidths (Hz)
fs = 8192;              % Sampling rate (Hz)

nsecs = length(F);
R = exp(-pi*BW/fs);     % Pole radii
theta = 2*pi*F/fs;      % Pole angles
poles = R .* exp(j*theta); % Complex poles 
B = 1;  A = real(poly([poles,conj(poles)]));
% freqz(B,A); % View frequency response:

% Convert to parallel complex one-poles (PFE):
[r,p,f] = residuez(B,A);
As = zeros(nsecs,3);
Bs = zeros(nsecs,3);
% complex-conjugate pairs are adjacent in r and p:
for i=1:2:2*nsecs
    k = 1+(i-1)/2;
    Bs(k,:) = [r(i)+r(i+1),  -(r(i)*p(i+1)+r(i+1)*p(i)), 0];
    As(k,:) = [1, -(p(i)+p(i+1)), p(i)*p(i+1)];
end
sos = [Bs,As]; % standard second-order-section form
iperr = norm(imag(sos))/norm(sos); % make sure sos is ~real
disp(sprintf('||imag(sos)||/||sos|| = %g',iperr)); % 1.6e-16
sos = real(sos) % and make it exactly real

% Reconstruct original numerator and denominator as a check:
[Bh,Ah] = sos2tf(sos); % parallel sos to transfer function
% psos2tf appears in the matlab-utilities appendix
disp(sprintf('||A-Ah|| = %g',norm(A-Ah))); % 5.77423e-15
% Bh has trailing epsilons, so we'll zero-pad B:
disp(sprintf('||B-Bh|| = %g',...
    norm([B,zeros(1,length(Bh)-length(B))] - Bh)));
% 1.25116e-15

% Plot overlay and sum of all three 
% resonator amplitude responses:
nfft=512;
H = zeros(nsecs+1,nfft);
for i=1:nsecs
  [Hiw,w] = freqz(Bs(i,:),As(i,:));
  H(1+i,:) = Hiw(:).';
end
H(1,:) = sum(H(2:nsecs+1,:));
ttl = 'Amplitude Response'; 
xlab = 'Frequency (Hz)';
ylab = 'Magnitude (dB)';
sym = ''; 
lgnd = {'sum','sec 1','sec 2', 'sec 3'};
np=nfft/2; % Only plot for positive frequencies
wp = w(1:np); Hp=H(:,1:np);
% figure(1); clf;
% plot(wp,20*log10(abs(Hp)));


% nsamps = 8192;
% f0 = 500; % Pitch in Hz
% w0T = 2*pi*f0/fs; % radians per sample
% 
% nharm = floor((fs/2)/f0); % number of harmonics
% sig = zeros(1,nsamps);
% n = 0:(nsamps-1);
% % Synthesize bandlimited impulse train
% for i=1:nharm,
%     sig = sig + cos(i*w0T*n);
% end;
% sig = sig/max(sig);

[waveros,fs0] = audioread('glotros400jitter.wav');
speech = filter(1,A,waveros);
% soundsc([speech],8192); % hear buzz, then 'ah'
% audiowrite('vowel-A-200Hz.wav',speech,8192);

nframe = 1024;
nfft = 1024;
spectrum = getspectrum(speech,nframe,nfft,fs,100);
[envlope,cepstrum] = getcepstrum(spectrum,12);
imaibase=imai_base(spectrum,12,1,'re');

axis_length = 4000/(fs/nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/nfft);
spectrum = spectrum(1:axis_length);
envlope = envlope(1:axis_length);
imaibase = imaibase(1:axis_length);
[loc,val] = findpeaks(imaibase);
[locc,valc] = findpeaks(envlope);
val = val(:)*(fs/nfft);
valc = valc(:)*(fs/nfft);
figure(3);
plot(friency_axis,spectrum,'LineWidth',1.0);
hold on
plot(friency_axis,envlope,'LineWidth',2.0);
plot(friency_axis,imaibase,'LineWidth',2.0);
scatter(val,loc,'k');
scatter(valc,locc,'k');
hold off