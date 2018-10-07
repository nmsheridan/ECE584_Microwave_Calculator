function [handles, p, err] = arbitrary_plot_static(Ls,Cs,Cp,f_start,f_stop,opt,handles)

% Written by N. Michael Sheridan
% October 2018
% Plots various parameters of an arbitrary transmission line

%% Some wrappers to make this whole thing work
if(isempty(Ls)||isempty(Cs)||isempty(Cp)||isempty(f_start)||isempty(f_stop))
   err = 'Invalid parameters entered!';
   p = '';
   return
end

if(f_start>f_stop)
   temp = f_start;
   f_start = f_stop;
   f_stop = temp;
end

err = '';
%% Setting up for calculations
x = linspace(0,handles.plotPoints,handles.plotPoints);
freqs = linspace(f_start,f_stop,handles.plotPoints);

data_array = zeros(length(x),1);


%% Transmission line calucations begin here
bar = waitbar(0, 'Calculating...');

if(strcmp(opt,'delay'))
   l = inputdlg('Enter length of Transmission Line in mm','Length',[1 35]);
   if(isempty(1))
       warndlg('Cancelled!');
       return
   end
   l = str2double(l)/1000;
end

for ii=1:length(x)

    f = freqs(ii);
    
        if(strcmp(opt,'group'))
           data_array(ii,1) = sqrt(((2*pi*f)^2)*Ls*Cp + (Cp/Cs))/(2*pi*f*Ls*Cp); 
        end
        
        if(strcmp(opt,'velocity'))
            data_array(ii,1) = sqrt(((2*pi*f)^2)/(((2*pi*f)^2)*Ls*Cp+(Cp/Cs))); 
        end
        
        if(strcmp(opt,'delay'))
            data_array(ii,1) = (sqrt(((2*pi*f)^2)*Ls*Cp + (Cp/Cs))/(2*pi*f*Ls*Cp))*l*1e9; %in ps, length in mm 
        end
        
        if(strcmp(opt,'beta'))
            data_array(ii,1) = sqrt(((2*pi*f)^2)*Ls*Cp + (Cp/Cs));
        end
        
        if~isempty(err)
            p = NaN;
            return
        end
        
    waitbar((ii/length(x)),bar,'Calculating...');
    
end

close(bar)

%% Plotting

cla(handles.plotter, 'reset')
set(handles.plotter, 'XScale', 'lin')
axis(handles.plotter,[(f_start/1e6) (f_stop/1e6) 0 100])
axis 'auto y'
hold(handles.plotter,'on')

if(strcmp(opt,'beta'))
        axis(handles.plotter,[0 100 ((2*pi*f_start)/(3e8)) ((2*pi*f_stop)/(3e8))]);
        axis 'auto x'
        p = plot(handles.plotter,data_array(:,1),(2*pi*freqs)/(3e8));
else
        p = plot(handles.plotter,(freqs/1e6),data_array(:,1));
end


if(strcmp(opt,'velocity'))
    title('Phase Velocity');
    ylabel('Velocity in m/s');
    xlabel('Frequency in MHz');
end
if(strcmp(opt,'group'))
    title('Group Velocity');
    ylabel('Velocity in m/s');
    xlabel('Frequency in MHz');
end
if(strcmp(opt,'delay'))
    title('Group Delay');
    ylabel('Delay in ps');
    xlabel('Frequency in MHz');
end
if(strcmp(opt,'beta'))
    title('Propigation Constant');
    ylabel('Frequency (k)');
    xlabel('Propagation Constant (B)');
end

hold(handles.plotter,'off')
