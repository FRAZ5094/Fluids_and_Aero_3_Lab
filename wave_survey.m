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
    
    wake_momentum_deficit_parameter=wake_velocity.*(1-wake_velocity);
    
    figure(i)
    plot(position,wake_velocity);
    %hold on
    %plot(position,wake_momentum_deficit_parameter)
    %hold off
    xlim([-400,400]);
    xlabel("wake position (mm)");
    ylabel("wave velocity u/U");
    legend({"measured u","adusted wake velocity u'"});
    title(strrep(file_list(i).name,"_"," "));
    
    
end