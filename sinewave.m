
%%  清内存 关闭窗口 准备工作
clear 
close all
clc
 
%%  signal
% 三要素
A=1;                %amplify
f=10;               %Hz
w=2*pi*f;           %rad/s
p=0;                %rad
%采样
T=1;                %s        %观测时间
fs=20*f;            %Hz       %采样频率
d=1/fs;             %s        %采样间隔
 
 
t=-T/2:d:T/2;       %离散时间t
s1=A*sin(w*t+p);    %正弦信号
s2 = A*sin(2*w*t+pi/4);
s3 =s1+s2;

f1 = abs(fft(s1));
f2 = abs(fft(s2));
f3 = log(abs(fft(s3)));

n1=A*sin(0.5*w*t+p);    %正弦信号
n2 = A*sin(1*w*t+pi/4);
n3 =n1+n2;

nf1 = abs(fft(n1));
nf2 = abs(fft(n2));
nf3 = log(abs(fft(n3)));

figure(1)
plot(t,s1);
hold on
plot(t,s2)
xlabel('时间/s');
hold off

figure(2)
plot(t,s3);
