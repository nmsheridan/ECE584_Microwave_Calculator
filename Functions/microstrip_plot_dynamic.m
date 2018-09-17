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


%% UI code & calculation prep

x = linspace(f_start,f_stop,(f_stop-f_start));

data_array = zeros(length(x),num);

prompt = cell(num+1,1);
legends = cell(num,1);
prompt{1} = 'Length/Width Ratio for Plot';

for ii=1:num
    prompt{ii+1} = sprintf('Dielectric Constant (er) for Plot %i',ii);
end

userInput = inputdlg(prompt,sprintf('Enter Dielectric Constants for %i Plot(s)',num),[1 35]);


%% Calculations for impedance

w = str2num(userInput{1});
h = 1;

for ii=1:(f_stop-f_start)

    for jj=1:num
    
        er = str2double(userInput{jj});
        
        [~,z0,ee,err] = calc_microstrip_z0(er,(f_start+ii),1,handles,1);
        
        ft = sqrt(er/ee)*(z0/(2*(4*pi*1E-07)*h));
        
        ereff = er - ((er-ee)/(1+((ii/ft)^2)));
        
        if(strcmp(opt,'er'))
            data_array(ii,jj) = ereff;
        end
        
        if(strcmp(opt,'z0'))
            weff = (120*pi*h)/(z0*sqrt(ee));
            we = w + ((weff-w)/(1+((ii/ft)^2)));
            
            z0f = (120*pi*h)/(we*sqrt(ereff));
            
            data_array(ii,jj) = z0f;
        end
        
        if~isempty(err)
            p = NaN;
            return
        end
        
        legends{jj} = sprintf('er: %i', str2num(userInput{jj+1}));
        
    end
    
end


%% Plotting

cla(handles.plotter, 'reset')
set(handles.plotter, 'XScale', 'log')
hold(handles.plotter,'on')

for ii=1:num
   p = plot(handles.plotter,x,data_array(:,ii));
end


if(strcmp(opt,'er'))
    title('Dynamic Equivalent Dielectric Constant');
    ylabel('Dielectric Constant');
    xlabel('Frequency in Hz');
    legend(legends);
end
if(strcmp(opt,'z0'))
    title('Dynamic Characteristic Impedance');
    ylabel('Impedance in Ohms');
    xlabel('Frequency in Hz');
    legend(legends);
end

hold(handles.plotter,'off')
