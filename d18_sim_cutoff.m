function [timeout,d18out,Hout]=d18_sim_cutoff(E,H0,d18L,dt,yrs,thin)

load lake_splines
pp.SA=Mungo.SA;

%% add static head to lake Mungo
z=1; %add 1 metre
xhat=pp.SA.breaks;
yhat=ppval(pp.SA,xhat);
dz=xhat(2)-xhat(1);
xhat0=[xhat,(xhat(end)+dz:dz:xhat(end)+z)];
dSA=ppval(fnder(pp.SA),xhat(end));
yhat0=[yhat,yhat(end)+(dz:dz:z)*dSA];
pp.SA=pchip(xhat0,yhat0);
pp.V=fnint(pp.SA);

%define starting height
if H0(1)==9999
    H=pp.SA.breaks(end);
else
    H=H0(1);
end

%define finishing height
H1=H0(2); 
if H1<0.1;
    H1=0.1;
end

%define lake heights
Hi=(H:-dt*E:H1-dt*E)';
Vi=ppval(pp.V,Hi);

%set initial state
d18=d18L;
timeout=NaN(ceil(numel(Hi)./thin),1);
d18out=timeout;
Hout=timeout;
timeout(1)=0;
d18out(1)=d18L;
Hout(1)=Hi(1);

count=0;
record=1;
for i=1:numel(Hi)-1   
    count=count+1;
    VE=Vi(i)-Vi(i+1); %volume of water evaporated       
    d18=(Vi(i)*d18-VE*(d18-6))./(Vi(i)-VE);%change this to (d18-15) for kinetic scenario    
  
    if count==thin
        count=0;
        record=record+1;
        timeout(record)=i*dt;
        d18out(record)=d18;
        Hout(record)=Hi(i);                      
    end
end

idx=find(~isnan(timeout));
timeout=timeout(idx);
timeout=timeout./3600./24./365;
d18out=d18out(idx);
Hout=Hout(idx);
