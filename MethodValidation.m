clear

truth = csvread('Transfer_Function_CR_sweep.csv');
% L_truth = truth(1:4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% ceps_SP = xlsread('CR_SP.xls');
ceps_DT = xlsread('CR_DT.xls');
cepstrum = xlsread('CR_cepstrum.xls');

[m,n] = size(ceps_DT);
for i=1:1:n
%     ceps_SP_error(:,i) = 100*abs(ceps_SP(:,i) - truth)./truth;
    ceps_DT_error(:,i) = 100*abs(ceps_DT(:,i) - truth)./truth;
    cepstrum_error(:,i) = 100*abs(cepstrum(:,i) - truth)./truth;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pitch_ax=[150,200,250,300,350,400,450,500,550,600,650,700,750];

figure(1)
ax1 = subplot(2,1,1); 
plot(ax1,pitch_ax,ceps_DT_error(1,:),'-o','LineWidth',1.0,'color','k');
% plot(ax1,pitch_ax,F1_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax1,pitch_ax,cepstrum_error(1,:),'-*','LineWidth',1.0);
% title(ax1,'F1 error estimation');
% ylabel(ax1,'%Error');
hold off

ax2 = subplot(2,1,2); 
plot(ax2,pitch_ax,ceps_DT_error(2,:),'-o','LineWidth',1.0,'color','k');
% plot(ax2,pitch_ax,F2_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax2,pitch_ax,cepstrum_error(2,:),'-*','LineWidth',1.0);
% title(ax2,'F2 error estimation');
% ylabel(ax2,'%Error');
xlabel(ax2,'F0(Hz)');
hold off

figure(2)
ax1 = subplot(2,1,1); 
plot(ax1,pitch_ax,ceps_DT_error(3,:),'-o','LineWidth',1.0,'color','k');
% plot(ax3,pitch_ax,F3_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax1,pitch_ax,cepstrum_error(3,:),'-*','LineWidth',1.0);
% title(ax1,'F3 error estimation');
% ylabel(ax1,'%Error');
hold off

ax2 = subplot(2,1,2); 
plot(ax2,pitch_ax,ceps_DT_error(4,:),'-o','LineWidth',1.0,'color','k');
% plot(ax1,pitch_ax,F4_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax2,pitch_ax,cepstrum_error(4,:),'-*','LineWidth',1.0);
% title(ax2,'F4 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'pitch(Hz)');
xlabel(ax2,'F0(Hz)');
hold off

figure(3)
ax1 = subplot(2,1,1); 
plot(ax1,pitch_ax,ceps_DT_error(5,:),'-o','LineWidth',1.0,'color','k');
hold on
plot(ax1,pitch_ax,cepstrum_error(5,:),'-*','LineWidth',1.0);
% title(ax1,'D1 error estimation');
% ylabel(ax1,'%Error');
% xlabel(ax1,'pitch(Hz)');
hold off


ax2 = subplot(2,1,2); 
plot(ax2,pitch_ax,ceps_DT_error(6,:),'-o','LineWidth',1.0,'color','k');
hold on
plot(ax2,pitch_ax,cepstrum_error(6,:),'-*','LineWidth',1.0);
% title(ax2,'D2 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'pitch(Hz)');
xlabel(ax2,'F0(Hz)');
hold off;

% figure(2)
% plot(pitch_ax,F2_error_old,'-o','LineWidth',2.0);
% hold on
% plot(pitch_ax,F2_error_new,'-*','LineWidth',2.0);
% title('F1 error estimation');
% ylabel('%Error');
% xlabel('pitch(Hz)');
% hold off;

