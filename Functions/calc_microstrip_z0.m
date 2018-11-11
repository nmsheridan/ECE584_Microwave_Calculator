function [handles,z0,z0air,ee,ereff,L,C,B,Vp,Vg,err] = calc_microstrip_z0(er,w,b,f,handles,bypass)

% N Michael Sheridan
% September 2018
% Evaluates the characteristic impedence for microstrip transmission line
% with a infinitely thin conductor using Schneider approximation
% 
% The inputs to this function are as follows:
% er -> dielectric permitivity (at DC)
% w -> conductor width
% b -> distance between the conductor and groundplane
% f -> operating frequency (if you want to use the dispersive model)
% bypass -> set to a number (not NaN) if you don't want your results to
% show in a popup window
% 
% L and C and PER UNIT LENGTH
% ereff is the frequency-dependent permitivity
% err is error message (NOT permitivity)
% Anyone who has been paying attention in class should know what the rest
% of the outputs are

err = '';
if(isnan(er)||isnan(w)||isnan(b))
    err = 'Input argument(s) invalid for calculation!';
    z0 = NaN;
    z0air = NaN;
    ee = NaN;
    L = NaN;
    C = NaN;
    Vp = NaN;
    ereff = NaN;
    Vg = NaN;
    B = NaN;
    return
end

x = w/b;

w = w/1000; %Dimensions entered in mm
b = b/1000;

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

    ereff = ee;
    L = z0air*(4e-07)/(120);
    C = ereff*(8.854e-12)*120*pi/z0air;
    Vp = (3e08)*z0/z0air;
    B = 0;
    Vg = Vp;
    
    fT1 = (3e8)*sqrt(2/(ee-1))*atan(ee)/(2*pi*b); %SW2 mode
    fT2 = (3e8)/(4*b*sqrt(ee-1)); %TM2 mode
    fT3 = (3e8)/(sqrt(ee)*(2*w+b)); %TM1 mode
    fT4 = (3e8)/(2*b*sqrt(ee)); %SW1 mode
    
    if(isnan(bypass))
        Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
        ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
        Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
        Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
        Eans = sprintf('Effective Permivity at DC (er): %.4f', ee);
        F3ans = sprintf('TM1 Mode Frequency: %.4f [GHz]',(fT3/(1e9)));
        F2ans = sprintf('TM2 Mode Frequency: %.4f [GHz]',(fT2/(1e9)));
        F4ans = sprintf('SW1 Mode Frequency: %.4f [GHz]',(fT4/(1e9)));
        F1ans = sprintf('SW2 Mode Frequency: %.4f [GHz]',(fT1/(1e9)));
        
        Answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n', ...
            Zans, ZAirans, Lans, Cans, Eans, F3ans, F2ans, F4ans, F1ans),...
            'Result','OK','OK');
        
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

end

if(~isnan(f))
   
    f = f*1e6;
    
    ft = sqrt(er/ee)*z0/(2*(4*pi*1e-07)*b);
    ereff = er - ((er-ee)/(1+((f/ft)^2)));
    
    L = z0air*(4e-07)/(120);
    C = ereff*(8.85e-12)*120*pi/z0air;
    
    Vp = (3e08)*z0/z0air;
    B = (2*pi*f)*sqrt(ereff)/(3e8);
    
    ddw = ((2*pi*f)*(er-ee))/((2*pi*ft)^2*(1+(f/ft)^2)^2*sqrt(ereff));
    Vg = 1/((3e-08)*(sqrt(ereff)+2*pi*f*ddw));
    
    weff = (120*pi*b)/(z0*sqrt(ee));
    wf = w + ((weff - w)/(1+((f/ft)^2)));
    
    z0 = (120*pi*b)/(wf*sqrt(ereff));
    
    
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
        
        %% Save parameters to memory for future calculations
        input = questdlg('Save Transmission Line parameters to memory?','Save',...
            'Save Slot 1','Save Slot 2','No','No');
        if(strcmp(input,'Save Slot 1'))
            
            handles.z0{1} = z0;
            handles.L{1} = L;
            handles.C{1} = C;
            handles.alpha{1} = j*B;
            
            questdlg('Transmission Line Parameters saved to Slot 1!','Save','OK','OK');
            
        end
        
        if(strcmp(input,'Save Slot 2'))
            
            handles.z0{2} = z0;
            handles.L{2} = L;
            handles.C{2} = C;
            handles.alpha{2} = j*B;
            
            questdlg('Transmission Line Parameters saved to Slot 2!','Save','OK','OK');
            
        end
    end
    
end