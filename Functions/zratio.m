function K = zratio(x)

x_prime = sqrt(1-x^2);

if((x>=0)&&(x<=(1/sqrt(2))))
    K = pi/log(2*((1+sqrt(x_prime))/(1-sqrt(x))));
end
if((x>=(1/sqrt(2)))&&(x<=1))
    K = log(2*((1+sqrt(x))/(1-sqrt(x))))/pi;
end