clear

truth_CR = csvread('validation/Transfer_Function_CR_sweep.csv');
truth_SC = xlsread('validation/Transfer_Function_SC.xls');
% L_truth = truth(1:4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% ceps_SP = xlsread('CR_SP.xls');
ceps_DT_SC = xlsread('validation/SC_RS.xls');
cepstrum_SC = xlsread('validation/SC_CEPS.xls');
praat_SC = xlsread('validation/SC_Praat.xls');

ceps_DT_CR = xlsread('validation/CR_RS.xls');
cepstrum_CR= xlsread('validation/CR_cepstrum.xls');
praat_CR = xlsread('validation/CR_Praat.xls');



[m,n] = size(ceps_DT_SC);
for i=1:1:n
%     ceps_SP_error(:,i) = 100*abs(ceps_SP(:,i) - truth)./truth;
    ceps_DT_error_CR(:,i) = 100*abs(ceps_DT_CR(:,i) - truth_CR)./truth_CR;
    cepstrum_error_CR(:,i) = 100*abs(cepstrum_CR(:,i) - truth_CR)./truth_CR;
    praat_error_CR(:,i) = 100*abs(praat_CR(:,i) - truth_CR)./truth_CR;
    
    ceps_DT_error_SC(:,i) = 100*abs(ceps_DT_SC(:,i) - truth_SC)./truth_SC;
    cepstrum_error_SC(:,i) = 100*abs(cepstrum_SC(:,i) - truth_SC)./truth_SC;
    praat_error_SC(:,i) = 100*abs(praat_SC(:,i) - truth_SC)./truth_SC;
    
    ceps_DT_error(:,i) = (ceps_DT_error_CR(:,i) + ceps_DT_error_SC(:,i))/2;
    cepstrum_error(:,i) = (cepstrum_error_CR(:,i) + cepstrum_error_SC(:,i))/2;
    praat_error(:,i)= (praat_error_CR(:,i) + praat_error_SC(:,i))/2;
    
    Es_DT(:,i) = ((ceps_DT_CR(:,i) - truth_CR).^2+(ceps_DT_SC(:,i) - truth_SC).^2)/2;
    Es_CP(:,i) = ((cepstrum_CR(:,i) - truth_CR).^2+(cepstrum_SC(:,i) - truth_SC).^2)/2;
    Es_LP(:,i) = ((praat_CR(:,i) - truth_CR).^2+(praat_SC(:,i) - truth_SC).^2)/2;
    
    
    
    euc_DT(i) = sqrt(sum(Es_DT(1:4,i))) ;
    euc_CP(i) = sqrt(sum(Es_CP(1:4,i))) ;
    euc_LP(i) = sqrt(sum(Es_LP(1:4,i))) ;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pitch_ax=[150,200,250,300,350,400,450,500,550,600,650,700,750];

figure(1)
ax1 = subplot(6,1,1); 
plot(ax1,pitch_ax,ceps_DT_error(1,:),'-o','LineWidth',1.5,'color','k');
% plot(ax1,pitch_ax,F1_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax1,pitch_ax,cepstrum_error(1,:),'-*','LineWidth',1.0);
plot(ax1,pitch_ax,praat_error(1,:),'->','LineWidth',1.0,'color','b');
% title(ax1,'F1 error estimation');
% ylabel(ax1,'%Error');
hold off

ax2 = subplot(6,1,2); 
plot(ax2,pitch_ax,ceps_DT_error(2,:),'-o','LineWidth',1.5,'color','k');
% plot(ax2,pitch_ax,F2_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax2,pitch_ax,cepstrum_error(2,:),'-*','LineWidth',1.0);
plot(ax2,pitch_ax,praat_error(2,:),'->','LineWidth',1.0,'color','b');
% title(ax2,'F2 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'F0(Hz)');
hold off


ax3 = subplot(6,1,3); 
plot(ax3,pitch_ax,ceps_DT_error(3,:),'-o','LineWidth',1.5,'color','k');
% plot(ax3,pitch_ax,F3_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax3,pitch_ax,cepstrum_error(3,:),'-*','LineWidth',1.0);
plot(ax3,pitch_ax,praat_error(3,:),'->','LineWidth',1.0,'color','b');
% title(ax1,'F3 error estimation');
% ylabel(ax1,'%Error');
hold off

ax4 = subplot(6,1,4); 
plot(ax4,pitch_ax,ceps_DT_error(4,:),'-o','LineWidth',1.5,'color','k');
% plot(ax1,pitch_ax,F4_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax4,pitch_ax,cepstrum_error(4,:),'-*','LineWidth',1.0);
plot(ax4,pitch_ax,praat_error(4,:),'->','LineWidth',1.0,'color','b');
% title(ax2,'F4 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'pitch(Hz)');
% xlabel(ax2,'F0(Hz)');
hold off


ax5 = subplot(6,1,5); 
plot(ax5,pitch_ax,ceps_DT_error(5,:),'-o','LineWidth',1.5,'color','k');
hold on
plot(ax5,pitch_ax,cepstrum_error(5,:),'-*','LineWidth',1.0);
% title(ax1,'D1 error estimation');
% ylabel(ax1,'%Error');
% xlabel(ax1,'pitch(Hz)');
hold off


ax6 = subplot(6,1,6); 
plot(ax6,pitch_ax,euc_DT,'-o','LineWidth',1.5,'color','k');
hold on
plot(ax6,pitch_ax,euc_CP,'-*','LineWidth',1.0);
plot(ax6,pitch_ax,euc_LP,'->','LineWidth',1.0,'color','b');
% title(ax2,'D2 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'pitch(Hz)');
% xlabel(ax2,'F0(Hz)');
hold off;



