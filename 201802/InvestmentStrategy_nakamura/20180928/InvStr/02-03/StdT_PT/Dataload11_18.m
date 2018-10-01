function[Spd,x,y,PTcodes,res,ymd,St]=Dataload11_18(datafile,PTnames,ymdstart,ymdend,ilog)


	[w,txt]=xlsread(datafile);


  ymds=txt(3:end,6);
	ymd=str2num(datestr(datenum(ymds,'yyyy/mm/dd'),'yyyymmdd'));
	nt=length(ymd);
	[code,Sname]=strtok(txt(2,7:end));
	Sname=strtrim(Sname);
	code=str2num(char(code));
	St=w(2:end,7:end);

	it=find(ymd>=ymdstart & ymd<=ymdend);
	St=St(it,:);ymd=ymd(it);


	[nt,nS]=size(St);




ic(1)=find(strcmp(PTnames{1},Sname));
ic(2)=find(strcmp(PTnames{2},Sname));
PTcodes=[code(ic(1)) code(ic(2))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END of data loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%



xname=PTnames{1};yname=PTnames{2};

if ilog
	x=log(St(:,ic(1)));y= log(St(:,ic(2)));
else
	x=St(:,ic(1));y= St(:,ic(2));
end;


  PlotSpd(ymd,x,y,xname,yname,5);

  res = regstats(y,x);

	fprintf('>>>>> x:%s vs y:%s <<<<<<\n',xname,yname);
	Spd=y-(res.beta(1)+res.beta(2)*x);% Ø•Ğ€‚à“ü‚ê‚ÄAE(Spread)=0‚ÉŠî€‰»‚·‚éB

	alp=res.beta(1);bt=res.beta(2);
	fprintf('alpha = %10.3f\n',alp);
	fprintf('bt    = %10.3f\n',bt);

