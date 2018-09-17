function [handles,z0,ee,err] = calc_microstrip_z0(er,w,b,handles,bypass)

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

ee = ((er+1)/2)+((er-1)/2)*(1/sqrt(1+(12/x)));

if(x<=0)
    err = 'Ratio invalid!';
    z0 = NaN;
    return
end

if(x<1)
    z0 = (60/sqrt(ee))*log((8/x)+0.25*x);
end

if(x>=1)
   z0 =  (120*pi)/(sqrt(ee)*(x+1.393+0.667*log(x+1.444)));
end

if(isnan(bypass))
    answer = questdlg(sprintf('Characterstic Impedence: %d Ohms\n(Using Schneider Approximation)'...
        ,z0),'Result','OK','OK');
end
