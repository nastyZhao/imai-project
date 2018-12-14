
%%  ���ڴ� �رմ��� ׼������
clear 
close all
clc
 
%%  signal
% ��Ҫ��
A=1;                %amplify
f=10;               %Hz
w=2*pi*f;           %rad/s
p=0;                %rad
%����
T=1;                %s        %�۲�ʱ��
fs=20*f;            %Hz       %����Ƶ��
d=1/fs;             %s        %�������
 
 
t=-T/2:d:T/2;       %��ɢʱ��t
s1=A*sin(w*t+p);    %�����ź�
s2 = A*sin(2*w*t+pi/4);
s3 =s1+s2;

f1 = abs(fft(s1));
f2 = abs(fft(s2));
f3 = log(abs(fft(s3)));

n1=A*sin(0.5*w*t+p);    %�����ź�
n2 = A*sin(1*w*t+pi/4);
n3 =n1+n2;

nf1 = abs(fft(n1));
nf2 = abs(fft(n2));
nf3 = log(abs(fft(n3)));

figure(1)
plot(t,s1);
hold on
plot(t,s2)
xlabel('ʱ��/s');
hold off

figure(2)
plot(t,s3);
