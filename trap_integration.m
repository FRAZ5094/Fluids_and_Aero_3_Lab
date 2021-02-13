function [C_L] = trap_integration(x,y)
delta_x=(x(end)-x(1))/(length(x));

C_L=(delta_x/2)*(y(1)+y(end)+2*sum(y(2:end-1)));
end

