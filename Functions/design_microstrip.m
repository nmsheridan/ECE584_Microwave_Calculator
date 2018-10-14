function [handles,w,b,diff,err] = design_microstrip(er,z0,w,b,handles)

% N. Micheal Sheridan
% September 2018
% Function uses the approximate stripline formulas to design.  Function will return
% the embedded conductor width,ground plane distance, and percentage error from
% the exact formula


err = '';

if(isnan(er)||isnan(z0)||(isnan(w)&&isnan(b))||(~isnan(w)&&~isnan(b)))
    err = 'Provided parameters incomplete for synthesis!';
    diff = 0;
    w = 0;
    b = 0;
    return
end

if(z0<=0)
    err = 'Characteristic impedence must be greater than zero!'
    diff = 0;
    w = 0;
    b = 0;
    return
end


%% Synthesizing w/b ratio (x) 

A = (z0/60)*sqrt((er+1)/2)+((er-1)/(er+1))*(0.23+(0.11/er));
B = (60*pi*pi)/(z0*sqrt(er));

x = (8*exp(A))/(exp(2*A)-2);
if(x>2)
    x = (2/pi)*(B-1-log(2*B-1)+((er-1)/(2*er))*(log(B-1)+0.39-(0.61/er)));
    if(x<2)
        err = 'There was a problem synthesizing microstrip parameters!'
        return
    end
end

%% Computing return values
if(isnan(w))
    w = b*x;
end

if(isnan(b))
    b = w/x;
end

%% Computing diff
[handles,z0_exact,~,~,~,~,~,~,~,~,err] = calc_microstrip_z0(er,w,b,NaN,handles,1);
diff = ((z0-z0_exact)/z0_exact)*100;
