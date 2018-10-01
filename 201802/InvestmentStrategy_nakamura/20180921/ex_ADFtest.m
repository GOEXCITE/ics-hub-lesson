% ex_ADFtest.m
% 9.21.2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
warning off;

global ydays;
ydays=252;

w=csvread('DaiwaNomura.csv',1,0); ymd=w(:,1);St=w(:,2:end);

ymd0=20160401;
ymd1=20170915;
%ymd1=20180920;
i=find(ymd>=ymd0 & ymd<=ymd1);


ymd=ymd(i);
y=St(i,1);
x=St(i,2:end);
nt=length(y);
trend=(1:nt)'/ydays;

figure(1);
plot(St);title('Daiwa and Nomura');grid on;legend('Daiwa','Nomura');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) Sy(t)=a+c*t+b*Sx(t)+e(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[b,bint,Spd,rint,stats] = regress(y,[ones(size(y)) trend x]);













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) Augmented Dickey-Fuller test
% y(t)=c+delta*t+phi*y(t-1)+b1*Delta y(t-1)+b2*Delta y(t-2)
% ここでy(t)として、Sy->Sxの残差項を入れる。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lags=0:3;
 [h,pValue,stat,cValue,reg] = adftest(Spd,'model','TS','lags',Lags);


nlag=length(Lags);

for i=1:nlag
 	if h(i)
		fprintf('unit root rejected for Lag=%d\n',Lags(i));
	else
		fprintf('unit root NOT rejected for Lag=%d\n',Lags(i));
 	end;
% h=1ならunit root rejected!
% statが負で絶対値が大きいものがmean-reversionが強い。PAIR TRADEの候補！
%lag=0:2毎に
 fprintf('stat  =%8.4f\n',stat(i));
 fprintf('cValue=%8.4f\n',cValue(i));
 fprintf('pValue=%8.4f\n',pValue(i));

 fprintf('var    coeff      tstat   pval\n');
 for j=1:length(reg(i).names)
   fprintf('%2s %10.4f %10.4f %10.7f\n',reg(i).names{j}, reg(i).coeff(j), reg(i).tStats.t(j), reg(i).tStats.pVal(j)); % Lags=i-1
 end
 fprintf('\n');
end;



disp('Type nay key!');pause();



iplt=1;fignum=2;
[tauh,kappa,sigmaOU,rbar]=CheckHalfLife(Spd,iplt,fignum);



fignum=3;
PlotSpd(ymd,Spd,'Daiwa vs. Nomura', fignum);
