x = -3:.1:3; 
y = -5:.1:5; 
[X,Y] = meshgrid(x,y);
F = X.^2 + Y.^2;
I = trapz(y,trapz(x,F,2));