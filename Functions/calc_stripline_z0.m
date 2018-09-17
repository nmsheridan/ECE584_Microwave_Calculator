function [handles,z0,err] = calc_stripline_z0(er,w,b,handles,bypass)

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

if(isnan(bypass))
    
    answer = questdlg(sprintf('Characterstic Impedence: %d Ohms\n(Assuming infinitely thin conductor)'...
        ,z0),'Result','OK','Show me the Approximation!','OK');
    
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