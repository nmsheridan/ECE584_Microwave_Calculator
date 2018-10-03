function [handles, p, err] = stripline_plot_static_z0(handles,x_start,x_stop,num)

% N Michael Sheridan
% September 2018
% Plots one or more stripline static characteristc impedances


%% Some wrappers to prevent mathematical inconsistancies
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


%% Calculations for impedance

for ii=1:(x_stop-x_start)

    for jj=1:num
    
        [~,data_array(ii,jj),~,~,~,err] = calc_stripline_z0(str2double(userInput{jj}),(x_start+ii),...
            1,handles,1);
        
        if~isempty(err)
            p = NaN;
            return
        end
        
        legends{jj} = sprintf('er: %i', str2num(userInput{jj}));
        
    end
    
end


%% Plotting

cla(handles.plotter, 'reset')
set(handles.plotter, 'XScale', 'log')
hold(handles.plotter,'on')

for ii=1:num
   p = plot(handles.plotter,x,data_array(:,ii));
end

title('Static Characteristic Impedance');
ylabel('Impedance in Ohms');
xlabel('Width/Height Ratio');
legend(legends);

hold(handles.plotter,'off')
