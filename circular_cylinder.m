clear
clc

%find all the files associated with the surface pressure
file_list=dir("data/semester_1/Surface*.txt");

 %generate tapping theta values (48 tappings over 360 degrees
 theta_values=linspace(0,360,48);

 %calculate C_p using potential flow 
 potential_flow_C_p=1-4*(sin(deg2rad(theta_values))).^2;


%loop over found files
for i=1:1:length(file_list)
    
    %create absolute file path from file name and directory
    file_path=append("data/semester_1/"+file_list(i).name);
    
    
    %read in data from file 
    data=tdfread(file_path);

    %change variable names and remove first element in array
    surface_pressure=data.Scanivalve_1(2:end,:);
    dynamic_pressure=data.WT_Dynamic(2:end,:);

    %convert to floats
    surface_pressure=str2num(surface_pressure);
    dynamic_pressure=str2num(dynamic_pressure);


   
    %convert surface_pressure to psi then pa
    surface_pressure=surface_pressure./7.07;
    surface_pressure=surface_pressure.*6894.76;

    %converting dynamic pressure to mmH20 then pa
    dynamic_pressure=dynamic_pressure./0.0255;
    dynamic_pressure=dynamic_pressure.*9.80655;

    %calculate values for C_p
    C_p_values=(surface_pressure)./(dynamic_pressure);
    
    potential_flow_C_p=1-4*(sin(deg2rad(theta_values))).^2;
    
    figure(i)
    plot(theta_values,C_p_values);
    hold on
    plot(theta_values,potential_flow_C_p)
    hold off
    xlim([0,360]);
    xlabel("tapping position (degrees)");
    ylabel("pressure coefficient C_p");
    legend({'Experiment','Potential flow'})
    title(strrep(file_list(i).name,"_"," "));
    
end
    





