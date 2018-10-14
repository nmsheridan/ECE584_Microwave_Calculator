function [handles,err] = analyze_reflection(handles,L,C,z0)

% N. Michael Sheridan
% October 2018
% This function will calculate the reflection paramters given a transmission
% line and the complex impedance of the load


if(isempty(L)||isempty(C)||isempty(z0))
    err = 'Error with inputted values\n(Are you sure they are not blank?';
    return
end

prompts = ['Load impedance real component','Load impedance imaginary component',...
    'n\OR\n\nLoad impedance magnitude','Load impedance phase-angle'];

userInput = inputdlg(prompts,'Load Parameters',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

if((isempty(userInput{1})&&isempty(userInput{2})))% Using the polar form for z0
    
    if(isempty(userInput{3})) % I want nothing to be interperated as zero
       userInput{3} = 0; 
    end
    if(isempty(userInput{4}))
       userInput{4} = 0; 
    end
    
    zl = str2num(userInput{3})*exp(1i*str2num(userInput{4}));
else
   
    if(isempty(userInput{1})) % I want nothing to be interperated as zero
        userInput{1} = 0;
    end
    if(isempty(userInput{2}))
        userInput{2} = 0;
    end
    
    zl = str2num(userInput{1}) + 1i*str2num(userInput{2});    
end

r = (zl-z0)/(zl+z0);
return_loss = 20*log10(r);
VSWR = (1+abs(r))/(1-abs(r));

zans = sprintf('For transmission line with characteristic %.4f and load impedance %.4f:\n',z0,zl);
rans = sprintf('Voltage Reflection Coefficient: %.4f',r);
returnans = sprtinf('Return Loss: %.4f [dB]',return_loss);
vswrans = sprintf('Voltage Standing Wave Ratio: %.4f [V/V]',VSWR);

newInput = questdlg(sprintf('%s\n%s\n%s\n%s\n',zans,rans,returnans,vswrans),'Results',...
    'Plot Input Impedance','OK','OK');

if(strcmp(newInput,'Plot Input Impedance'))
    
    prompts = ['Enter length of tranmission line in mm','Enter starting frequency in MHz',...
        'Enter stopping frequency in MHz'];
    
    linput = questdlg(prompts,'Length',[1 35]);
    
    if(isempy(linput))
       warndlg('Cancelled!')
       return
    end
    
    l = str2double(linput{1})/1e3; %length in meters
    
    if((str2double(linput{2}))<(str2double(linput{3})))
        w = linspace(2*pi*(str2double(linput{2}))*1e6,2*pi*(str2double(linput{3}))*1e6,handles.plotPoints);
    else
        warndlg('Unable to compute using entered frequencies');
        return;
    end
    
    for ii=w(1):w(length(w))
        b = w*sqrt(L*C);
        
        
    end
end
