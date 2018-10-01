function[llk,llkt]=logStudT(param,xt)
%negative log likelihood

gm=param( 1); % gamma
nu=param( 2); % dof
sig=param( 3);% sig


nt=length(xt);
mu=gm*xt(1:nt-1);
zt=zeros(size(xt));
zt=(xt(2:nt)-mu)/sig;
term = gammaln((nu + 1) / 2) - gammaln(nu/2); % normalization const.




	llkt=term-0.5*log(nu*sig^2*pi)-zt.^2;% <------ ³‚µ‚¢–Þ“xŠÖ”‚É’¼‚·‚±‚ÆI





llk=sum(llkt);


llkt=-llkt; % negative loglikelihood at time t
llk=-llk;  % negative total loglikelihood
















if ~isreal(llk) 
%  disp('Imag')
   llk=1e+8;
end

if isnan(llk) 
%   disp('isnan')
   llk=1e+8;
end

if isinf(llk)
%   disp('Inf')
   llk=1e+8;
end

