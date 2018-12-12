clear
[sidetest,fs_origin] = audioread('..\data\20180828(CR vowel a test)\CR_a_700Hz.wav');
fs = 16000;
vowel_resample=resample(sidetest,fs,fs_origin);
vowel_filtered=filter([1,-0.99],[1],vowel_resample);

%FFT paramaters setting%
Nframe = 512;
Nfft = Nframe*4;
nstart = 10000;

%axis scaling%
axis_length = 8000/(fs/Nfft);
friency_axis = (1:axis_length);
friency_axis = friency_axis(:)*(fs/Nfft);

%spectrum calculating%
spectrum = getspectrum(vowel_filtered,Nframe,Nfft,fs,nstart);
spectrum_show = spectrum(1:axis_length)';
Nfft=max(size(spectrum));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lifter order setting%
M =21;
nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd

winblac = window(@blackman,nw)';
winnuttall = window(@nuttallwin,nw)';
winham = window(@hamming,nw)';
winrec = boxcar(nw)';
wflattop = flattopwin(nw)';

y1 = trapmf(1:1:(nw+1)/2,[1 1 10 (nw+1)/2]);
y2 = trapmf(1:1:(nw-1)/2,[1 1 10 (nw-1)/2]);

% y1 = winrec(((nw+1)/2):nw);
% y2 = winrec(1:(nw-1)/2);

y3 = winnuttall(((nw+1)/2):nw);
y4 = winnuttall(1:(nw-1)/2);

y5 = winnuttall(((nw+1)/2):nw);
y6 = winnuttall(1:(nw-1)/2);
% y3 = winham(((nw+1)/2):nw);
% y4 = winblac(((nw+1)/2):nw);
% y5 = winnuttall(((nw+1)/2):nw);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cepstrum method%
wzp = [y1,zeros(1,Nfft-nw), y2];

% load('matlab.mat')
% cep_liftered = wzp.*cepstrum';
cep_liftered = wzp.*real(ifft(spectrum'));
envelope = real(fft(cep_liftered));
envelope_show = envelope(1:axis_length)';

[env_peak,ceps]=imai_peak(spectrum,40,2,5,'re');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remove_lifter_order = 10;
nr = 2*remove_lifter_order-4; % almost 1 period left and right
if floor(nr/2) == nr/2, nr=nr-1; end; % make it odd
remove_lifter_window = boxcar(nr)';
wzp_harmonic_remover = [remove_lifter_window(((nr+1)/2):nr),zeros(1,Nfft-nr),...
    remove_lifter_window(1:(nr-1)/2)];

env_lifter_order = 100;
ne = 2*env_lifter_order-4; % almost 1 period left and right
if floor(ne/2) == ne/2, ne=ne-1; end; % make it odd\
env_lifter_window = window(@blackman,ne)';
% env_lifter_window = boxcar(ne)';
wzp_env_getter = [env_lifter_window(((ne+1)/2):ne),zeros(1,Nfft-ne),...
    env_lifter_window(1:(ne-1)/2)];

cep_hr_liftered = wzp_harmonic_remover.*real(ifft(spectrum'));
V=real(fft(cep_hr_liftered))';%µ¹Æ×

nIter = 3;

figure(2);
plot(friency_axis,spectrum_show,'color',[96 96 96]/255);
hold on
plot(friency_axis,V(1:axis_length),'k','LineWidth',2.0);
for i=1:nIter
    for j=1:Nfft
        if V(j)>spectrum(j)
            E(j)=spectrum(j);
        else
            E(j)=V(j);
        end
    end
    base_observer = E(1:axis_length);
%     if i==nIter
%         c=wzp_env_getter.*real(ifft(E));
%     else
        Iter_order = remove_lifter_order+i*50;
        ni = 2*Iter_order-4; % almost 1 period left and right
        if floor(ni/2) == ni/2, ni=ni-1; end; % make it odd
        remove_lifter_window = window(@blackman,ni)';
        wzp_Iter = [remove_lifter_window(((ni+1)/2):ni),zeros(1,Nfft-ni),...
            remove_lifter_window(1:(ni-1)/2)];
        c=wzp_Iter.*real(ifft(E));
        Y = real(fft(c));
        plot(friency_axis,Y(1:axis_length),'LineWidth',2.0);
%     end
    V=real(fft(c));
end
ceps_base = V(:);
ceps_base_show = ceps_base(1:axis_length)';
[base_loc,base_val] = findpeaks(ceps_base_show);
base_val = base_val(:)*(fs/Nfft);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% plot(cepstrum(1:Nfft/10),'color',[96 96 96]/255);
% hold on
% plot(friency_axis,envelope_show,'k','LineWidth',2.0);
% plot(friency_axis,env_peak(1:axis_length),'k','LineWidth',2.0);
plot(friency_axis,ceps_base_show,'r','LineWidth',2.0);
scatter(base_val,base_loc,'k');
% plot(y1,'r','LineWidth',2.0);
ylabel('amplitude(db)');xlabel('Frequency(Hz)');
hold off

figure(5)
plot(friency_axis,ceps_base_show,'r','LineWidth',2.0);
hold on
scatter(base_val,base_loc,'k');
hold off



