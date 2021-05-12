%1.2 Wave survey
%drag_momentum_theory_analysis_v7.pdf
%Aerodynamics_and fluids_3_lab_data_analysis_cylinder_Delta_wing.pdf

clear
clc

%find all the files associated with the wave survey
file_list=dir("data/semester_1(wave_survey)/WakeSurvey*.txt");

for i=1:1:length(file_list)
    
    
    %create absolute file path from file name and directory
    file_path=append("data/semester_1(wave_survey)/"+file_list(i).name);
    disp(file_list(i).name);
    data=tdfread(file_path);

    %change variable names and remove first element in array
    position=data.Position_mm(2:end,:);
    wake_dynamic_pressure=data.Wake_Dynamic(2:end,:); %q_wake
    dynamic_pressure=data.WT_Dynamic(2:end,:); %q_infinity
    wake_static_pressure=data.Wake_Static_relative_to_atmosphere(2:end,:); %p_wake-p_ambient
    static_pressure=data.WT_Static_relative_to_atmosphere(2:end,:); %p_infinity-p_ambient
    
    %convert from str to float
    position=str2num(position)';
    wake_dynamic_pressure=str2num(wake_dynamic_pressure)';
    dynamic_pressure=str2num(dynamic_pressure)';
    wake_static_pressure=str2num(wake_static_pressure)';
    static_pressure=str2num(static_pressure)';
    
    %convert V to Pa
    wake_dynamic_pressure=wake_dynamic_pressure./0.01969;
    wake_dynamic_pressure=wake_dynamic_pressure.*9.80665;
    
    dynamic_pressure=dynamic_pressure./0.0255;
    dynamic_pressure=dynamic_pressure.*9.80665;
    
    wake_static_pressure=wake_static_pressure./0.0198;
    wake_static_pressure=wake_static_pressure.*9.80665;
    
    static_pressure=static_pressure./0.0198;
    static_pressure=static_pressure.*9.80665;
    
    %relative to atmosphere to absolute
    wake_static_pressure=wake_static_pressure+101325;
    static_pressure=static_pressure+101325;
    
    wake_velocity=sqrt((wake_dynamic_pressure)./(dynamic_pressure));
    
    adjusted_wake_velocity=sqrt((wake_dynamic_pressure+wake_static_pressure-static_pressure)./(dynamic_pressure));
    
    wake_momentum_deficit_parameter=wake_velocity.*(1-wake_velocity);
    
    %Reynolds number 
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
    
    f_name=strrep(file_list(i).name,"_"," ");
    Re_format=sprintf("(Re=%0.2E)",Re);
    
  
    figure(i)
    plot(position,wake_velocity);
    hold on
    plot(position,adjusted_wake_velocity)
    hold off
    xlim([-400,400]);
    %ylim([0.3,1.05]);
    xlabel("wake position (mm)");
    ylabel("wake velocity u/U");
    legend({"measured u","adusted wake velocity u'"},"Location","southeast");
    
    title(f_name+" "+Re_format);
    
    
    ordinate=(position.*10^-3)./d;
    
    
    figure(1)
    plot(position,wake_momentum_deficit_parameter,"DisplayName",file_list(i).name)
    %ylim([-0.02,0.25])
    %title(f_name+" "+Re_format);
    xlabel("wake position (mm)");
    ylabel("wake momentum parameter");
    
    hold on
    
    def_greater=wake_momentum_deficit_parameter(wake_momentum_deficit_parameter>0);
    ordinate=ordinate(wake_momentum_deficit_parameter>0);
    
    C_D=2*trapz(ordinate,def_greater);
    
    
end