function [y,ceps]=imai_peak(spectrum,M,alpha,nIter,ws)
%ENV_CEPS Gets spectral envelope.
%	S=ENV_CEPS(X,M)
%	[S,C]=ENV_CEPS(X,M,ALPHA,NITER)
%
%	Input
%	      X: input FFT amplitude
%	      M: order of cepstrum. default is 30.
%	  ALPHA: acceralator factor. default is 1.0.
%	  NITER: iteration count. default is 3.
%
%	Output
%	      S: spectral envelope
%	      C: cepstrum modulus
%
%	Example
%	  s0=env_ceps(x,30);
%	  plot(log10(abs(fft(x)).^2)),set(gca,'XLim',[0 length(x)/2])
%	  hold on, plot(s,'w-'), hold off

%	Author: H. Tamagawa, 12-14-94
%	Copyright (c) 1994 by ATR Human Information Processing Research Lab.

%	References:
%	  [1] $B:#0f(B, $B0$It(B: "$B2~NI%1%W%9%H%i%`K!$K$h$k%9%Z%/%H%kJqMm$NCj=P(B", $B?.(B
%	      $B3XO@(B($B#A(B), J62-A, 4, p-217($B><(B54-04)

% if nargin<5,ws='hn';end
% if nargin<4,nIter=3;end
% if nargin<3,alpha=1.0;end
% if nargin<2,M=50;end;
clear;
ws='re';
M = 60-3;

% if M>fix(n/2) M=fix(0.95*n/2);end;
if ws=='re'
  w=ones(1,2*M+1);
elseif ws=='hn'
  w=hanning(2*M+1).';
else
  w=hamming(2*M+1).';
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&

% [sidetest,fs_origin] = audioread('..\data\CR_A_30HNR_JITTER\CR_A_250.wav');
% 
% fs = 24000;
% vowel_resample=resample(sidetest,fs,fs_origin);
% vowel_filtered=filter([1,-0.97],[1],vowel_resample);
% 
% %FFT paramaters setting%
% Nframe = 600;
% Nfft = 2048;
% nstart = 5000;
% M = 40-3;
% %axis scaling%
% axis_length = 4096/(fs/Nfft);
% friency_axis = (1:axis_length);
% friency_axis = friency_axis(:)*(fs/Nfft);
% 
% vowel_blocked = vowel_filtered(nstart+1:nstart+Nframe);
% spectrum = getspectrum(vowel_blocked,Nframe,Nfft,'bla');
% 
% alpha = 0;
% nIter = 1;
% M = 40;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=spectrum(:).';
n=max(size(spectrum));


w=ones(1,2*M+1);
h=[w(M+1:-1:1) zeros(1,n-2*M-1) w(1:M)];%w(M+1:-1:1) -1±íÊ¾·´Ïò¸³Öµ£¬h(1)=w(M+1)...h(M+1)=w(1)

Ehat=zeros(1,n);
c=h.*real(ifft(S));
ceps = real(ifft(S));
V=real(fft(c));%µ¹Æ×
E=max(S-V,0);
%   Q = max(S,V)

%   for i=1:nIter
%       c=h.*real(ifft(Q));
%       Qhat(:)=real(fft(c));
%       V(:)=V+Qhat;
%       Q(:)=max(Q,Qhat);
%   end;

for i=1:nIter
  c=h.*real(ifft(E));
  Ehat(:)=(1+alpha)*real(fft(c));
  V(:)=V+Ehat;
  E(:)=max(E-Ehat,0);
end;
y=V(:)/2;
y=V(:);

% if nargout>1
%   c=real(ifft(V(:)));
%   c=c(1:M);
% end

% figure(7)
% plot(friency_axis,S(1:axis_length));
% hold on
% plot(friency_axis,Qhat(1:axis_length));
% % plot(friency_axis,y(1:axis_length));



end

% end of senv.m
