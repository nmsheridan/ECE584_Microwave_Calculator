
% N. Michael Sheridan
% October 2018
% Draws the Smith Chart as per Problem 3 on Homework 3

r = cat(2,linspace(0,1,11),linspace(1.2,2,5));
r = cat(2,r,linspace(3,10,8));
r = cat(2,r,linspace(20,50,4));
x = cat(2,-flip(r),r(2:length(r)));

figure
hold on

for ii = 1:length(r)
    for jj = 1:length(x)
        centerx1 = r(ii)/(1+r(ii));
        centery1 = 0;
        radius1 = 1/(1+r(ii));
        centerx2 = 1;
        centery2 = 1/x(jj);
        radius2 = abs(1/x(jj));
        
        circle(centerx1,centery1,radius1);
        circle(centerx2,centery2,radius2);     
    end
end


title('Smith Chart');
axis([-1 1 -1 1])
hold off

function h = circle(x,y,r) %Got this function for plotting circles from the MathWorks website
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
h = plot(x+xp,y+yp,'k');
end
