function [y,ceps,c]=imai_valley(x,M,alpha,nIter,ws)

if nargin<5,ws='hn';end
if nargin<4,nIter=3;end
if nargin<3,alpha=1.0;end
if nargin<2,M=50;end;

X=x(:).';
n=max(size(x));

if M>fix(n/2) M=fix(0.95*n/2);end;
if ws=='re'
  w=ones(1,2*M+1);
elseif ws=='hn'
  w=hanning(2*M+1).';
else
  w=hamming(2*M+1).';
end;

hn=floor(n/2)+1;

h=[w(M+1:-1:1) zeros(1,n-2*M-1) w(1:M)];%w(M+1:-1:1) -1表示反向赋值，h(1)=w(M+1)...h(M+1)=w(1)
S=log10(abs(X).^2);%能量谱

Ehat=zeros(1,n);
c=h.*real(ifft(S));
ceps = real(fft(c));
V=real(fft(c));%倒谱
E=max(V-S,0);

for i=1:nIter
  c=h.*real(ifft(E));
  Ehat(:)=(1+alpha)*real(fft(c));
  V(:)=V-Ehat;
  E(:)=max(Ehat-E,0);
end
y = V(:);
end