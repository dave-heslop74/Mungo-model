%% Flood, balance and evaporation Model
%(1)Set evaporation to location value
%(2)Flood lakes with precipitation until Mungo is almost overflowing (water height of 7.6554 m)
%(3)Iterate for 20 years to bring isotopes effectively into equilibrium
%(4a)Reduce the water flux to cut-off Mungo
%(4b)Set evaporation to location value
%(4c)Set target water height for Mungo
%(5)Iterate isotopes until Mungo evaporates to target water height 

%% clear memory and close all figures
clear all, close all

%% define location evaporation - first 20 years
Ew=2000; %[mm/yr] change to 800 for Winter, 3600 for Summer, 2000 for annual average
Ew=Ew./1000./365./24./3600; %[m/s]%% define location evaporation 

%% define location evaporation - after cut off
Es=2000; %[mm/yr] change to 800 for Winter, 3600 for Summer, 2000 for annual average
Es=Es./1000./365./24./3600; %[m/s]

%% setup iteration scheme
dt=100; %time step in seconds
yrs=20; %number of years to calculate
thin=200; %only record every 200th time step

%% set oxygen isotope values [per mil]
d18p=-8; %value of precipitation
d18L=ones(5,1)*d18p; %set 5 lakes to have precipitation value 

%% fill lakes with precipitation and iterate towards equilibrium
H0=[9999 9999 9999 7.6554 0]; %set fixed lake heights (9999=full)
[time0,d18out0]=d18_sim(Ew,H0,d18p,d18L,dt,yrs,thin); %iterate

%% cutoff Mungo and evaporate at set evaporative rate
H0=[7.6554 0.1]; %starting water height and final water height
d18L=d18out0(4,end); %final Mungo d18O value of previous run gives starting value
[time1,d18out1]=d18_sim_cutoff(Es,H0,d18L,dt,yrs,thin); %iterate

%% plot results
figure %create new figure
plot(time0,d18out0); %plot initial set of results
hold on
cmap=get(gca,'colororder'); cmap=cmap(4,:); %find the Mungo line color
plot(time1+time0(end),d18out1,'-','color',cmap) %add Mungo evaporation record
%ylim=get(gca,'ylim'); %find limits on y-axis
plot(ones(1,2)*time0(end),ylim,'--k') %add dashed line to seperate models
set(gca,'tickdir','out','xminortick','on','yminortick','on')
xlabel('Time [yrs]') %label the x-axis
ylabel('Lake \delta^{18}O [^o/_{oo}]') %label the y-axis
legend('Mulurulu','Garnpung','Leaghur','Mungo'); 
grid minor %add minor gridlines
ylim([-10 60])

