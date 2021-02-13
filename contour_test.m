x=linspace(0,100,1000);
y=x.*5;

plot(x,y)

p = polyfit(x, y, 1);
slope = p(1);
intercept = p(2);