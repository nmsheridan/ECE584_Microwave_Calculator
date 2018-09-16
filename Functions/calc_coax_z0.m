function [handles, z0, err] = calc_coax_z0(er,d,D,handles)

% N Michael Sheridan
% September 2018
% Calculates the characteristic impedence of a coaxial transmission line

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

z0 = (120/(2*sqrt(er)))*log(x);

questdlg(sprintf('Characterstic Impedence: %d Ohms',z0),'Result','OK','OK');