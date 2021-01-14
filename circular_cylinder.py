import numpy as np
import pandas as pd
import glob
import matplotlib.pyplot as plt 

filenames=glob.glob("data/semester_1/Surface*")

filename=filenames[0]

surface_pressure_critcal_raw=pd.read_csv(filename,sep="\t",dtype=float,skiprows=1)


surface_pressure_critcal_raw.columns=["tapping_number","surface_pressure","dynamic_pressure","WT_Static_relative_to_atmosphere","temperature","barometric_pressure"]

surface_pressure_critcal_raw["theta"]=np.linspace(0,360+(360/48),48)

#conversion to psi
surface_pressure_critcal_raw["surface_pressure"]/=7.07
#conversion to pa
surface_pressure_critcal_raw["surface_pressure"]*=6894.76


#conversion to mmH20
surface_pressure_critcal_raw["dynamic_pressure"]/=0.0255

#conversion to pa
surface_pressure_critcal_raw["dynamic_pressure"]*=9.80655


#calculate pa
surface_pressure_critcal_raw["C_p"]=None

for i in range(0,len(surface_pressure_critcal_raw)):

    surface_pressure_critcal_raw["C_p"][i]=(surface_pressure_critcal_raw["surface_pressure"][i])/(surface_pressure_critcal_raw["dynamic_pressure"][i])
    
#plot pa against theta
plt.plot(surface_pressure_critcal_raw["theta"],surface_pressure_critcal_raw["C_p"])
plt.xlim(0,360)

plt.show()