
% N. Michael Sheridan
% October 2018
% Draws the Smith Chart as per Problem 3 on Homework 3

figure
hold on


r = cat(2,linspace(0,1,11),linspace(1,2,6));
r = cat(2,r,linspace(2,10,10));
r = cat(2,r,linspace(10,50,5));
x = r;

centerx1 = r/(1+r);
centery1 = 0*x;
radius1 = r/(1+r);
centerx2 = 1 + 0*r;
centery2 = 1./x;
radius2 = 1./x;

circle(centerx1,centery1,radius1);
circle(centerx2,centery2,radius2);

r = linspace(1,2,6);
x = linspace(1,2,6);

centerx1 = r/(1+r);
centery1 = 0*x;
radius1 = r/(1+r);
centerx2 = 1 + 0*r;
centery2 = 1./x;
radius2 = 1./x;

circle(centerx1,centery1,radius1);
circle(centerx2,centery2,radius2);

r = linspace(2,10,10);
x = linspace(2,10,10);

centerx1 = r/(1+r);
centery1 = 0*x;
radius1 = r/(1+r);
centerx2 = 1 + 0*r;
centery2 = 1./x;
radius2 = 1./x;

circle(centerx1,centery1,radius1);
circle(centerx2,centery2,radius2);

r = linspace(10,50,5);
x = linspace(10,50,5);

centerx1 = r/(1+r);
centery1 = 0*x;
radius1 = r/(1+r);
centerx2 = 1 + 0*r;
centery2 = 1./x;
radius2 = 1./x;

circle(centerx1,centery1,radius1);
circle(centerx2,centery2,radius2);

function h = circle(x,y,r) %Got this function for plotting circles from the MathWorks website
th = 0:pi/50:2*pi;
xunit = r*cos(th) + x;
yunit = r*sin(th) + y;
h = plot(xunit, yunit);
end
