function [handles,z0,z0air,ee,L,C,Vp,err] = calc_GCPW_z0(er,w,s,h,bypass,handles)


%% Some Wrappers to make everything work
err = '';
if(isnan(er)||isnan(w)||isnan(s)||isnan(h))
    err = 'Input argument(s) invalid for calculation!';
    z0 = NaN;
    z0air = NaN;
    ee = NaN;
    L = NaN;
    C = NaN;
    Vp = NaN;
    return
end

w = w/1000; %Dimensions are entered in mm
s = s/1000;
h = h/1000;


%% Transmission Line calculations begin here

ksi = w/(w+2*s);

kg = tanh((pi*w)/(4*h))/tanh((pi*w+pi*2*s)/(4*h));

qe = (1/zratio(kg))/((1/zratio(kg))+(1/zratio(ksi)));

ee = 1 + qe*(er-1);

z0 = (60*pi)/(sqrt(ee)*((1/zratio(ksi))+(1/zratio(kg))));
    
z0air = 30*pi*zratio(ksi);

L = z0air*(4e-07)/(120);
C = ee*(8.85e-12)*120*pi/z0air;
Vp = (3e08)*z0/z0air;

if(isnan(bypass))
    
    Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
    ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
    Eans = sprintf('Effective Permivity at DC (er): %.4f', ee);
    Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
    Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
    Vans = sprintf('Phase Velocity (up): %i [m/s]', Vp);
    
    Answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n%s\n%s\n', ...
        Zans, ZAirans, Eans, Vans, Lans, Cans),'Result','OK','OK');
    
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
end