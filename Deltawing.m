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

figure(1);
plot(data_on.Incidence,lift);
legend("lift (N)","Location","southeast");
xlim([0,34]);
figure(2);
plot(data_on.Incidence,drag);
ylim([0,max(drag)*1.2]);
xlim([0,34]);
legend("drag (N)","Location","southeast");