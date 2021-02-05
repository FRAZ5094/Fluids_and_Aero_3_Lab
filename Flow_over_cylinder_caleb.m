% Calculating the pressure coefficient along the circumference of a
% cylinder

clear
clc

crt = readmatrix('data/semester_1(wave_survey)/SurfacePressure_critical_raw.txt');
subcrt = readmatrix('data/semester_1(wave_survey)/SurfacePressure_subcritical_raw.txt');
supcrt = readmatrix('data/semester_1(wave_survey)/SurfacePressure_supercritical_raw.txt');

% Establishing variables and conerting to suitable units, Pascals
%
% Critical Reynolds number
P_surf_crt = ((crt(:,2))./(7.07)).*6894.76;
P_dynm_crt = ((crt(:,3))./(0.0255)).*9.81;

% Subcritical Reynolds number+
P_surf_subcrt = ((subcrt(:,2))./(7.07)).*6894.76;
P_dynm_subcrt = ((subcrt(:,3))./(0.0255)).*9.81;

% Supercritical Reynolds number
P_surf_supcrt = ((supcrt(:,2))./(7.07)).*6894.76;
P_dynm_supcrt = ((supcrt(:,3))./(0.0255)).*9.81;


% Calculating pressure coefficients at different Reynolds number
%
% Critical Reynolds number
Cp_crt = (P_surf_crt)./(P_dynm_crt);

% Subcritical Reynolds number
Cp_subcrt = (P_surf_subcrt)./(P_dynm_subcrt);

% Supercritical Reynolds number
Cp_supcrt = (P_surf_supcrt)./(P_dynm_supcrt);

% Potential flow over a cylinder
theta = (0:(360/47):360)';
Cp_pot = (1-4*(sind(theta)).^2)';

% Plotting Cp around the cylinder
figure(1);
plot(theta,Cp_crt,'-bo','Displayname','Critical');
title('Pressure Coefficient around a cylinder');
xlabel('Position on cylinder (rad)');
ylabel('Pressure Coefficeint, Cp');
hold on
plot(theta,Cp_subcrt,'-go','Displayname','Subcritical');
plot(theta,Cp_supcrt,'-ro','Displayname','Supecritical');
plot(theta,Cp_pot,'-mo','Displayname','Potential Flow');
hold off

% Calculating coefficents of lift and drag around the cylinder
Cl_crt = (0.5).*(Cp_crt).*(cosd(theta+360/47)-cosd(theta));
Cl_subcrt = (0.5).*(Cp_subcrt).*(cosd(theta+360/47)-cosd(theta));
Cl_supcrt = (0.5).*(Cp_supcrt).*(cosd(theta+360/47)-cosd(theta));

Cd_crt = (-0.5).*(Cp_crt).*(sind(theta+360/47)-sind(theta));
Cd_subcrt = (-0.5).*(Cp_subcrt).*(sind(theta+360/47)-sind(theta));
Cd_supcrt = (-0.5).*(Cp_supcrt).*(sind(theta+360/47)-sind(theta));

% Calculating air density 
% 
% Critical
p_crt = (crt(:,6).*(133.32))./(0.0222222)+600;
T_crt = (crt(:,5)./(0.1)) + 273.15;
rho_crt = (p_crt)./(T_crt.*287.05);

%plot(theta,Cl_crt);
