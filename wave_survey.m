%1.2 Wave survey

clear
clc

%find all the files associated with the wave survey
file_list=dir("data/semester_1/WakeSurvey*.txt");

for i=1:1:length(file_list)
    
    
    %create absolute file path from file name and directory
    file_path=append("data/semester_1/"+file_list(i).name);

    data=tdfread(file_path);

    %change variable names and remove first element in array
    wake_dynamic_pressure=data.Wake_Dynamic(2:end,:);
    dynamic_pressure=data.WT_Dynamic(2:end,:);

    %convert from str to float
    wake_dynamic_pressure=str2num(wake_dynamic_pressure)';
    dynamic_pressure=str2num(dynamic_pressure)';
    
    %convert V to Pa
    wake_dynamic_pressure=wake_dynamic_pressure./0.01969;
    wake_dynamic_pressure=wake_dynamic_pressure.*9.80665;
    
    dynamic_pressure=dynamic_pressure./0.0255;
    dynamic_pressure=dynamic_pressure.*9.80665;
end