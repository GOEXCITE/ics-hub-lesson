function[]=PlotSpd(ymd,x,y,xname,yname,fignum)
if nargin<6
	fignum=1;
end;

 	
  beta=regress(y,[ones(size(y)) x]);res.beta=beta;
  Spd=y-(res.beta(1)+res.beta(2)*x);mn=0;

	iplt=1;iprt=1;
  [tauh,kappa,sigma,rbar]=CheckHalfLife(Spd,iplt,iprt,fignum+1);

	figure(fignum);
	subplot(2,1,1);
	plot(1:length(x),x);

	nbk=8;
	ntm=datenum(num2str(ymd),'yyyymmdd');
	dtm=floor(length(ymd)/nbk);

	plot(ntm,x,ntm,y);grid on;
  title(sprintf('%s vs. %s in [%d,%d]',xname,yname,ymd(1),ymd(end)));  
  xlabel('date');ylabel('price');
	legend(xname,yname,'Location','Best');


	xlim([ntm(1),ntm(end)]); % X軸範囲の指定 
	set(gca,'Xtick',ntm(1:dtm:end)) % X軸の目盛り位置を指定 
	datetick('x','mmmyy','keeplimits','keepticks')


	

	subplot(2,1,2);
	plot(1:length(Spd),Spd);

	plot(ntm,Spd);
	xlim([ntm(1),ntm(end)]); % X軸範囲の指定 
	set(gca,'Xtick',ntm(1:dtm:end)) % X軸の目盛り位置を指定 
	datetick('x','mmmyy','keeplimits','keepticks')

	grid on;title(strcat(['Spd:=(',yname,')-(',num2str(res.beta(1)),'+',num2str(res.beta(2)),'*(',xname,')); half-life = ', num2str(tauh),'(days)']));
	xlabel('date');ylabel('Y-(\alpha+\beta*X)');
	hold on;
	sigma=std(Spd);
	plot(ntm,(mn+sigma)*ones(size(ntm)),'g:',ntm,(mn-sigma)*ones(size(ntm)),'g:');
	plot(ntm,(mn+2*sigma)*ones(size(ntm)),'r--',ntm,(mn-2*sigma)*ones(size(ntm)),'r--');hold off;
 