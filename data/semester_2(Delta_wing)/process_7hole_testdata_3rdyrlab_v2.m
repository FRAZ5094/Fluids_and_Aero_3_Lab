
function [Xpos, Ypos, u,v,w, alpha_fit, beta_fit, pL, poL,q, Co,CaT, CbT]= process_7hole_testdata_3rdyrlab_v2(fname)

%process 7 hole probe test data

%fname is the absolute file name of the data including its path. This is a matlab -mat file

%returned data include velocity components (u,v,w), pressure pL, stagnation
%pressure poL, dynamic pressure q, traverse position Xpos and Ypos, flow angles alpha and beta. Note
%that the senses of the traverse coordinate systems and probe velocities
%are indicated in the laboratory notes.

%calibration data....
%stagnation pressure....

K_Co = [-0.0310
   -0.0271
    0.0694
   -0.0986
   -0.1184
    0.0059
    0.0023
   -0.0068
   -0.0083
    0.0002];

%dynamic pressure....

K_Cq =[ 0.6172
   -0.0106
    0.0275
   -0.0104
   -0.0116
   -0.0001
    0.0004
   -0.0011
   -0.0014
    0.0000];

%probe angle alpha

K_alpha = [1.4747
   -0.3123
   12.5495
   -0.1037
    0.6268
   -0.0709
   -0.0055
   -0.0344
   -0.0944
   -0.0182];

%probe angle beta

K_beta = [-0.6498
   11.9919
    0.6286
   -0.1477
   -0.1252
    0.8895
   -0.1019
   -0.0192
   -0.1050
   -0.0187];

%load in experimental data

fname="alpha15fine_0.dat";

load(fname,'-mat');

%extract 7 hole probe data...

chan7=(probe_module(1)-1)*8+7;
chan1=(probe_module(1)-1)*8+1;
chan6=(probe_module(1)-1)*8+6;

p7data(:,1)=data_avg(:,chan7);
p16data(:,1:6)=data_avg(:,chan1:chan6);

pbar=mean(p16data,2);

%calculate probe orifice pressure coefficients....
C_alpha_a=(p16data(:,1)-p16data(:,4))./(p7data-pbar);
C_alpha_b=(p16data(:,2)-p16data(:,5))./(p7data-pbar);
C_alpha_c=(p16data(:,3)-p16data(:,6))./(p7data-pbar);
CaT=(2*C_alpha_a+C_alpha_b-C_alpha_c)/3;
CbT=(C_alpha_b+C_alpha_c)/sqrt(3);

%calculate stagnation pressure, dynamic pressure, probe angles from probe
%pressure coefficients and calibration data....

Co=K_Co(1)+K_Co(2)*CaT+K_Co(3)*CbT+K_Co(4)*CaT.^2+K_Co(5)*CbT.^2+K_Co(6)*CaT.*CbT+K_Co(7)*CaT.^3+K_Co(8)*CbT.^3+K_Co(9)*(CaT.^2).*CbT+K_Co(10)*CaT.*(CbT.^2);
Cq=K_Cq(1)+K_Cq(2)*CaT+K_Cq(3)*CbT+K_Cq(4)*CaT.^2+K_Cq(5)*CbT.^2+K_Cq(6)*CaT.*CbT+K_Cq(7)*CaT.^3+K_Cq(8)*CbT.^3+K_Cq(9)*(CaT.^2).*CbT+K_Cq(10)*CaT.*(CbT.^2);
alpha_fit=K_alpha(1)+K_alpha(2)*CaT+K_alpha(3)*CbT+K_alpha(4)*CaT.^2+K_alpha(5)*CbT.^2+K_alpha(6)*CaT.*CbT+K_alpha(7)*CaT.^3+K_alpha(8)*CbT.^3+K_alpha(9)*(CaT.^2).*CbT+K_alpha(10)*CaT.*(CbT.^2);
beta_fit=K_beta(1)+K_beta(2)*CaT+K_beta(3)*CbT+K_beta(4)*CaT.^2+K_beta(5)*CbT.^2+K_beta(6)*CaT.*CbT+K_beta(7)*CaT.^3+K_beta(8)*CbT.^3+K_beta(9)*(CaT.^2).*CbT+K_beta(10)*CaT.*(CbT.^2);

poL=p7data-Co.*(p7data-pbar);
pL=poL-(p7data-pbar)./Cq;
q=(p7data-pbar)./Cq;

U=sqrt(2*q./rho); %this is the velocity magnitude....

%resolve velocity into (u,v,w) components from compputed probe alpha, beta angles....

alphar=pi*alpha_fit/180; betar=pi*beta_fit/180;

v=U.*sin(betar);
u=U.*cos(betar).*cos(alphar);
w=U.*cos(betar).*sin(alphar);


