clear

truth = csvread('validation formants_SC_nuttal_compare\Transfer_Function_CR.csv',1,0);
L_truth = truth(1:4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
old_130 = csvread('validation formants_SC_nuttal_compare\CepstrumResult_130Hz_165order_CR.csv',1,0);
new_130=csvread('validation formants_SC_nuttal_compare\NewMethodResult_130Hz_165order_CR.csv',1,0);
% LPC_130=csvread('validation formants\LPC_130Hz_CR.csv',1,0);
error_old_130 = 100*abs(old_130 - truth)./truth;
error_new_130 = 100*abs(new_130 - truth)./truth;
% error_LPC_130 = 100*abs(LPC_130 - L_truth)./L_truth;

old_200 = csvread('validation formants_SC_nuttal_compare\CepstrumResult_200Hz_108order_CR.csv',1,0);
new_200=csvread('validation formants_SC_nuttal_compare\NewMethodResult_200Hz_108order_CR.csv',1,0);
% LPC_200=csvread('validation formants\LPC_200Hz_CR.csv',1,0);
error_old_200 = 100*abs(old_200 - truth)./truth;
error_new_200 = 100*abs(new_200 - truth)./truth;
% error_LPC_200 = 100*abs(LPC_200 - L_truth)./L_truth;


old_250 = csvread('validation formants_SC_nuttal_compare\CepstrumResult_250Hz_85order_CR.csv',1,0);
new_250=csvread('validation formants_SC_nuttal_compare\NewMethodResult_250Hz_85order_CR.csv',1,0);
% LPC_250=csvread('validation formants\LPC_250Hz_CR.csv',1,0);
error_old_250 = 100*abs(old_250 - truth)./truth;
error_new_250 = 100*abs(new_250 - truth)./truth;
% error_LPC_250 = 100*abs(LPC_250 - L_truth)./L_truth;


old_300=csvread('validation formants_SC_nuttal_compare\CepstrumResult_293Hz_75order_CR.csv',1,0);
new_300=csvread('validation formants_SC_nuttal_compare\NewMethodResult_293Hz_75order_CR.csv',1,0);
% LPC_300=csvread('validation formants\LPC_300Hz_CR.csv',1,0);
error_old_300 = 100*abs(old_300- truth)./truth;
error_new_300 = 100*abs(new_300 - truth)./truth;
% error_LPC_300 = 100*abs(LPC_300 - L_truth)./L_truth;


old_350=csvread('validation formants_SC_nuttal_compare\CepstrumResult_350Hz_124order_CR.csv',1,0);
new_350=csvread('validation formants_SC_nuttal_compare\NewMethodResult_350Hz_124order_CR.csv',1,0);
% LPC_350=csvread('validation formants\LPC_350Hz_CR.csv',1,0);
error_old_350 = 100*abs(old_350- truth)./truth;
error_new_350 = 100*abs(new_350 - truth)./truth;
% error_LPC_350 = 100*abs(LPC_350 - L_truth)./L_truth;


old_400=csvread('validation formants_SC_nuttal_compare\CepstrumResult_400Hz_108order_CR.csv',1,0);
new_400=csvread('validation formants_SC_nuttal_compare\NewMethodResult_400Hz_108order_CR.csv',1,0);
% LPC_400=csvread('validation formants\LPC_400Hz_CR.csv',1,0);
error_old_400 = 100*abs(old_400- truth)./truth;
error_new_400 = 100*abs(new_400 - truth)./truth;
% error_LPC_400 = 100*abs(LPC_400 - L_truth)./L_truth;


old_450=csvread('validation formants_SC_nuttal_compare\CepstrumResult_450Hz_95order_CR.csv',1,0);
new_450=csvread('validation formants_SC_nuttal_compare\NewMethodResult_450Hz_95order_CR.csv',1,0);
% LPC_450=csvread('validation formants\LPC_450Hz_CR.csv',1,0);
error_old_450 = 100*abs(old_450- truth)./truth;
error_new_450 = 100*abs(new_450 - truth)./truth;
% error_LPC_450 = 100*abs(LPC_450 - L_truth)./L_truth;


old_500=csvread('validation formants_SC_nuttal_compare\CepstrumResult_500Hz_85order_CR.csv',1,0);
new_500=csvread('validation formants_SC_nuttal_compare\NewMethodResult_500Hz_85order_CR.csv',1,0);
% LPC_500=csvread('validation formants\LPC_500Hz_CR.csv',1,0);
error_old_500 = 100*abs(old_500 - truth)./truth;
error_new_500 = 100*abs(new_500 - truth)./truth;
% error_LPC_500 = 100*abs(LPC_500 - L_truth)./L_truth;


old_550=csvread('validation formants_SC_nuttal_compare\CepstrumResult_550Hz_75order_CR.csv',1,0);
new_550=csvread('validation formants_SC_nuttal_compare\NewMethodResult_550Hz_75order_CR.csv',1,0);
% LPC_550=csvread('validation formants\LPC_550Hz_CR.csv',1,0);
error_old_550 = 100*abs(old_550 - truth)./truth;
error_new_550 = 100*abs(new_550 - truth)./truth;
% error_LPC_550 = 100*abs(LPC_550 - L_truth)./L_truth;


old_600=csvread('validation formants_SC_nuttal_compare\CepstrumResult_600Hz_73order_CR.csv',1,0);
new_600=csvread('validation formants_SC_nuttal_compare\NewMethodResult_600Hz_73order_CR.csv',1,0);
% LPC_600=csvread('validation formants\LPC_600Hz_CR.csv',1,0);
error_old_600= 100*abs(old_600 - truth)./truth;
error_new_600 =100*abs(new_600 - truth)./truth;
% error_LPC_600 = 100*abs(LPC_600 - L_truth)./L_truth;


old_650=csvread('validation formants_SC_nuttal_compare\CepstrumResult_650Hz_68order_CR.csv',1,0);
new_650=csvread('validation formants_SC_nuttal_compare\NewMethodResult_650Hz_68order_CR.csv',1,0);
% LPC_650=csvread('validation formants\LPC_650Hz_CR.csv',1,0);
error_old_650= 100*abs(old_650 - truth)./truth;
error_new_650 =100*abs(new_650 - truth)./truth;
% error_LPC_650 = 100*abs(LPC_650 - L_truth)./L_truth;


old_700=csvread('validation formants_SC_nuttal_compare\CepstrumResult_700Hz_64order_CR.csv',1,0);
new_700=csvread('validation formants_SC_nuttal_compare\NewMethodResult_700Hz_64order_CR.csv',1,0);
% LPC_700=csvread('validation formants\LPC_700Hz_CR.csv',1,0);
error_old_700= 100*abs(old_700 - truth)./truth;
error_new_700 =100*abs(new_700 - truth)./truth;
% error_LPC_700 = 100*abs(LPC_700 - L_truth)./L_truth;

old_750=csvread('validation formants_SC_nuttal_compare\CepstrumResult_750Hz_59order_CR.csv',1,0);
new_750=csvread('validation formants_SC_nuttal_compare\NewMethodResult_750Hz_59order_CR.csv',1,0);
% LPC_750=csvread('validation formants\LPC_750Hz_CR.csv',1,0);
error_old_750= 100*abs(old_750 - truth)./truth;
error_new_750 =100*abs(new_750 - truth)./truth;
% error_LPC_750 = 100*abs(LPC_750 - L_truth)./L_truth;

A_old =  [old_130,old_200,old_250,old_300,old_350,old_400,old_450,...
    old_500,old_550,old_600,old_650,old_700,old_750];
CepstrumResult = table(A_old);
% writetable(CepstrumResult,'CepstrumResult.csv');

A_new = [new_130,new_200,new_250,new_300,new_350,new_400,new_450,...
    new_500,new_550,new_600,new_650,new_700,new_750];
BaseResult = table(A_new);
% writetable(BaseResult,'BaseResult.csv');

aa = table2array(readtable('CepstrumResult.csv'));
bb = table2array(readtable('BaseResult.csv'));
[m,n] = size(aa);
for i=1:1:n
    a(:,i) = 100*abs(aa(:,i) - truth)./truth;
    b(:,i) = 100*abs(bb(:,i) - truth)./truth;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F1_error_old = [error_old_130(1),error_old_200(1),error_old_250(1),error_old_300(1),error_old_350(1),error_old_400(1),error_old_450(1),error_old_500(1),error_old_550(1),error_old_600(1),error_old_650(1),error_old_700(1),error_old_750(1)];
F1_error_new = [error_new_130(1),error_new_200(1),error_new_250(1),error_new_300(1),error_new_350(1),error_new_400(1),error_new_450(1),error_new_500(1),error_new_550(1),error_new_600(1),error_new_650(1),error_new_700(1),error_new_750(1)];
% F1_error_LPC = [error_LPC_130(1),error_LPC_200(1),error_LPC_250(1),error_LPC_300(1),error_LPC_350(1),error_LPC_400(1),error_LPC_450(1),error_LPC_500(1),error_LPC_550(1),error_LPC_600(1),error_LPC_650(1),error_LPC_700(1),error_LPC_750(1)];

F2_error_old = [error_old_130(2),error_old_200(2),error_old_250(2),error_old_300(2),error_old_350(2),error_old_400(2),error_old_450(2),error_old_500(2),error_old_550(2),error_old_600(2),error_old_650(2),error_old_700(2),error_old_750(2)];
F2_error_new = [error_new_130(2),error_new_200(2),error_new_250(2),error_new_300(2),error_new_350(2),error_new_400(2),error_new_450(2),error_new_500(2),error_new_550(2),error_new_600(2),error_new_650(2),error_new_700(2),error_new_750(2)];
% F2_error_LPC = [error_LPC_130(2),error_LPC_200(2),error_LPC_250(2),error_LPC_300(2),error_LPC_350(2),error_LPC_400(2),error_LPC_450(2),error_LPC_500(2),error_LPC_550(2),error_LPC_600(2),error_LPC_650(2),error_LPC_700(2),error_LPC_750(2)];

F3_error_old =[error_old_130(3),error_old_200(3),error_old_250(3),error_old_300(3),error_old_350(3),error_old_400(3),error_old_450(3),error_old_500(3),error_old_550(3),error_old_600(3),error_old_650(3),error_old_700(3),error_old_750(3)];
F3_error_new = [error_new_130(3),error_new_200(3),error_new_250(3),error_new_300(3),error_new_350(3),error_new_400(3),error_new_450(3),error_new_500(3),error_new_550(3),error_new_600(3),error_new_650(3),error_new_700(3),error_new_750(3)];
% F3_error_LPC = [error_LPC_130(3),error_LPC_200(3),error_LPC_250(3),error_LPC_300(3),error_LPC_350(3),error_LPC_400(3),error_LPC_450(3),error_LPC_500(3),error_LPC_550(3),error_LPC_600(3),error_LPC_650(3),error_LPC_700(3),error_LPC_750(3)];


F4_error_old =[error_old_130(4),error_old_200(4),error_old_250(4),error_old_300(4),error_old_350(4),error_old_400(4),error_old_450(4),error_old_500(4),error_old_550(4),error_old_600(4),error_old_650(4),error_old_700(4),error_old_750(4)];
F4_error_new = [error_new_130(4),error_new_200(4),error_new_250(4),error_new_300(4),error_new_350(4),error_new_400(4),error_new_450(4),error_new_500(4),error_new_550(4),error_new_600(4),error_new_650(4),error_new_700(4),error_new_750(4)];
% F4_error_LPC = [error_LPC_130(4),error_LPC_200(4),error_LPC_250(4),error_LPC_300(4),error_LPC_350(4),error_LPC_400(4),error_LPC_450(4),error_LPC_500(4),error_LPC_550(4),error_LPC_600(4),error_LPC_650(4),error_LPC_700(4),error_LPC_750(4)];

D1_error_old =[error_old_130(5),error_old_200(5),error_old_250(5),error_old_300(5),error_old_350(5),error_old_400(5),error_old_450(5),error_old_500(5),error_old_550(5),error_old_600(5),error_old_650(5),error_old_700(5),error_old_750(5)];
D1_error_new = [error_new_130(5),error_new_200(5),error_new_250(5),error_new_300(5),error_new_350(5),error_new_400(5),error_new_450(5),error_new_500(5),error_new_550(5),error_new_600(5),error_new_650(5),error_new_700(5),error_new_750(5)];

D2_error_old =[error_old_130(6),error_old_200(6),error_old_250(6),error_old_300(6),error_old_350(6),error_old_400(6),error_old_450(6),error_old_500(6),error_old_550(6),error_old_600(6),error_old_650(6),error_old_700(6),error_old_750(6)];
D2_error_new = [error_new_130(6),error_new_200(6),error_new_250(6),error_new_300(6),error_new_350(6),error_new_400(6),error_new_450(6),error_new_500(6),error_new_550(6),error_new_600(6),error_new_650(6),error_new_700(6),error_new_750(6)];


pitch_ax=[130,200,250,300,350,400,450,500,550,600,650,700,750];

figure(1)
ax1 = subplot(2,1,1); 
plot(ax1,pitch_ax,a(1,:),'-o','LineWidth',2.0);
% plot(ax1,pitch_ax,F1_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax1,pitch_ax,b(1,:),'-*','LineWidth',2.0);
title(ax1,'F1 error estimation');
ylabel(ax1,'%Error');


ax2 = subplot(2,1,2); 
plot(ax2,pitch_ax,a(2,:),'-o','LineWidth',2.0);
% plot(ax2,pitch_ax,F2_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax2,pitch_ax,b(2,:),'-*','LineWidth',2.0);
title(ax2,'F2 error estimation');
ylabel(ax2,'%Error');
hold off

figure(2)
ax1 = subplot(2,1,1); 
plot(ax1,pitch_ax,a(3,:),'-o','LineWidth',2.0);
% plot(ax3,pitch_ax,F3_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax1,pitch_ax,b(3,:),'-*','LineWidth',2.0);
title(ax1,'F3 error estimation');
ylabel(ax1,'%Error');


ax2 = subplot(2,1,2); 
plot(ax2,pitch_ax,a(4,:),'-o','LineWidth',2.0);
% plot(ax1,pitch_ax,F4_error_LPC,'-o','LineWidth',2.0);
hold on
plot(ax2,pitch_ax,b(4,:),'-*','LineWidth',2.0);
title(ax2,'F4 error estimation');
ylabel(ax2,'%Error');
xlabel(ax2,'pitch(Hz)');
hold off

% figure(3)
% ax1 = subplot(2,1,1); 
% plot(ax1,pitch_ax,D1_error_old,'-o','LineWidth',2.0);
% hold on
% plot(ax1,pitch_ax,D1_error_new,'-*','LineWidth',2.0);
% title(ax1,'D1 error estimation');
% ylabel(ax1,'%Error');
% xlabel(ax1,'pitch(Hz)');
% 
% 
% ax2 = subplot(2,1,2); 
% plot(ax2,pitch_ax,D2_error_old,'-o','LineWidth',2.0);
% hold on
% plot(ax2,pitch_ax,D2_error_new,'-*','LineWidth',2.0);
% title(ax2,'D2 error estimation');
% ylabel(ax2,'%Error');
% xlabel(ax2,'pitch(Hz)');
% hold off;

% figure(2)
% plot(pitch_ax,F2_error_old,'-o','LineWidth',2.0);
% hold on
% plot(pitch_ax,F2_error_new,'-*','LineWidth',2.0);
% title('F1 error estimation');
% ylabel('%Error');
% xlabel('pitch(Hz)');
% hold off;

