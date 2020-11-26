function [FIN,FE,FOUT,V]=height2F(H0,E)

load lake_splines

pp{1}.SA=Mulurulu.SA;
pp{2}.SA=Garnpung.SA;
pp{3}.SA=Leaghur.SA;
pp{4}.SA=Mungo.SA;
pp{5}.SA=Arumpo.SA;

%% add static head to lakes
z=1; %add 1 metre
for i=1:numel(pp)
xhat=pp{i}.SA.breaks;
yhat=ppval(pp{i}.SA,xhat);
dz=xhat(2)-xhat(1);
xhat0=[xhat,(xhat(end)+dz:dz:xhat(end)+z)];
dSA=ppval(fnder(pp{1}.SA),xhat(end));
yhat0=[yhat,yhat(end)+(dz:dz:z)*dSA];
pp{i}.SA=pchip(xhat0,yhat0);
pp{i}.V=fnint(pp{i}.SA);
end

%% find surface areas
idx=find(H0==9999); %which lakes are full
totSA=zeros(numel(H0),1);
V=zeros(numel(H0),1);
for i=1:numel(idx)
totSA(idx(i))=ppval(pp{i}.SA,pp{i}.SA.breaks(end));
V(idx(i))=ppval(pp{i}.V,pp{i}.V.breaks(end));
end

idx=idx(end)+1; %which lakes are full
totSA(idx)=ppval(pp{idx}.SA,H0(idx));
V(idx)=ppval(pp{idx}.V,H0(idx));
FE = totSA.*E; %evaporation flux
FIN=flipud(cumsum(flipud(FE))); %lake input fluxes
FOUT=FIN-FE; %lake output fluxes
