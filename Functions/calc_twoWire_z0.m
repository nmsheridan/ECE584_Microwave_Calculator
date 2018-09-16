function [handles,z0,err] = calc_twoWire_z0(er,d,D,handles)

% Written by N. Michael Sheridan
% September 2018
% 
% Calculates the characteristic impedence of a two-wire transmission line

err = '';
if(isnan(er)||isnan(D)||isnan(d))
    err = 'Input argument(s) invalid for calculation!';
    z0 = NaN;
    return
end

x = D/d;

if(x<=1)
    err = 'Diameter ratio invalid!';
    z0 = NaN;
    return
end

z0 = (120/sqrt(er))*log(x + sqrt((x^2)-1));

questdlg(sprintf('Characterstic Impedence: %d Ohms',z0),'Result','OK','OK');