function [y,E]=imai_base(spectrum,M,nIter)
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

if nargin<5,ws='hn';end
if nargin<2,M=50;end;

S=spectrum(:).';
n=max(size(spectrum));


% w=ones(1,2*M+1);
% hn=floor(n/2)+1;


nw = 2*M-4; % almost 1 period left and right
if floor(nw/2) == nw/2, nw=nw-1; end; % make it odd

winblac = window(@blackman,nw)';
winnuttall = window(@nuttallwin,nw)';
winham = window(@hamming,nw)';
winrec = boxcar(nw)';
wflattop = flattopwin(nw)';
wturkey = tukeywin(nw,0.75)';

% y1 = trapmf(1:1:(nw+1)/2,[1 1 10 (nw+1)/2]);
% y2 = trapmf(1:1:(nw-1)/2,[1 1 (nw-1)/4 (nw-1)/2]);

y1 = winblac(((nw+1)/2):nw);
y2 = winblac(1:(nw-1)/2);

wzp = [y1,zeros(1,n-nw), y2];

% h=[w(M+1:-1:1) zeros(1,n-2*M-1) w(1:M)];%w(M+1:-1:1) -1±íÊ¾·´Ïò¸³Öµ£¬h(1)=w(M+1)...h(M+1)=w(1)


Ehat=zeros(1,n);
c=wzp.*real(ifft(S));
ceps = real(fft(c));
V=real(fft(c));%µ¹Æ×
E=max(S-V,0);

for i=1:nIter
    for j=1:n
        if V(j)>S(j)
            E(j)=S(j);
        else
            E(j)=V(j);
        end
    end
    c=wzp.*real(ifft(E));
    V=real(fft(c));
end
y = V(:);

% friency_axis = (1:5000/(16000/512));
% friency_axis = friency_axis(:)*(16000/512);
% figure(1);
% E = E(1:5000/(16000/512));
% plot(friency_axis,E);
% title('Spectrum only keep the base');
% ylabel('20*LOG|F|');
% xlabel('Frequency(Hz)');
% 
% figure(2);
% S = S(1:5000/(16000/512))
% ceps = ceps(1:5000/(16000/512));
% plot(friency_axis,S);
% hold on;
% plot(friency_axis,ceps,'LineWidth',1.5);
% title('First cepstrum analyse');
% ylabel('20*LOG|F|');
% xlabel('Frequency(Hz)');
% 
% figure(3);
% plot(friency_axis,E);
% hold on;
% plot(friency_axis,y,'LineWidth',1.5);
% title('Second cepstrum analyse');
% ylabel('20*LOG|F|');
% xlabel('Frequency(Hz)');
end
% % y=V(:)/2;
% y=V(:);
% 
% if nargout>1
%   c=real(ifft(V(:)));
%   c=c(1:M);
% end%

% end of senv.m
