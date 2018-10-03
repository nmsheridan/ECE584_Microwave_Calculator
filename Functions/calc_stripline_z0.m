function [handles,z0,z0air,L,C,err] = calc_stripline_z0(er,w,b,handles,bypass)

% N Michael Sheridan
% September 2018
% Evaluates the characteristic impedence for stripline with a infinitely thin
% conductor

err = '';
if(isnan(er)||isnan(w)||isnan(b))
    err = 'Input argument(s) invalid for calculation!';
    z0 = NaN;
    return
end


k = 1/(cosh((pi*w)/(2*b)));
k_prime = sqrt(1-(k^2));

z0 = ((30*pi)/sqrt(er))*(ellipke(k)/ellipke(k_prime));
z0air = (30*pi)*(ellipke(k)/ellipke(k_prime));

L = z0air*(4e-07)/(120);
C = er*(8.85e-12)*120*pi/z0air;

if(isnan(bypass))
    
    Zans = sprintf('Characteristic Impedance (z0): %.4f [Ohms]',z0);
    ZAirans = sprintf('Characteristic Impedance in Air (z0 Air): %.4f [Ohms]',z0air);
    Lans = sprintf('Inductance per Unit Length (L`): %i [H/m]', L);
    Cans = sprintf('Capactiance per Unit Length (C`): %i [F/m]', C);
    
    answer = questdlg(sprintf('Results:\n\n%s\n%s\n%s\n%s\n', ...
        Zans, ZAirans, Lans, Cans),'Result','OK','OK');
    
%     answer = questdlg(sprintf('Characterstic Impedence: %d Ohms\n(Assuming infinitely thin conductor)'...
%         ,z0),'Result','OK','Show me the Approximation!','OK');
    
    if(strcmp(answer,'Show me the Approximation!'))
        if((w/b)<=0.56)
            z0_apx = (60/sqrt(er))*log(2*coth((pi*w)/(4*b)));
            error = ((z0_apx - z0)/z0)*100;
            questdlg(sprintf('The approximate impedence is: %i Ohms\n(%i Percent Error)',z0_apx,error),...
                'Approximation','OK','OK');
        end
        if((w/b)>0.56)
            z0_apx = (120*(pi^2))/(8*sqrt(er)*log(2*exp((pi*w)/(2*b))));
            error = ((z0_apx - z0)/z0)*100;
            questdlg(sprintf('The approximate impedence is: %i Ohms\n(%i Percent Error)',z0_apx,error),...
                'Approximation','OK','OK');
        end
        
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