function varargout = TLINE_GUI(varargin)
% TLINE_GUI MATLAB code for TLINE_GUI.fig
%      TLINE_GUI, by itself, creates a new TLINE_GUI or raises the existing
%      singleton*.
%
%      H = TLINE_GUI returns the handle to a new TLINE_GUI or the handle to
%      the existing singleton*.
%
%      TLINE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TLINE_GUI.M with the given input arguments.
%
%      TLINE_GUI('Property','Value',...) creates a new TLINE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TLINE_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TLINE_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TLINE_GUI

% Last Modified by GUIDE v2.5 06-Oct-2018 11:44:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TLINE_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TLINE_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TLINE_GUI is made visible.
function TLINE_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TLINE_GUI (see VARARGIN)

% Choose default command line output for TLINE_GUI
handles.output = hObject;

% Sets some user defaults for plot tools
handles.plotPoints = 10001;

% This will allow the parameters of a transmission line to be saved to
% memory for reflection/power delivered calculations
handles.z0 = cell(2);
handles.L = cell(2);
handles.C = cell(2);
handles.R = cell(2);
handles.G = cell(2);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TLINE_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TLINE_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Calculator Panel

% --- Executes on button press in twoWire_Z0.
function twoWire_Z0_Callback(hObject, eventdata, handles)
% hObject    handle to twoWire_Z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%User prompts to be used in inputdlg
prompt = {'Dielectric Constant (er)','Wire Diameter in mm (d)',...
    'Wire Distance in mm (D)'};

%Prompts the user for the permitivity, wire diameter and wire distance
userInput = inputdlg(prompt,'Enter Paramaters for Two-Wire T-Line',[1 35]);

%Needed in case the user closes the dialog window
if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

%Function call to the calc_twoWire_z0 function
[~,~,err] = calc_twoWire_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),handles);

%Prints-out error from calculator function (if there is one)
if~isempty(err)
    warndlg(err);
end

%All TLine z0 calculators have the same UI code associated with them



% --- Executes on button press in coax_z0.
function coax_z0_Callback(hObject, eventdata, handles)
% hObject    handle to coax_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Inner Diameter in mm (d)',...
    'Outter Diameter in mm (D)'};

userInput = inputdlg(prompt,'Enter Paramaters for Coaxial T-Line',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = calc_coax_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),handles);
    
if~isempty(err)
    warndlg(err);
end


% --- Executes on button press in stripline_z0.
function stripline_z0_Callback(hObject, eventdata, handles)
% hObject    handle to stripline_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Embedded Conductor Width in mm (w)',...
    'Ground Plane Distance in mm (b)'};

userInput = inputdlg(prompt,'Enter Paramaters for Stripline',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,~,~,~,err] = calc_stripline_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),handles,NaN);
    
if~isempty(err)
    warndlg(err);
end


% --- Executes on button press in microstrip_z0.
function microstrip_z0_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Strip Width in mm (w)',...
    'Conductor Distance in mm (b)','Frequency in MHz (f)'};

userInput = inputdlg(prompt,'Enter Paramaters for Microstrip Line',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,~,~,~,~,~,~,~,~,err] = calc_microstrip_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),str2double(userInput{4}),handles,NaN);
    
if~isempty(err)
    warndlg(err);
end



% --- Executes on button press in CPW_z0.
function CPW_z0_Callback(hObject, eventdata, handles)
% hObject    handle to CPW_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Conductor Width in mm (w)',...
    'Ground Pour Separation in mm (s)','Dielectric Height (for Slub CPW) in mm (h)'};

userInput = inputdlg(prompt,'Enter Paramaters for Stripline',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,~,~,~,~,~,err] = calc_CPW_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),str2double(userInput{4}),NaN,handles);
    
if~isempty(err)
    warndlg(err);
end

% --- Executes on button press in GCPW_z0.
function GCPW_z0_Callback(hObject, eventdata, handles)
% hObject    handle to GCPW_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Conductor Width in mm (w)',...
    'Ground Pour Separation in mm (s)','Dielectric Height in mm (h)'};

userInput = inputdlg(prompt,'Enter Paramaters for Stripline',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,~,~,~,~,~,err] = calc_CPW_z0(str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),str2double(userInput{4}),NaN,handles);
    
if~isempty(err)
    warndlg(err);
end


%% Designer Panel

% --- Executes on button press in design_stripline.
function design_stripline_Callback(hObject, eventdata, handles)
% hObject    handle to design_stripline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%User prompts for designers
prompt = {'Dielectric Constant (er)','Characteristic Impedence (Zo)',...
    'Embedded Conductor Width in mm (w)','Ground Plane Distance in mm (b)'};

%Dialog box for use input
userInput = inputdlg(prompt,'Enter Paramaters for Stripline',[1 35]);

%Needed in case the user closes the dialog window
if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

%Function call to designer function; transmission line dimensions are
%returned
[handles,w,b,diff,err] = design_stripline(str2double(userInput{1}),...
    str2double(userInput{2}),str2double(userInput{3}),str2double(userInput{4}),handles);

%Displays warning or displays the results returned from the designer
%function
if~isempty(err)
    warndlg(err);
else
    questdlg(sprintf('Your stripline should have:\n\nW: %d\nB: %d\ner: %d\nZo: %d\n% error: %d %',...
        w, b, str2num(userInput{1}), str2num(userInput{2}), diff),'Result','OK','OK');
end


% --- Executes on button press in design_microstrip.
function design_microstrip_Callback(hObject, eventdata, handles)
% hObject    handle to design_microstrip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Dielectric Constant (er)','Characteristic Impedence (Zo)',...
    'Conductor Width in mm (w)','Ground Plane Distance in mm (b)'};

userInput = inputdlg(prompt,'Enter Paramaters for Microstrip Tranmission Line',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[handles,w,b,diff,err] = design_microstrip(str2double(userInput{1}),...
    str2double(userInput{2}),str2double(userInput{3}),str2double(userInput{4}),handles);
    
if~isempty(err)
    warndlg(err);
else
    questdlg(sprintf('Your microstrip T-Line should have:\n\nW: %d\nB: %d\ner: %d\nZo: %d\n% error: %d %',...
        w, b, str2num(userInput{1}), str2num(userInput{2}), diff),'Result','OK','OK');
end


%% Reference Pannel

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String')); % returns listbox1 contents as cell array
selection = contents{get(hObject,'Value')}; % returns selected item from listbox1
ii = 1;
while((~strcmp(handles.materials{ii,1},selection))&&(ii<height(handles.materials)))
   ii = ii + 1; 
end
if(ii==(height(handles.materials)+1))
    set(handles.info_name, 'String', selection);
    set(handles.info_er, 'String', 'UNKNOWN');
    set(handles.info_tand, 'String', 'UNKNOWN');
    ii = height(handles.materials) + 1;
else
    set(handles.info_name, 'String', handles.materials{ii,1});
    set(handles.info_er, 'String', handles.materials{ii,2});
    set(handles.info_tand, 'String', handles.materials{ii,3});
    ii = height(handles.materials) + 1;
end



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%This reads in all the material data from a CSV file and saves it to
%handles
handles.materials = readtable('Materials.csv');

guidata(hObject, handles);



%% Plot Tools Menu Options

% --------------------------------------------------------------------
function plot_tools_Callback(hObject, eventdata, handles)
% hObject    handle to plot_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function microstrip_plot_tools_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function microstrip_plot_er_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_er (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%User prompts for plotter
prompt = {'Staring w/b ratio','Ending w/b ratio','How many Dielectrics do you want to Plot?'};

%Prompts user for plot settings using the above prompts
userInput = inputdlg(prompt,'Enter Plot Settings', [1 35]);

%Needed if user closes dialog window
if(isempty(userInput))
    warndlg('Cancelled!');
    return
end


%Function call to plotter tool
[~,~,err] = microstrip_plot_static_er(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}));

%Prints-out errors if applicable
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function microstrip_plot_z0_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring w/b ratio','Ending w/b ratio','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_static_z0(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}));
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function microstrip_plot_z0f_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_z0f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring Frequency [MHz]','Ending Frequency [MHz]','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_dynamic(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),'z0');
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function microstrip_plot_erf_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_erf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring Frequency [MHz]','Ending Frequency [MHz]','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_dynamic(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),'er');
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function stripline_plot_z0_Callback(hObject, eventdata, handles)
% hObject    handle to stripline_plot_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring w/b ratio','Ending w/b ratio','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = stripline_plot_static_z0(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}));
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function settings_Callback(hObject, eventdata, handles)
% hObject    handle to settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function preferences_Callback(hObject, eventdata, handles)
% hObject    handle to preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt{1} = 'Number of points for disperion plots';

preferences = inputdlg(prompt,'User Preferences', [1 35]);

if(isempty(preferences))
    warndlg('Canceled!');
    return
end

if((str2num(preferences{1})<100)||(str2num(preferences{1})>100e6))
    warndlg('Plot points out of acceptable bounds!');
    return
end

handles.plotPoints = str2num(preferences{1});

guidata(hObject, handles);




% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

info = fileread('About.txt');

userInput = questdlg(info,'About','OK','OK');

if(isempty(userInput))
    return
end


% --------------------------------------------------------------------
function stripline_Callback(hObject, eventdata, handles)
% hObject    handle to stripline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function microstrip_plot_velocity_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring Frequency [MHz]','Ending Frequency [MHz]','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_dynamic(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),'velocity');
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function microstrip_plot_delay_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring Frequency [MHz]','Ending Frequency [MHz]','How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_dynamic(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),'delay');
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function microstrip_plot_wavenumber_Callback(hObject, eventdata, handles)
% hObject    handle to microstrip_plot_wavenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% THIS PLOTS PROPAGATION CONSTANT, I MISTAKENLY CALLED THIS 'WAVENUMBER'

prompt = {'Staring Frequency [MHz]','Ending Frequency [MHz]','How many Dielectrics do you want to Plot?'};

userInput = inputdlg(prompt,'Enter Plot Settings',[1 35]);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = microstrip_plot_dynamic(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),'beta');
    
if~isempty(err)
    warndlg(err);
end


% --------------------------------------------------------------------
function GCPW_Callback(hObject, eventdata, handles)
% hObject    handle to GCPW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GCPW_plot_z0_Callback(hObject, eventdata, handles)
% hObject    handle to GCPW_plot_z0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring w/h ratio','Ending w/h ratio','Ground Pour Separation (s)',...
    'How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = GCPW_plot_static(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),str2double(userInput{4}),'z0');
    
if~isempty(err)
    warndlg(err);
end

% --------------------------------------------------------------------
function GCPW_plot_ee_Callback(hObject, eventdata, handles)
% hObject    handle to GCPW_plot_ee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Staring w/h ratio','Ending w/h ratio','Ground Pour Separation (s)',...
    'How many Dielectrics do you want to Plot?'};

dims = [1 35];
userInput = inputdlg(prompt,'Enter Plot Settings',dims);

if(isempty(userInput))
    warndlg('Cancelled!');
    return
end

[~,~,err] = GCPW_plot_static(handles,str2double(userInput{1}),str2double(userInput{2}),...
        str2double(userInput{3}),str2double(userInput{4}),'ee');
    
if~isempty(err)
    warndlg(err);
end
