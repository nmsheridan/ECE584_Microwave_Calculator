function [handles,z0,z0air,ee,ereff,L,C,B,Vp,err] = calc_microstrip_z0(er,w,b,f,handles,bypass)

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

ee = ((er+1)/2)+((er-1)/2)*(1/sqrt(1+(12/x)));

if(x<1)
    z0 = (60/sqrt(ee))*log((8/x)+0.25*x);
    z0air = (60)*log((8/x)+0.25*x);
end

if(x>=1)
   z0 = (120*pi)/(sqrt(ee)*(x+1.393+0.667*log(x+1.444)));
   z0air = (120*pi)/(x+1.393+0.667*log(x+1.444));
end

if(isnan(f))

    ereff = er;
    L = z0air*(4e-07)/(120);
    C = ereff*(8.85e-12)*120*pi/z0air;
    Vp = (3e08)*z0/z0air;
    B = 0;
    
    if(isnan(bypass))
        Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
        ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
        Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
        Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
        Eans = sprintf('Effective Permivity at DC (er): %.4f', ee);
        
        Answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n%s\n', ...
            Zans, ZAirans, Lans, Cans, Eans),'Result','OK','OK');
    end

end

if(~isnan(f))
   
    f = f*1e6;
    
    ft = sqrt(er/ee)*z0/(2*(4*pi*1e-07)*b);
    ereff = er - ((er-ee)/(1+((f/ft)^2)));
    
    L = z0air*(4e-07)/(120);
    C = ereff*(8.85e-12)*120*pi/z0air;
    
    Vp = (3e08)*z0/z0air;
    B = (2*pi*f)/Vp;
    
    if(isnan(bypass))
        Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
        ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
        Eans = sprintf('Effective Permivity at DC (er): %.4f', ee);
        Ereffans = sprintf('Effective Permitivty at %.0f [MHz] (ereff): %.4f', (f/1e6), ereff);
        Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
        Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
        Vans = sprintf('Phase Velocity (up): %i [m/s]', Vp);
        Bans = sprintf('Beta (B): %i', B);
        
        Answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n', ...
            Zans, ZAirans, Eans, Ereffans, Vans, Bans, Lans, Cans),'Result','OK','OK');
        
    end
    
end

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