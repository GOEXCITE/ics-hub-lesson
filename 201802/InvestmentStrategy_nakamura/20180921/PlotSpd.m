function[]=PlotSpd(ymd,Spd,strn,fignum,figsizex,figsizey,k)
if nargin<5
	figsizex=1;figsizey=1;k=1;
end;

it0=1;nbk=8;
ntm=datenum(num2str(ymd(it0:end)),'yyyymmdd');
dtm=floor(length(ymd(it0:end))/nbk);

tik=ntm;


 	
	mn=mean(Spd);	sigma=std(Spd);iplt=0;
  [tauh,kappa,sigmaOU,rbar]=CheckHalfLife(Spd,iplt,fignum);

	subplot(figsizex,figsizey,k);
	plot(1:length(Spd),Spd);


	plot(ntm,Spd);
	xlim([ntm(1),ntm(end)]); % XŽ²”ÍˆÍ‚ÌŽw’è 
	set(gca,'Xtick',ntm(1:dtm:end)) % XŽ²‚Ì–Ú·‚èˆÊ’u‚ðŽw’è 
	datetick('x','mmmyy','keeplimits','keepticks')




	grid on;
	title(strcat([strn,'; \tau = ', num2str(tauh,'%6.2f'),'(days); \sigma=',num2str(sigma,'%6.2f')]));
	xlabel('date');ylabel('Spread');
	hold on;
	plot(tik,mn*ones(size(tik)),'m-');
	plot(tik,(mn+sigma)*ones(size(tik)),'g:',tik,(mn-sigma)*ones(size(tik)),'g:');
	plot(tik,(mn+2*sigma)*ones(size(tik)),'r--',tik,(mn-2*sigma)*ones(size(tik)),'r--');hold off;
 