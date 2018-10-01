function[pdf]= STpdf(y,nu, mu, sig)
if nargin <3
	sig=1;
end;
       
zt=(y-mu)/sig;
term = gammaln((nu + 1) / 2) - gammaln(nu/2);
pdf=exp(term)./(nu*sig^2*pi).^0.5./(1 + (zt.^2) ./ nu).^((nu + 1)/2);
             
