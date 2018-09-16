function [handles,z0,err] = calc_microstrip_z0(er,w,b,handles)

% N Michael Sheridan
% September 2018
% Evaluates the characteristic impedence for microstrip transmission line
% with a infinitely thin conductor using Schneider approximation

err = '';
if(isnan(er)||isnan(w)||isnan(b))
    err = 'Input argument(s) invalid for calculation!';
    z0 = NaN;
    return
end


x = w/b;

if(x<=0)
    err = 'Ratio invalid!';
    z0 = NaN;
    return
end

if(x<1)
    z0 = (60/sqrt(er))*log((8/x)+0.25*x);
end

if(x>=1)
   z0 =  (120*pi)/(sqrt(er)*(x+1.393+0.667*log(x+1.444)));
end

answer = questdlg(sprintf('Characterstic Impedence: %d Ohms\n(Using Schneider Approximation)'...
    ,z0),'Result','OK','OK');
