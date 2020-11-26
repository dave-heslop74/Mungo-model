function [time,d18out,C]=d18_sim(E,H,d18p,d18L,dt,yrs,thin)

[FIN,FE,FOUT,V]=height2F(H,E);
d18=[d18p;d18L];
iter=yrs*365*24*3600./dt;
iter=ceil(iter);


ktot=find(V>0,1,'last');
time=(0:dt*thin:dt*iter)';
time=time./365./24./3600;
d18out=NaN(ktot,numel(time));
d18out(:,1)=d18(2:ktot+1);

count=0;
record=1;
for i=1:iter
    count=count+1;
    for k=ktot:-1:1
        d18(k+1)=(V(k)*d18(k+1)+FIN(k)*d18(k)*dt-FE(k)*(d18(k+1)-5)*dt-FOUT(k)*d18(k+1)*dt)./V(k);%change to *(d18(k+1)-6) for scenario B, and *(d18(k+1)-14) for scenario C
    end
    
    if count==thin
        count=0;
        record=record+1;
        d18out(:,record)=d18(2:ktot+1);
    end
end

%convergence check
for k=1:ktot
    C(k)=FIN(k)*d18(k)-FE(k)*(d18(k+1)-5)-FOUT(k)*d18(k+1);%change to *(d18(k+1)-6) for scenario B, and *(d18(k+1)-14) for scenario C
end
