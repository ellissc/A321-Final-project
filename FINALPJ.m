function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 26-Apr-2021 15:38:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)
% Create the data to plot.
global T;
T = readtable('A321_data.xlsx');
global W;
W = readtable('A321_data_fixed.xlsx');
global S;
% S = shaperead('usastatelo.shp');
load('stateShape.mat', 'S'); 
% show the map
mapshow(S)
handles.year = '2019';
handles.specific = 'Barrels Produced';
handles.hZoom = zoom;
handles.axesLimits = get(handles.axes1,{'xlim','ylim'});
 

set(handles.hZoom, 'Enable', 'on');

guidata(hObject, handles);





% Choose default command line output for project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val}
case '2019' % User selects peaks.
   handles.year = '2019';
case '2020' % User selects membrane.
   handles.year = '2020';
end
% Save the handles structure.
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val}
case 'Barrels Produced' % User selects peaks.
   handles.specific = 'Barrels Produced';
case 'Avg Personal Income' % User selects peaks.
   handles.specific = 'Avg Personal Income';    
end
% Save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global T;
global S;

barrelsMax = max(max(T.BarrelsProduced_2019_), max(T.BarrelsProduced_2020_));
avgIncMax = max(max(T.YearlyIncomePerCapita2019), max(T.YearlyIncomePerCapita2020));

if(strcmp(handles.year, '2019'))
    if(strcmp(handles.specific,'Barrels Produced'))
        dataRaw = T.BarrelsProduced_2019_;
        maxi = barrelsMax;
    elseif(strcmp(handles.specific, 'Avg Personal Income'))
        dataRaw = T.YearlyIncomePerCapita2019;
        maxi = avgIncMax;
    end
elseif(handles.year == "2020")
    if(strcmp(handles.specific, 'Barrels Produced'))
        dataRaw = T.BarrelsProduced_2020_;
        maxi = barrelsMax;
    elseif(strcmp(handles.specific,'Avg Personal Income'))
        dataRaw = T.YearlyIncomePerCapita2020;
        maxi = avgIncMax;
    end
end

%normalize data
data = cast((256*(dataRaw)/maxi),'uint8');

% show the map
mapshow(S)
% get the current colormap
cmap = colormap;
% set the colors of the regions using the 'FaceColor' -property
for i = 1:length(S)-1
    % FaceColor is now a color from the current colormap, determined by
    % it's data value
    mapshow(S(i),'FaceColor',cmap(data(i),:));
    text([S(i).LabelLon], [S(i).LabelLat], {S(i).Abbrev, data(i)}, ...
        'Color', [0 0 0], 'BackgroundColor',cmap(data(i),:),'Clipping',...
        'on', 'Margin', 1, 'FontSize', 7);
end
caxis([0,maxi]);
colorbar();





% --- Executes on button press in pushbutton1.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global W;
global S;

axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu3, 'Value');
switch popup_sel_index
    case 1
        plot(W.AvgPersonalIncome_2020Q4_,'-r');
        hold on;
        plot(W.AveragePersonalIncome_2019Q4_,'--b');
        legend('2020','2019');
        title('2019 and 2020 Average Personal Income');
        xlabel('Alphabetical States A->Z');
        ylabel('Personal Income'); 
        hold off;
    case 2
        plot(W.BarrelsProduced_2020_,'-r');
        hold on;
        plot(W.BarrelsProduced_2019_,'--b');
        legend('2020','2019');
        title('2019 and 2020 Barrles Produced');
        xlabel('Alphabetical States A->Z');
        ylabel('Barrles Produced');
        hold off;
    case 3
        bar(W.EconomicImpact_2019_);
        hold on;
        title('Bar Graph of Economic Impact');
        xlabel('Alphabetical States A->Z');
        ylabel('Economic Impact');
        hold off;
    case 4
        scatter(W.EconomicImpact_2019_,W.BarrelsProduced_2019_);
        hold on;
        title('Economic Impact vs Barrles Produced');
        f = fit(W.EconomicImpact_2019_,W.BarrelsProduced_2019_,'poly1');
        plot(f,W.EconomicImpact_2019_,W.BarrelsProduced_2019_);
        xlabel('Economic Impact');
        ylabel('Barrels Produced');
        hold off;
    case 5
        scatter(W.EconomicImpact_2019_,W.AveragePersonalIncome_2019Q4_);
        hold on;
        title('Economic Impact vs Average Personal Income');
        f = fit(W.EconomicImpact_2019_,W.AveragePersonalIncome_2019Q4_,'poly1');
        plot(f,W.EconomicImpact_2019_,W.AveragePersonalIncome_2019Q4_);
        xlabel('Economic Impact');
        ylabel('Average Personal Income');
        hold off;
    case 6
        mapshow(S)
        hold on;
        xlabel('Latitude');
        ylabel('Longitude');
        hold off;
end



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Average Income Comparison', 'Barrels Produced Comparison','Economic impact (2019)','Economic Impact vs Barrles Produced','Economic Impact vs Average Personal Income','Back To Map Mode'});
