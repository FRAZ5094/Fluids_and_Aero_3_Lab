clc 
clear

fname="data/semester_2(Delta_wing)/alpha15fine_0.dat";
[Xpos, Ypos, u,v,w, alpha_fit, beta_fit, pL, poL,q, Co,CaT, CbT]= process_7hole_testdata_3rdyrlab_v2(fname);
%q is dynamic pressure
%poL is stagnation pressure
%pL is pressure

pL=reshape(pL, 26,[]);
poL=reshape(poL,26,[]);
x=reshape(Xpos, 26 ,[]);
y=reshape(Ypos, 26,[]);
u=reshape(u, 26,[]);
v=reshape(v, 26,[]);
w=reshape(w, 26,[]);
mag=sqrt(u.^2+v.^2);

%{
figure(1);
contourf(-y,x,mag);
title({"velocity component in the streamwise direction","contours are in ms^-1"})
xlabel("probe horizontal position (mm)");
ylabel("probe vertical position (mm)");
%ylim([50,350]);
colorbar;
%}

z=zeros(26,14);



%{
figure(2);
quiver(-y,x,w,v);
xlabel("probe horizontal position (mm)");
ylabel("probe vertical position (mm)");
title("Velocity vectors in the (w,v) plane")
xlim([-500,0]);
ylim([50,310]);v
%}



%figure(3);

[vorticityu,cav] = curl(x,y,w,v);
y_vec=y(:,1);
x_vec=x(1,:);


circulation=-trapz(x_vec,(trapz(y_vec,vorticityu)));

%circulation_from_velocity=-(trapz(reshape(x,[],1),reshape(v,[],1))-trapz(reshape(y,[],1),reshape(w,[],1)));

%{
contourf(-y,x,voricityu);
ylim([50,310]);
xlim([-500,0]);
title({"Vorticity component in the u direction","contours are in rads^-1"})
xlabel("probe horizontal position (mm)");
ylabel("probe vertical position (mm)");
colorbar;
%}

%{
figure(4);
contourf(-y,x,poL);
title({"Stagnation pressure","contours are in Pa"});
xlabel("prope horizontal position (mm)");
ylabel("probe vertical position (mm)");
colorbar;
%}
%{
figure(5);
contourf(-y,x,pL);
title({"Pressure in the wake flow","contours are in Pa"});
xlabel("prope horizontal position (mm)");
ylabel("probe vertical position (mm)");
colorbar;
%}





