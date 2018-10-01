function[tauh,kappa,sigma,rbar,et]=CheckHalfLife(z,iplt,iprt,fignum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REGRESSION
% z(t)=a+b*z(t-1)+et
%dz=a+(b-1)*z(t-1)+et
%<=>kappa(theta-z(t-1))dt+sigma*dBt
% kappa*dt=1-b
% std(et)=sigma*dt^0.5
%[o] tauh; half-life
% OU parameter (kappa,sigma,rbar)
% residuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ydays;
res=regstats(z(2:end),z(1:(end-1)));
b=res.tstat.beta;r=res.r;stats=res.adjrsquare;
et=res.r;
if iprt
	fprintf('b(1)=%8.5f (tstat:%9.5f;pval:%8.5f)\n',res.tstat.beta(1),res.tstat.t(1),res.tstat.pval(1));
	fprintf('b(2)=%8.5f (tstat:%9.5f;pval:%8.5f)\n',res.tstat.beta(2),res.tstat.t(2),res.tstat.pval(2));
end;

dt=1/ydays;%%1/250;
kappa=(1-b(2))/dt;
rbar=b(1)/(kappa*dt);
sigma= std(r)/dt^0.5;% [per annum]
tauh=half_life(kappa,ydays);
if iprt
fprintf('kappa = %8.5f\n', kappa);
fprintf('rbar  = %8.5f\n', rbar);
fprintf('sigma = %8.5f[per annum]\n', sigma);
fprintf('R^2   = %8.5f\n', stats(1));
fprintf('half-life[days] = %8.2f\n', tauh);
end;
if iplt
 figure(fignum);
 subplot(2,1,1); normplot(r);title('Normplot of the Residual');grid on;
 subplot(2,1,2); histfit(r,100);title('Residual');grid on;
end;
