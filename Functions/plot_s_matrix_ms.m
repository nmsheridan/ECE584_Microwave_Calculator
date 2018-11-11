function [p,err] = plot_s_matrix_ms(f_start,f_stop,handles)

% N Michael Sheridan
% Novermber 2018
% Plots the scattering matrix of microstrip line over set range of frequencies
%
% Inputs:
% f_start & f_stop are frequency enetered in [MHz]

p = '';
err = '';

if(isempty(f_start)||isempty(f_stop)||(f_start==f_stop))
    err = 'Not enough parameters entered!';
    return
end

if(f_start>f_stop)
    temp = f_stop;
    f_stop = f_start;
    f_start = temp;    
end

prompts = {'Enter dielectric constant:','Enter conductor width:',...
    'Enter dielectric thickness:','Enter microstrip length',...
    sprintf('\n\nEnter port impedance')};

userInput = inputdlg(prompts,'Plot',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

er = str2double(userInput{1});
w = str2double(userInput{2});
h = str2double(userInput{3});
len = str2double(userInput{4});
zp = str2double(userInput{5});

freqs = linspace(f_start*(1e6),f_stop*(1e6),handles.plotPoints);
dataArray = zeros(length(freqs),4);

for ii = 1:length(freqs)
    
    [~,z0,~,~,~,~,~,b,~,~,err] = calc_microstrip_z0(er,w,h,freqs(ii),handles,1);
    
    [dataArray(ii,1),dataArray(ii,2),dataArray(ii,3),dataArray(ii,4)] = ...
        smatrix(zp,z0,b,len,handles);
    
    if(~isempty(err))
       warndlg(err);
       return
    end
    
end

figure
subplot(2,1,1)
hold on
plot(freqs/(1e6),10*log10(abs(dataArray(:,1))));
plot(freqs/(1e6),10*log10(abs(dataArray(:,2))));
plot(freqs/(1e6),10*log10(abs(dataArray(:,3))));
plot(freqs/(1e6),10*log10(abs(dataArray(:,4))));
title('S-Parameter Magnitude');
xlabel('Frequency [MHz]');
ylabel('S-Parameter [dB]');
legend('S11','S12','S21','S22');
hold off

subplot(2,1,2)
hold on
plot(freqs/(1e6),angle(dataArray(:,1)));
plot(freqs/(1e6),angle(dataArray(:,2)));
plot(freqs/(1e6),angle(dataArray(:,3)));
p = plot(freqs/(1e6),angle(dataArray(:,4)));
title('S-Parameter Phase');
xlabel('Frequency [MHz]');
ylabel('S-Parameter [Radians]');
legend('S11','S12','S21','S22');
hold off