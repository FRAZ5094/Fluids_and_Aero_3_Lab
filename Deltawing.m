%2.2 Delta wing

clc 
clear

data=readtable("data/semester_2(Delta_wing)/DeltaWing2020.csv");

%data when wind tunnel off 
data_off=data(1:23,:);

%data when wind tunnel at 20m/s
data_on=data(24:end,:);

%calculate lift using F_z and angle of attack
lift_on=data_on.Fz_L_.*cos(deg2rad(data_on.Incidence));
lift_off=data_off.Fz_L_.*cos(deg2rad(data_off.Incidence));

%calcualte drag using F_x and angle of attack
drag_on=data_on.Fx_D_.*cos(deg2rad(data_on.Incidence));
drag_off=data_off.Fx_D_.*cos(deg2rad(data_off.Incidence));


lift=lift_on-lift_off;
drag=drag_on-drag_off;

AoA=data_on.Incidence;

%delta wing area calculations

c=0.8;
b=2*c*tand(30);
s=0.5*b*c;

%Mean aerodynamic chord calculation

MAC=((b)/(s))*(((b^2)/(4))-((sqrt(3)*c*b)/(2))+(c^2));

%calculate density

R=287;

T=data_on.Air_Temp__C_+273;

P=data_on.Baro_P_Pa_;

density=(P)./(R.*T);

air_velocity=data_on.WindSpeed_m_s_;

%calculate C_L and C_D

C_L=(lift)./(0.5.*density.*(air_velocity.^2).*s);

C_D=(drag)./(0.5.*density.*(air_velocity.^2).*s);

figure(1);
plot(AoA,C_L);
legend("lift (N)","Location","southeast");
xlim([0,34]);
title("Lift force against angle of attack Delta wing");
figure(2);
plot(AoA,C_D);
legend("drag (N)","Location","southeast");
xlim([0,34]);
title("Drag force against angle of attack Delta wing");
ylim([0,0.1]);

