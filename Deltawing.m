%2.2 Delta wing

clc 
clear

data=readtable("data/semester_2(Delta_wing)/DeltaWing2020.csv");

%data when wind tunnel off 
data_off=data(1:23,:);

%data when wind tunnel at 20m/s
data_on=data(24:end,:);

Fz=data_on.Fz_L_-data_off.Fz_L_;


%calculate lift using F_z and angle of attack
lift_on=(data_on.Fz_L_.*cosd(data_on.Incidence))- (data_on.Fx_D_.*sind(data_on.Incidence));
lift_off=(data_off.Fz_L_.*cosd(data_off.Incidence))-(data_off.Fx_D_.*sind(data_on.Incidence));
%lift_on=(data_on.Fz_L_.*cosd(data_on.Incidence));
%lift_off=(data_off.Fz_L_.*cosd(data_off.Incidence));

%calcualte drag using F_x and angle of attack
drag_on=data_on.Fx_D_.*cosd(data_on.Incidence)+(data_on.Fz_L_.*sind(data_on.Incidence));
drag_off=data_off.Fx_D_.*cosd(data_off.Incidence)+(data_off.Fz_L_.*sind(data_on.Incidence));
%drag_on=data_on.Fx_D_.*cosd(data_on.Incidence);
%drag_off=data_off.Fx_D_.*cosd(data_off.Incidence);

%difference between data when WT on and off
lift=lift_on-lift_off;
drag=drag_on-drag_off;

%without adjusting lift and drag
%lift=lift_on;
%drag=drag_on;

%Calculate Reynolds number


AoA=data_on.Incidence;


%delta wing area calculations

c=0.8;
b=2*c*tand(30);
S=0.5*b*c;

%Mean aerodynamic chord calculation

MAC=((b)/(S))*(((b^2)/(4))-((sqrt(3)*c*b)/(2))+(c^2));

%calculate density

R=287;


T=data_on.Air_Temp__C_+273;
T_average=mean(T);

P=data_on.Baro_P_Pa_;

density=(P)./(R.*T);
density_average=mean(density);

air_velocity=data_on.WindSpeed_m_s_;
air_velocity_average=mean(air_velocity);

mu=1.802*10^-5;

Re=(density_average*air_velocity_average*c/mu);

%calculate C_L and C_D

C_L=(lift)./(0.5.*density.*(air_velocity.^2).*S);

C_D=(drag)./(0.5.*density.*(air_velocity.^2).*S);

%{
figure(1);
plot(AoA,C_L);
xlim([0,34]);
%ylim([-0.2,1.2]);

title("Lift coeffient vs angle of attack");
xlabel("Angle of attack (degrees)");
ylabel("Lift coefficent C_l");
%}

%{
figure(2);
plot(AoA,C_D);
xlim([0,34]);
%ylim([-0.2,1.2]);

title("Drag coefficient against angle of attack");
xlabel("Angle of attack (degrees)");
ylabel("Drag coefficent C_d");
%}

%Aspect ratio

A=(b^2)/(S);



%linear portion of graph is AoA 0-24 degrees (0-13 in index)

%k=(C_D(13)-C_D(1))/(C_L(13).^2-C_L(1).^2);

k_poly=polyfit(C_L(1:13).^2,C_D(1:13),1);
k=k_poly(1);
C_D_0=k_poly(2);
e=(1)./(pi*A*k);

%{
figure(3)
plot(C_L.^2,C_D,"DisplayName","Experimental curve");
hold on
plot(C_L.^2,polyval(k_poly,C_L.^2),"DisplayName","polyfit curve");
hold off
title("Coefficient of drag against Coefficient of lift squared");
xlabel("C_L^2");
ylabel("C_D");
%}



m_pitch_on=data_on.My_P_;
m_pitch_off=data_off.My_P_;

m_pitch=m_pitch_on-m_pitch_off;

xcp=0.93-((m_pitch)./(lift));

q=0.5.*density.*air_velocity.^2;

d_lift_alpha_poly=polyfit(AoA(1:13),lift(1:13),1);
d_lift_alpha=d_lift_alpha_poly(1);

d_moment_alpha_poly=polyfit(AoA(1:13),m_pitch(1:13),1);
d_moment_alpha=d_moment_alpha_poly(1);

x_ac=(d_lift_alpha*0.93-d_moment_alpha)/(d_lift_alpha);

m_values=[];

for x=linspace(0,0.93,1000)
    
    M_ac=m_pitch+lift.*(x-0.93);
    poly=polyfit(AoA(1:13),M_ac(1:13),1);
    m=poly(1);
    m_values=[m_values,m];

end
x=linspace(0,0.93,1000);
%plot(x,m_values)

m_closest_0=min(abs(m_values));

plot(x,abs(m_values))

M_ac=mean(m_pitch+lift.*(x_ac-0.93));

%M_ac=d_moment_alpha+lift.*(0.93-0.93);
%plot(AoA,M_ac)

%{
figure(4);
plot(AoA,xcp);
title("Centre of pressure position vs angle of attack")
xlabel("Angle of attack (degrees)");
ylabel("Distance from apex to centre of pressure position (m)");

C_m=(m_pitch)./(q.*S.*c);
%}