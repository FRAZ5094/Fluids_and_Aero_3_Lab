from scipy import trapz
import numpy as np

y_values=np.array([1,3,9,16,25])

x_values=np.array([1,2,3,4,5])

area=0

for i in range(1,len(x_values)):
  
  n=((y_values[i-1]-y_values[i]/2))*(x_values[i]-x_values[i-1])
  area+=n


print(area)