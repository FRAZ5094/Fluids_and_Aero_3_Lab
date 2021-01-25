%2.2 Delta wing

clc 
clear

data=readtable("data/semester_2(Delta_wing)/DeltaWing2020.csv");

data_off=data(1:23,:);

data_on=data(24:end,:);

%data=sortrows(data,"Incidence");


%calculate lift using F_z and angle of attack
lift=data_on.Fz_L_.*cos(deg2rad(data_on.Incidence));

%calcualte drag using F_x and angle of attack
drag=data_on.Fx_D_.*cos(deg2rad(data_on.Incidence));


figure(1);
plot(data_on.Incidence,lift);
legend("lift (N)");
figure(2);
plot(data_on.Incidence,drag);
legend("drag (N)");