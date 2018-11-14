clear
[sidetest,fs_origin] = audioread('..\data\20181009(SC VOWEL CLEAN)\SC_750_clean.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
% vowel_filtered=filter([1,-0.99],[1],vowel_resample);


Nframe = 480;
Nfft = Nframe*4;
nstart = 15000;

axis_length = 8000/(fs/Nfft);
M =40;

friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);


spectrum = getspectrum(vowel_resample,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';
Nfft=max(size(spectrum));
% w=boxcar(2*M+1).';
% h=[w(M+1:-1:1) zeros(1,n-2*M-1) w(1:M)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd

winblac = window(@blackman,nw)';
winnuttall = window(@nuttallwin,nw)';
winham = window(@hamming,nw)';
winrec = boxcar(nw)';
wflattop = flattopwin(nw)';

% y1 = trapmf(1:1:(nw+1)/2,[1 1 (nw-1)/4 (nw+1)/2]);
% y2 = trapmf(1:1:(nw-1)/2,[1 1 (nw-1)/4 (nw-1)/2]);

y1 = winrec(((nw+1)/2):nw);
y2 = winrec(1:(nw-1)/2);

y3 = winnuttall(((nw+1)/2):nw);
y4 = winnuttall(1:(nw-1)/2);

y5 = winnuttall(((nw+1)/2):nw);
y6 = winnuttall(1:(nw-1)/2);
% y3 = winham(((nw+1)/2):nw);
% y4 = winblac(((nw+1)/2):nw);
% y5 = winnuttall(((nw+1)/2):nw);

wzp = [y5,zeros(1,Nfft-nw), y6];

% load('matlab.mat')
cep_liftered = wzp.*real(ifft(spectrum'));
% cep_liftered = wzp.*cepstrum';
envelope = real(fft(cep_liftered));
envelope_show = envelope(1:axis_length)';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wzp_base = [y1,zeros(1,Nfft-nw), y2];
Ehat=zeros(1,Nfft)';
V=envelope';%����
E=max(spectrum-V,0);

for i=1:5
    for j=1:Nfft
        if V(j)>spectrum(j)
            E(j)=spectrum(j);
        else
            E(j)=V(j);
        end
    end
    c=wzp_base.*real(ifft(E))';
    V=real(fft(c));
end
ceps_base = V(:);
ceps_base_show = ceps_base(1:axis_length)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(12);
plot(friency_axis,spectrum_show,'color',[96 96 96]/255);
% plot(cepstrum(1:Nfft/10),'color',[96 96 96]/255);
hold on
plot(friency_axis,envelope_show,'k','LineWidth',2.0);
% plot(friency_axis,ceps_base_show,'r','LineWidth',2.0);
% plot(y1,'r','LineWidth',2.0);
ylabel('amplitude(db)');xlabel('Frequency(Hz)');
hold off




