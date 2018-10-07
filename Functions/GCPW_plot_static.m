function [handles, p, err] = GCPW_plot_static(handles,x_start,x_stop,s,num,opt)

% N Michael Sheridan
% October 2018
% Plots one or more GCPWs (static impedance or permitivity)


%% Some wrappers to prevent mathematical inconsistancies

if((isempty(x_start)||isempty(x_stop)||isempty(num)||isempty(opt)||isempty(s)))
   err = 'Values entered incorrectly, please try again!';
   p = '';
end

if(x_start>x_stop)
    temp = x_start;
    x_start = x_stop;
    x_stop = temp;
end

if(x_start==x_stop)
    err = 'Please enter two DISTINCT ratio values!';
    p = NaN;
    return
end

if((num==0)||(isnan(num)))
    num = 1;
end


%% UI code & calculation prep

x = linspace(x_start,x_stop,(x_stop-x_start));

data_array = zeros(length(x),num);

prompt = cell(num,1);
legends = prompt;

for ii=1:num
    prompt{ii} = sprintf('Dielectric Constant (er) for Plot %i',ii);
end

userInput = inputdlg(prompt,sprintf('Enter Dielectric Constants for %i Plot(s)',num),[1 35]);


%% Calculations for Grounded Coplanar Waveguide

for ii=1:(x_stop-x_start)

    for jj=1:num
    
        if(strcmp(opt,'z0'))
            [~,data_array(ii,jj),~,~,~,~,~,err] = calc_GCPW_z0(str2double(userInput{jj}),(x_start+ii),...
                s,1,1,handles);
        end
        if(strcmp(opt,'ee'))
            [~,~,~,data_array(ii,jj),~,~,~,err] = calc_GCPW_z0(str2double(userInput{jj}),(x_start+ii),...
                s,1,1,handles);
        end

        if~isempty(err)
            p = NaN;
            return
        end
        
        legends{jj} = sprintf('er: %.1f', str2num(userInput{jj}));
        
    end
    
end


%% Plotting

cla(handles.plotter, 'reset')
set(handles.plotter, 'XScale', 'log')
hold(handles.plotter,'on')

for ii=1:num
   p = plot(handles.plotter,x,data_array(:,ii));
end

if(strcmp(opt,'z0'))
    title('Grounded Coplanar Waveguide Characteristic Impedance');
    ylabel('Impedance in Ohms');
    xlabel('Width/Height Ratio');
    legend(legends);
end
if(strcmp(opt,'ee'))
    title('Grounded Coplanar Waveguide Effective Dielectric Permitivity');
    ylabel('Dielectric Permitivity');
    xlabel('Width/Height Ratio');
    legend(legends);
end

hold(handles.plotter,'off')
