function [handles, p, err] = microstrip_plot_dynamic(handles,f_start,f_stop,num,opt)

% N Michael Sheridan
% September 2018
% Plots one or more microstrip static characteristc impedances
% This code contains part of my solution to Problem 3 of Homework 1!


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

%% UI code & calculation prep

num = round(num);

x = linspace(0,handles.plotPoints,handles.plotPoints);
freqs = linspace(f_start,f_stop,handles.plotPoints);

data_array = zeros(length(x),num);

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

w = (str2num(userInput{1}))*(1E-3);
h = (str2num(userInput{2}))*(1E-3);

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
    
%     f = ((ii-1)*(f_stop-f_start)/length(x))+f_start;
%     freqs(ii) = f;
    
    for jj=1:num
    
        er = str2double(userInput{jj+2});
        
        [~,z0,z0air,ee,ereff,~,~,~,~,err] = calc_microstrip_z0(er,w,h,(f/1e6),handles,1);
        
         
%         ft = sqrt(er/ee)*z0/(2*(4*pi*1e-07)*h);
%         ereff = er - ((er-ee)/(1+((f/ft)^2)));
        
%         fp = z0/(8*pi*h);  Pozar's equations
%         
%         g = 0.6 + 0.009*z0;
%         
%         Gf = g*((f/fp)^2);
%         
%         ereff = er - ((er-ee)/(1+Gf));

        if(strcmp(opt,'er'))
            data_array(ii,jj) = ereff;
        end
        
        if(strcmp(opt,'z0'))
            data_array(ii,jj) = z0;
%            ft = sqrt(er/ee)*(z0/(2*(4*pi*1E-07)*h));
            
%            weff = (120*pi*h)/(z0*sqrt(ee));
%            we = w + ((weff-w)/(1+((f/ft)^2)));
            
%            data_array(ii,jj) = (120*pi*h)/(we*sqrt(ereff));
        end
        
        if(strcmp(opt,'velocity'))
            
%             x = w/h;
%             
%             if(x<1)
%                 z0air = (60)*log((8/x)+0.25*x);
%             end
%             
%             if(x>=1)
%                 z0air = (120*pi)/(x+1.393+0.667*log(x+1.444));
%             end
%             
%             weff = (120*pi*h)/(z0*sqrt(ee));
%             we = w + ((weff-w)/(1+((f/ft)^2)));
%             
%             z0f = (120*pi*h)/(we*sqrt(ereff));
            
            data_array(ii,jj) = (3e08)*z0/z0air; 
        end
        
        if(strcmp(opt,'delay'))
            
%             x = w/h;
%             
%             if(x<1)
%                 z0air = (60)*log((8/x)+0.25*x);
%             end
%             
%             if(x>=1)
%                 z0air = (120*pi)/(x+1.393+0.667*log(x+1.444));
%             end
%             
%             weff = (120*pi*h)/(z0*sqrt(ee));
%             we = w + ((weff-w)/(1+((f/ft)^2)));
%             
%             z0f = (120*pi*h)/(we*sqrt(ereff));
            
            data_array(ii,jj) = (1e12*l)/(3e08)*z0/z0air; 
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

for ii=1:num
   p = plot(handles.plotter,(freqs/1e6),round(data_array(:,ii),3));
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

hold(handles.plotter,'off')
