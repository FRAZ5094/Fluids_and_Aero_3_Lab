%1.1 Surface Pressure

clear
clc

%find all the files associated with the surface pressure
file_list=dir("data/semester_1(wave_survey)/Surface*.txt");


 %generate tapping theta values (48 tappings over 360 degrees
 theta_values=linspace(0,360,48);

 %calculate C_p using potential flow 
 potential_flow_C_p=1-4*(sin(deg2rad(theta_values))).^2;

%calculate and plot all C_p data... 

%loop over found files
for i=1:1:length(file_list)
    
    %create absolute file path from file name and directory
    file_path=append("data/semester_1(wave_survey)/"+file_list(i).name);
    
    %disp(file_list(i).name);
    %read in data from file 
    data=tdfread(file_path);

    %change variable names and remove first element in array
    surface_pressure=data.Scanivalve_1(2:end,:);
    dynamic_pressure=data.WT_Dynamic(2:end,:);

    %convert to floats
    surface_pressure=str2num(surface_pressure)';
    dynamic_pressure=str2num(dynamic_pressure)';


   
    %convert surface_pressure to psi then pa
    surface_pressure=surface_pressure./7.07;
    surface_pressure=surface_pressure.*6894.76;

    %converting dynamic pressure to mmH20 then pa
    dynamic_pressure=dynamic_pressure./0.0255;
    dynamic_pressure=dynamic_pressure.*9.80655;

    %calculate values for C_p
    C_p_values=(surface_pressure)./(dynamic_pressure);
    
    potential_flow_C_p=1-4*(sind(theta_values)).^2;
    
    pressure=data.Barometric_Pressure(2:end,:);
    T=data.Temperature(2:end,:);
    
    pressure=str2num(pressure)';
    T=str2num(T)';
    
    pressure=(pressure./0.0222222)+600;
    pressure=pressure.*133.322;
    
    T=T/0.1;
    T_average=mean(T);
    T=T+273;
    
    
    R=287;
    
    density=(pressure)./(R.*T);
    
    density_average=mean(density);
    
    U=mean(sqrt((2*dynamic_pressure)./(density_average)));
    
    d=0.16;
    
    if (i==1 || i==2)
        mu=1.802*10^-5;
    else
        mu=1.849*10^-5;
    
    end
    Re=(density_average*U*d/mu);
    
    %{
    figure(i)
    plot(theta_values,C_p_values);
    hold on
    plot(theta_values,potential_flow_C_p)
    hold off
    xlim([0,360]);
    ylim([-3,1.5]);
    xlabel("tapping position (degrees)");
    ylabel("pressure coefficient C_p");
    legend({'Experiment','Potential flow'},"Location","northeast")
    f_name=strrep(file_list(i).name,"_"," ");
    Re_format=sprintf("(Re=%0.2E)",Re);
    title(f_name+" "+Re_format);
    %}
    %Calculate lift and drag coefficients from C_p and potiential flow...
    
    clear C_D_p_values C_D_p potential_flow_C_D_p_values potential_flow_C_D_p C_L_values C_L potential_flow_C_L_values potential_flow_C_L
    
    %Coefficient of pressure drag experiment
    C_D_p_values=C_p_values.*cosd(theta_values);
    C_D_p=0.5*trapz(deg2rad(theta_values),C_D_p_values);
    
    %Coefficient of Pressure drag experiment
    potential_flow_C_D_p_values=potential_flow_C_p.*cosd(theta_values);
    potential_flow_C_D_p=0.5*trapz(deg2rad(theta_values),potential_flow_C_D_p_values);
    
    %Coefficient of Lift potential
    C_L_values=C_p_values.*sind(theta_values);
    C_L=-0.5*trapz(deg2rad(theta_values),C_L_values);
    %delta_x=(2*pi)/(48);
    %C_L=(-0.5)*(delta_x)*(C_L_values(1)+C_L_values(end)+2*sum(C_L_values(2:end-1)));
    
    %Coefficient of Dynamic pressure potential
    potential_flow_C_L_values=potential_flow_C_p.*sind(theta_values);
    potential_flow_C_L=-0.5*trapz(deg2rad(theta_values),potential_flow_C_L_values);
    
    fprintf("%s \n Experiment:\n C_D_p=%f\n C_L=%f\n Potential: C_D_p=%f\n C_L=%f\n",file_list(i).name,C_D_p,C_L,potential_flow_C_D_p,potential_flow_C_L);
    
end
    














