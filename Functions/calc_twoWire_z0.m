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
z0air = 120*log(x + sqrt((x^2)-1));

L = z0air*(4e-07)/(120);
C = er*(8.85e-12)*120*pi/z0air;

Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
Eans = sprintf('Effective Permivity at DC (er): %.4f', ee);

Answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n%s\n', ...
    Zans, ZAirans, Lans, Cans, Eans),'Result','OK','OK');

%% Save parameters to memory for future calculations
input = questdlg('Save Transmission Line parameters to memory?','Save',...
    'Save Slot 1','Save Slot 2','No','No');
if(strcmp(input,'Save Slot 1'))
    
    handles.z0{1} = z0;
    handles.L{1} = L;
    handles.C{1} = C;
    
    questdlg('Transmission Line Parameters saved to Slot 1!','Save','OK','OK');
    
end

if(strcmp(input,'Save Slot 2'))
    
    handles.z0{2} = z0;
    handles.L{2} = L;
    handles.C{2} = C;
    
    questdlg('Transmission Line Parameters saved to Slot 2!','Save','OK','OK');
    
end