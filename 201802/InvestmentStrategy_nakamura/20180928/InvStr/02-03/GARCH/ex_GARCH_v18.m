% ex_GARCH_v18.m
% 9.28-10.5.2018
% N.Nakamura
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
warning off;

global ydays;
ydays=252;

ymd0=20150105;ymd1=20170927;%%20161013;

%datadir='..\..\..\Data\';
datadir='';
	w=csvread(strcat([datadir,'NKVI14-18.csv']),1,0);% NK index + VI
	SNK=w(:,2);
	VI=w(:,3);% vol(% p.a.)
	ymdNK=w(:,1);
  figure(1);plot(VI);grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Price ===> Return�@[% p.a.]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rtNK=[diff(log(SNK))*100];
rtVI=[diff(log(VI))*100];% [% p.d.] 
ymdNK=ymdNK(2:end);

ic=find(ymdNK>=ymd0 & ymdNK <=ymd1);
figure(2);
scatter(rtVI(ic),rtNK(ic));
grid on;title(strcat(['VI-return vs S-return in [',num2str(ymd0),',',num2str(ymd1),']']));
xlabel('VI-return');ylabel('S-return');

















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (I) S-return�̕���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%
% (1) ARMA
%%%%%%%%%
ToEstMdl = arima(9,0,0);% model�̐ݒ�
EstMdl = estimate(ToEstMdl,rtNK);% model�̐���
et = infer(EstMdl,rtNK);% model�̌덷�� et�̌v�Z(residuals of ARIMA model); Infer conditional variances of conditional variance models















%%%%%%%%%
% (2) GARCH(rtNK); y(t)=\sqrt{h(t)} * res(t)
%%%%%%%%%
yt=et;
%ToEstMdl = garch('Offset',NaN,'GARCH',NaN,'ARCH',NaN,'Distribution','t');%manual�ɂ��ƁAy(t)=mu+\epsilon(t)��mu��offset�ƌĂ�ł�B
ToEstMdl = garch('GARCH',NaN,'ARCH',NaN,'Distribution','t');%%garch(1,1,'Distribution','t');
%ToEstMdl = gjr('Offset',NaN,'GARCHLags',[1 2 3 4],'ARCHLags',[1 2 3 4], 'LeverageLags',[1 2 3 4],'Distribution','t');%%garch(1,1,'Distribution','t');
EstMdl = estimate(ToEstMdl,yt);
ht = infer(EstMdl,yt);% Infer conditional variances of conditional variance models









res = yt./sqrt(ht);%<--- the standardized residuals. std(res)=1�Ɋ������Ă���I
                   % �Ƃ��낪�AStudent-t�ɏ]��X��std(X)=(nu/(nu-2))^0.5(=:s)�ł��邽�߁A
                   % y=sqrt(ht)*res=sqrt(ht/s)*(s*res)�Ƃ��Ȃ��Ƃ����Ȃ��B���̂Ƃ��@s*res \sim T(0,1,nu)


nu(1)=EstMdl.Distribution.DoF;
s=(nu(1)/(nu(1)-2))^0.5;

%%% ��l���m���ϐ��ɕϊ� %%%%%%

ut(:,1)=tcdf(s*res,nu(1));
figure(4);
hist(ut);grid on;title('Histogram of U(residuals)');

disp('type any key!');pause;
















%%%%%%%%%%%% �\���@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample��end�̒l�������l�Ƃ��āA�����t�����U��\��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPeriods=12;
Vf = forecast(EstMdl,numPeriods,'Y0',yt);
figure(5);plot(Vf);grid on;
disp('type any key!');pause;














%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[V,Y] = simulate(EstMdl,100,'NumPaths',500);%100���ԁA500���simulation
figure(6);
subplot(2,1,1);plot(V);title('Conditional Variance: horizon=100 days');grid on;
subplot(2,1,2);plot(Y);title('Residual Retruns: horizon=100 days');grid on;


