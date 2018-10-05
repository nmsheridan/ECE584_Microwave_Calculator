function [handles,w,b,diff,err] = design_stripline(er,z0,w,b,handles)

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
    err = 'Characteristic impedence must be greater than zero!';
    diff = 0;
    w = 0;
    b = 0;
    return
end


%% Synthesizing in large impedence case
if(z0>120)
   
    ratio = 8/(pi*exp(2*pi*z0*sqrt(er)/(120*pi)));
        
end

%% Small impedence case
if(z0<=120)
    
   ratio = ((120*pi)/(4*z0*sqrt(er))) - 0.4413; 
    
end

%% Computing return values
if(isnan(w))
    w = b*ratio;
end

if(isnan(b))
    b = w/ratio;
end

%% Computing diff
[~,z0_exact,~,~,~,err] = calc_stripline_z0(er,w,b,handles,1);
diff = ((z0-z0_exact)/z0_exact)*100;

