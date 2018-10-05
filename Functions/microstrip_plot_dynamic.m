function [handles, p, err] = microstrip_plot_dynamic(handles,f_start,f_stop,num,opt)

% N Michael Sheridan
% September 2018
% Plots one or more microstrip static characteristc impedances
% This code contains part of my solution to Problem 3 of Homework 1!
% 
% Frequencies are entered in MHz!
% 'num' is the number of dielectrics you want to plot
% 'opt' lets you tell the function which quanitity you want to plot
%
% In almost all situations, the outputs of this function don't really
% matter

%% Some wrappers to prevent mathematical inconsistancies
if(f_start>f_stop)
    temp = f_start;
    f_start = f_stop;
    f_stop = temp;
end

if(f_start==f_stop)
    err = 'Please enter two DISTINCT frequency values!';
    p = NaN;
    return
end

if((num==0)||(isnan(num)))
    num = 1;
end

f_start = f_start*(1e6);  %user input is entered in MHz
f_stop = f_stop*(1e6);

p = NaN;

%% UI code & calculation prep

num = round(num);

x = linspace(0,handles.plotPoints,handles.plotPoints);
freqs = linspace(f_start,f_stop,handles.plotPoints);

data_array = zeros(length(x),num);

if(strcmp(opt,'beta'))
   er_array = zeros(length(x),num);
   ereff_array = zeros(length(x),num);
end

prompt = cell(num+2,1);
legends = cell(num,1);
prompt{1} = 'Conductor Width for Plot [mm]';
prompt{2} = 'Dielectric Height for Plot [mm]';

for ii=1:num
    prompt{ii+2} = sprintf('Dielectric Constant (er) for Plot %i',ii);
end

userInput = inputdlg(prompt,sprintf('Enter Dielectric Constants for %i Plot(s)',num),[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!')
    return
end


%% Calculations for impedance

w = (str2num(userInput{1}));
h = (str2num(userInput{2}));

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
    
    for jj=1:num
    
        er = str2double(userInput{jj+2});
        
        [~,z0,z0air,ee,ereff,~,~,B,~,Vg,err] = calc_microstrip_z0(er,w,h,(f/1e6),handles,1);

        if(strcmp(opt,'er'))
            data_array(ii,jj) = ereff;
        end
        
        if(strcmp(opt,'z0'))
            data_array(ii,jj) = z0;
        end
        
        if(strcmp(opt,'velocity'))
            data_array(ii,jj) = Vg; 
        end
        
        if(strcmp(opt,'delay'))
            data_array(ii,jj) = (l/Vg)*1e12; %in ps 
        end
        
        if(strcmp(opt,'beta'))
            data_array(ii,jj) = B;
            er_array(ii,jj) = (2*pi*f)*sqrt(er)/(3e8);
            ereff_array(ii,jj) = (2*pi*f)*sqrt(ee)/(3e8);
        end
        
        if~isempty(err)
            p = NaN;
            return
        end
        
        legends{jj} = sprintf('er: %.1f', str2num(userInput{jj+2}));
        
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
    for ii=1:num
        axis(handles.plotter,[0 100 ((2*pi*f_start)/(3e8)) ((2*pi*f_stop)/(3e8))]);
        axis 'auto x'
        p = plot(handles.plotter,data_array(:,ii),(2*pi*freqs)/(3e8));
        p = plot(handles.plotter,er_array(:,ii),(2*pi*freqs)/(3e8),'--g');
        p = plot(handles.plotter,ereff_array(:,ii),(2*pi*freqs)/(3e8),'--r');
    end
else
    for ii=1:num
        p = plot(handles.plotter,(freqs/1e6),data_array(:,ii));
    end
end

if(strcmp(opt,'er'))
    title('Dynamic Equivalent Dielectric Constant');
    ylabel('Dielectric Constant');
    xlabel('Frequency in MHz');
    legend(legends);
end
if(strcmp(opt,'z0'))
    title('Dynamic Characteristic Impedance');
    ylabel('Impedance in Ohms');
    xlabel('Frequency in MHz');
    legend(legends);
end
if(strcmp(opt,'velocity'))
    title('Group Velocity');
    ylabel('Velocity in m/s');
    xlabel('Frequency in MHz');
    legend(legends);
end
if(strcmp(opt,'delay'))
    title('Group Delay');
    ylabel('Delay in ps');
    xlabel('Frequency in MHz');
    legend(legends);
end
if(strcmp(opt,'beta'))
    title('Propigation Constant');
    ylabel('Frequency (k)');
    xlabel('Propagation Constant (B)');
    legend(legends);
end

hold(handles.plotter,'off')
