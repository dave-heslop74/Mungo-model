%% Example 1
%(1)Set evaporation to Canberra mean value
%(2)Flood lakes with precipitation until Mungo is almost overflowing (water height of 7.6554 m)
%(3)Iterate for 20 years to bring isotopes effectively into equilibrium
%(4)Reduce the water flux to bring the water height of Mungo to 0.5 m
%(5)Iterate for 20 years to bring isotopes effectively into equilibrium

%% clear memory and close all figures
clear all, close all

%% define Canberra mean annual evaporation 
E=1825; %[mm/yr]
E=E./1000./365./24./3600; % [m/s] 

%% setup iteration scheme
dt=100; %time step in seconds
yrs=20; %number of years to calculate
thin=200; %only record every 200th time step

%% set oxygen isotope values [per mil]
d18p=-8; %value of precipitation
d18L=ones(5,1)*d18p; %set 5 lakes to have precipitation value 

%% fill lakes with precipitation and iterate towards equilibrium
H0=[9999 9999 9999 7.6554 0]; %set fixed lake heights (9999=full)
[time0,d18out0]=d18_sim(E,H0,d18p,d18L,dt,yrs,thin); %iterate

%% instantly reduce incoming flux to Mungo
H0=[9999 9999 9999 0.5 0]; %set fixed lake heights (9999=full)
d18L(H0>0)=d18out0(:,end); %final d18O values of previous run give starting values
[time1,d18out1,C1]=d18_sim(E,H0,d18p,d18L,dt,yrs,thin); %iterate

%% plot results of both runs together
time=[time0;time1+time0(end)]; %combine time arrays
d18O=[d18out0,d18out1]; %combine isotope arrays
figure %create new figure
plot(time,d18O)
ylim=get(gca,'ylim'); %find the limits on the y-axis
hold on
plot(ones(1,2)*time0(end),ylim,'--k') %add dashed line to seperate models
set(gca,'tickdir','out','xminortick','on','yminortick','on')
xlabel('Time [yrs]') %label the x-axis
ylabel('Lake \delta^{18}O [^o/_{oo}]') %label the y-axis
legend('Mulurulu','Garnpung','Leaghur','Mungo');

%% calculate efolding time
% for j=1:4
%     test=d18out1(j,:);
%     test=test-test(end);
%     test=test./test(1);
%     e=[0.5:0.1:3];
%     for i=1:numel(e)
%         ef(i)=invinterp1(time1,test,1/exp(e(i)))./e(i);
%     end
%     ef_bar(j)=mean(ef);
% end