function [handles,err] = analyze_reflection(handles,L,C,z0)

% N. Michael Sheridan
% October 2018
% This function will calculate the reflection paramters given a transmission
% line and the complex impedance of the load

err = '';

if(isempty(L)||isempty(C)||isempty(z0))
    err = 'Error with inputted values\n(Are you sure they are not blank?';
    return
end

prompts = {'Load impedance real component','Load impedance imaginary component',...
    sprintf('\nOR\n\nLoad impedance magnitude'),'Load impedance phase-angle',...
    'Frequency in MHz','Length of Transmission Line in mm'};

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
return_loss = 20*log10(abs(r));
VSWR = (1+abs(r))/(1-abs(r));

zans = sprintf('For transmission line with characteristic impedance %s and load impedance %s:\n',...
    num2str(z0,4),num2str(zl,4));
rans = sprintf('Voltage Reflection Coefficient: %s',num2str(r,4));
returnans = sprintf('Return Loss: %s [dB]',num2str(return_loss,4));
vswrans = sprintf('Voltage Standing Wave Ratio: %.4f [V/V]',VSWR);
zinans = '';

if((~(isempty(userInput{5})||isempty(userInput{6})))||isnan(L)||isnan(C))
    f = str2double(userInput{5})*1e6; %frequency enetered in MHz
    l = str2double(userInput{6})/1e3; %length entered in mm
    b = 2*pi*f*sqrt(L*C);
    
    Zin = z0*(zl + j*z0*tan(b*l))/(z0 + j*zl*tan(b*l));
    
    zinans = sprintf('Input Impedance at %.2f [mm] from Load: %s [Ohms]',...
        (l*1e3), num2str(Zin));
end

newInput = questdlg(sprintf('%s\n%s\n%s\n%s\n%s\n',zans,rans,returnans,vswrans,zinans),'Results',...
    'Plot Input Impedance','OK','OK');

if(strcmp(newInput,'Plot Input Impedance'))
    
    if(isnan(L)||isnan(C))
        warndlg('Inductnce and capacitance needed for plot');
        return
    end
    
    prompts = ['Enter length of tranmission line in mm','Enter starting frequency in MHz',...
        'Enter stopping frequency in MHz'];
    
    linput = inputdlg(prompts,'Length',[1 35]);
    
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
    
    Zin = zeros(length(w),2); %Real and imaginary components
    
    for ii=w(1):w(length(w))
        b = ii*sqrt(L*C);
        Zin(ii,1) = real(z0*(zl + j*z0*tan(b*l))/(z0 + j*zl*tan(b*l)));
        Zin(ii,2) = imag(z0*(zl + j*z0*tan(b*l))/(z0 + j*zl*tan(b*l)));    
    end
    
    plot(w,Zin(:,1),w,Zin(:,2));
end
