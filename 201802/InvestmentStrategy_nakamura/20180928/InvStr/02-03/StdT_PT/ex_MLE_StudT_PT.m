% ex_MLE_StudT.m
% 9.28.2018
% (C) N.Nakamura
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
warning off;

global ydays;
ydays=252;
ymdstart=20160104;ymdend  =20180927;



PTnames={	'野村不ＨＤ','住友不'};
PTnames={	'東海東京','大和'};
PTnames={	'イエロハット','オートバクス'};
PTnames={	'野村','岡三'};




%%%%%%%%%%%%%%%%%%%%
% (1) Data load
%%%%%%%%%%%%%%%%%%%%
datadir='.\';
datafile=strcat([datadir,'stock11-18.xlsx']);
ilog=0;% log(St) else St
[Spd,x,y,PTcodes,res,ymd,St]=Dataload11_18(datafile,PTnames,ymdstart,ymdend,ilog);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END of data loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) MLE of Spd(t)=gm*Spd(t-1)+e(t), e(t)~T(nu,0,sig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nu,mu,sig; initial guess
% 初期値の設定
gm0=regress(Spd(2:end),Spd(1:end-1));
nu0=4;
sig0=std(Spd);

fname='logStudT';
paramstr={'gm','nu','sig'};
param( 1) =    gm0; % gamma
param( 2) =    nu0; % dof
param( 3) =    sig0; % sig

[llk]=feval(fname,param,Spd);%%logStudT(param,Spd);

%%%% ------- optimization ------------
ndim=length(param);
x0 = param;% initial guess of psi, eta
options = [ ]; % Use default options
options=optimset('Display','iter','GradObj','off','GradConstr','off','MaxFunEvals',600,'LargeScale', 'off');%%,'Hessian','on');


options=optimset(options,'Display','off','TolFun',1e-8,'TolCon',1e-6,'TolX',1e-6, 'Diagnostics','off'); %%off|iter | {final} ]  
%%% simple bound set 

%%% simple bound set 
vlb(1)=0.001;   vub(1)=1;   % gm
vlb(2)=2.0001;     vub(2)=50;  % dof
vlb(3)=1e-4;    vub(3)=100;   % sig

A=[];%%zeros(2,ndim);
B=[];%%[0;0];
starttime=cputime;
[xout, fout,exitflag,output,lambda,grad,hessia]= fmincon('logStudT',x0, A,B,[],[],vlb, vub,[],options, Spd);
comptime=cputime-starttime;
output.TimeInSeconds=comptime;
fprintf('comptime=%15.4f\n',comptime);

param=xout;
LLFcpl=-fout;
output.LogL=-fout;
[output.AIC,output.BIC] = aicbic(LLFcpl,length(param),size(Spd,1));



fprintf('\n>>>>>>> OPTIMAL parameters (nt = %d) <<<<<<<\n',nt);
for i=1:ndim,
 fprintf('param(%2d) = %15.10f; %s \n', i,xout(i),sprintf('%% %3s',paramstr{i}));
end;
param=xout;
gm=param(1);
nu=param(2);
sig=param(3);
vnames={'gm','nu','sig'};























%%%%%%%%%%%%
% residuals
%%%%%%%%%%%%
et=Spd(2:end)-gm*Spd(1:end-1);
figure(10);
nbins=100;
subplot(2,1,1);histfit(et,nbins);grid on;title('Residual Dstribution');
title(sprintf('Residual Distribution(Normal fit) of %s(%d) and %s(%d)',PTnames{1},PTcodes(1),PTnames{2},PTcodes(2)));

subplot(2,1,2);
histfitST(et,nbins,nu, 0, sig);grid on;
title(sprintf('Residual Distribution(Stud-t fit) of %s(%d) and %s(%d)',PTnames{1},PTcodes(1),PTnames{2},PTcodes(2)));


ydays=250;
% Normal
kappa0=(1-gm0)*ydays;
tau0=half_life(kappa0,ydays);

% Stud-t
kappa=(1-gm)*ydays;
tau=half_life(kappa,ydays);

fprintf('kappa=%10.5f (kappa0:%10.5f), tau =%8.2f (tau0:%8.2f)[days]\n',kappa,kappa0,tau,tau0);

