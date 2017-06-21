function varargout = APDetector(varargin)
% 
% Copyright (c) Yuichi Takeuchi 2017
%

% Last Modified by GUIDE v2.5 20-Jun-2017 20:53:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @APDetector_OpeningFcn, ...
                   'gui_OutputFcn',  @APDetector_OutputFcn, ...
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


% --- Executes just before APDetector is made visible.
function APDetector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to APDetector (see VARARGIN)

% Choose default command line output for APDetector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes APDetector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = APDetector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% panel1init(handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% panel1init(handles)
evalstr = ['StructData' num2str(handles.popupmenu2.Value) '(' num2str(handles.popupmenu3.Value) ').Voltage{' num2str(handles.popupmenu4.Value) ',1};'];
SrcWave = evalin('base', evalstr);
SegRange = eval(handles.listbox1.String{handles.listbox1.Value ,1});
threshold = str2double(handles.edit1.String);
sr = evalin('base', 'StructInfo.sr');
[pks, locs] = gfFindIntraAP(SrcWave, SegRange, threshold, sr);
assignin('base', 'pks', pks)
assignin('base', 'locs', locs)
%{
evalstr = 'obj.runCell(''Display and Find APs 1'');';
evalin('base',evalstr)
%}

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if evalin('base', 'exist(''StructAP'', ''var'')') ~= 1
    StructAP = struct([]);
else
    StructAP = evalin('base', 'StructAP');
end
recnum = length(StructAP);
pks = evalin('base', 'pks');
locs = evalin('base', 'locs');
intensity = gfstr2num1(handles, 'intensity');
group = gfstr2num1(handles, 'group');
series = gfstr2num1(handles, 'series');
sweep = gfstr2num1(handles, 'sweep');
sr = evalin('base', 'StructInfo.sr');
StructAP = gfAddLocsToStructAP1(StructAP, recnum, pks, locs, intensity, group, series, sweep, sr);
evalstr = ['StructData' num2str(handles.popupmenu2.Value) '(' num2str(handles.popupmenu3.Value) ').Voltage{' num2str(handles.popupmenu4.Value) ',1};'];
SrcWave = evalin('base', evalstr);
StructAP = gfCalcAPParams(StructAP, recnum, SrcWave, locs, sr);
assignin('base', 'StructAP', StructAP)
evalin('base', 'clear pks locs')
if isempty(locs)
    disp('no spike has been added!')
elseif length(locs) == 1
    fprintf('%d spike has been added!\n',1)
else
    fprintf('%d spikes have been added!\n', length(locs))
end
%{
panel1init(handles)
evalstr = 'obj.runCell(''Add pks and locs to StructAP 1'');clear ans;';
evalin('base',evalstr)
%}

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% panel1init(handles)


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
% panel1init(handles)

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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% panel1init(handles)


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% panel1init(handles)


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalstr = ['StructData' num2str(handles.popupmenu2.Value) '(' num2str(handles.popupmenu3.Value) ').Voltage{' num2str(handles.popupmenu4.Value) ',1};'];
SrcWave = evalin('base', evalstr);
pks = evalin('base', 'pks');
locs = evalin('base', 'locs');
[pks, locs] = gfRMLocs(SrcWave, pks, locs);
assignin('base', 'pks', pks)
assignin('base', 'locs', locs)
%{
panel1init(handles)
evalstr = 'obj.runCell(''Remove pks and locs 1''); clear ans;';
evalin('base',evalstr)
%}

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StructAP = evalin('base', 'StructAP');
StructAP = gfRemoveBlank(StructAP);
assignin('base', 'StructAP', StructAP)

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu5, 'Value', get(hObject, 'Value'));
% panel1init(handles)

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

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox1, 'Value', get(hObject, 'Value'));
% panel1init(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%% defined user defined funcs %%%%%
function panel1init(handles)
contents = cellstr(handles.popupmenu1.String);
assignin('base', 'GUItempvar', str2num(contents{handles.popupmenu1.Value}))
evalstr = ['StructPanel1.Intensity = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

contents = cellstr(handles.popupmenu2.String);
assignin('base', 'GUItempvar', str2num(contents{handles.popupmenu2.Value}))
evalstr = ['StructPanel1.Group = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

contents = cellstr(handles.popupmenu3.String);
assignin('base', 'GUItempvar', str2num(contents{handles.popupmenu3.Value}))
evalstr = ['StructPanel1.Series = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

contents = cellstr(handles.popupmenu4.String);
assignin('base', 'GUItempvar', str2num(contents{handles.popupmenu4.Value}))
evalstr = ['StructPanel1.Sweep = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

contents = cellstr(handles.popupmenu5.String);
assignin('base', 'GUItempvar', str2num(contents{handles.popupmenu5.Value}))
evalstr = ['StructPanel1.Segment = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

assignin('base', 'GUItempvar', str2double(handles.edit1.String))
evalstr = ['StructPanel1.Threshold = GUItempvar; clear GUItempvar;'];
evalin('base', evalstr)

contents = cellstr(handles.listbox1.String);
for k = [1:length(handles.listbox1.String)]
    evalstr = contents{k};
    tempcell2{k, 1} = eval(evalstr);
end
assignin('base', 'GUItempvar', tempcell2)
evalstr = 'StructPanel1.SegInfo = GUItempvar; clear GUItempvar;';
evalin('base', evalstr)

function [ StructAP ] = gfAddLocsToStructAP1(StructAP, recnum, pks, locs, intensity, group, series, sweep, sr)
%
%   Copyright (C) 2016 by Yuichi Takeuchi

for k = 1:length(pks)
    StructAP(recnum + k).Intensity = intensity;
    StructAP(recnum + k).Group = group;
    StructAP(recnum + k).Series = series;
    StructAP(recnum + k).Sweep = sweep;
    StructAP(recnum + k).PeakX = locs(k);
    StructAP(recnum + k).PeakY = pks(k);
    
    if (0 < locs(k) &&  locs(k) <= 2.5*sr)
        StructAP(recnum + k).Segment = 1;
    elseif (2.5 < locs(k) &&  locs(k) <= 5*sr)
        StructAP(recnum + k).Segment = 2;
    elseif (5 < locs(k) &&  locs(k) <= 7.5*sr)
        StructAP(recnum + k).Segment = 3;
    elseif (7.5 < locs(k) &&  locs(k) <= 10*sr)
        StructAP(recnum + k).Segment = 4;
    elseif (10 < locs(k) &&  locs(k) <= 12.5*sr)
        StructAP(recnum + k).Segment = 5;
    elseif (12.5 < locs(k) &&  locs(k) <= 15*sr)
        StructAP(recnum + k).Segment = 6;
    end
end

function [pks, locs] = gfFindIntraAP(SrcWave, SegRange, threshold, sr)
% 
% Copyright (C) 2016 by Yuichi Takeuchi

figure(1); plot(SrcWave); hold on
% Detect Action Pontentials
index1 = SrcWave(SegRange(1):SegRange(2)) > threshold;
index2 = [false;index1(1:(length(index1)-1))];
index3 = xor(index1, index2); index3(length(index3)) = false;
index4 = find(index3);
if rem(length(index4), 2) == 1
    index4 = index4(1:length(index4)-1);
end

pks = [];locs = [];

for k = 1:2:length(index4)
    [M, I] = max(SrcWave(index4(k)+SegRange(1):index4(k+1)+SegRange(1)));
    pks = [pks;M];
    locs = [locs;index4(k)+I-1 + SegRange(1)];
end

newlocs = []; newpks = [];
for m = 1: length(locs)
    for l = 1:30
        x1 = locs(m) + l - 32;
        x2 = locs(m) + l - 28;
        if (x1 < 1) || (x2  < 1)
            break
        elseif (SrcWave(x2) - SrcWave(x1))*sr/(x2 - x1) > 10
            newlocs = [newlocs;locs(m)];
            newpks = [newpks; pks(m)];
            break
        end
    end
end
locs = newlocs;
pks = newpks;
% [pks, locs] = findpeaks(SrcWave, 'Threshold', 0.00005, 'MinPeakHeight',
% 0.002, 'MinPeakDistance', 10);

plot(locs, pks, 'or');
% plot(XWave(locs), pks, 'or');
hold off

if isempty(locs)
    disp('no spike has been detected!')
elseif length(locs) == 1
    fprintf('%d spike has been detected!\n',1)
else
    fprintf('%d spikes have been detected!\n', length(locs))
end

function [value] = gfstr2num1(handles, strswitch)
% Converting string of popupmenu to number
% 
% Copyright (C) 2016 by Yuichi Takeuchi

switch strswitch
    case 'intensity'
        contents = cellstr(handles.popupmenu1.String);
        value = str2num(contents{handles.popupmenu1.Value});
    case 'group'
        contents = cellstr(handles.popupmenu2.String);
        value = str2num(contents{handles.popupmenu2.Value});
    case 'series'
        contents = cellstr(handles.popupmenu3.String);
        value = str2num(contents{handles.popupmenu3.Value});
    case 'sweep'
        contents = cellstr(handles.popupmenu4.String);
        value = str2num(contents{handles.popupmenu4.Value});
    case 'segment'
        contents = cellstr(handles.popupmenu5.String);
        value = str2num(contents{handles.popupmenu5.Value});
    otherwise
        value = NaN;
end

function [ StructAP ] = gfCalcAPParams(StructAP, recnum, SrcWave, locs, sr)
% gfCalcAPParams calucurates ThresX, ThresY, AP amplitude, Rise Time, AP half-width
% 
% Copyright (C) 2016 by Yuichi Takeuchi

k = 1;
for xlocs = locs'
    for l = 1:30
        x1 = xlocs + l - 32;
        x2 = xlocs + l - 28;
        if (SrcWave(x2) - SrcWave(x1))*sr/(x2 - x1) > 10
            x = mean([x1, x2]);
            StructAP(recnum + k).ThresX = x;
            StructAP(recnum + k).ThresY = SrcWave(x);
            StructAP(recnum + k).Amp = SrcWave(xlocs) - SrcWave(x);
            for m = 1:5
                if (SrcWave(xlocs - m + 1) - SrcWave(x + m)) < 0.9*(SrcWave(xlocs) - SrcWave(x))
                    StructAP(recnum + k).Rise = (xlocs - x - 2*m + 1)/sr;
                    break
                end
                if (SrcWave(xlocs - m) - SrcWave(x + m)) < 0.9*(SrcWave(xlocs) - SrcWave(x))
                    StructAP(recnum + k).Rise = (xlocs - x - 2*m)/sr;
                    break
                end
            end
            for o = 1:30
                if (SrcWave(xlocs) - SrcWave(xlocs - o)) > 0.5*(SrcWave(xlocs) - SrcWave(x))
                    for n = 1:60
                        if (SrcWave(xlocs) - SrcWave(xlocs + n)) > 0.5*(SrcWave(xlocs) - SrcWave(x))
                            StructAP(recnum + k).APhw = (n + o -1)/sr;
                            break
                        end
                    end
                    break
                end
            end
            break
        end
    end
    k = k + 1;
end

function [pks, locs] = gfRMLocs(SrcWave, pks, locs)
% 
% Copyright (C) 2016 by Yuichi Takeuchi

figure(1)
ax = gca;
index = locs < ax.XLim(1) | locs > ax.XLim(2) | pks < ax.YLim(1) | pks > ax.YLim(2);
locs = locs(index);
pks = pks(index);

if isempty(locs)
    disp('no spike has been remaining!')
elseif length(locs) == 1
    fprintf('%d spike has been remaining!\n',1)
else
    fprintf('%d spikes have been remaining!\n', length(locs))
end

plot(SrcWave);
hold on
plot(locs, pks, 'or');
hold off

function [StructAP] = gfRemoveBlank(StructAP)
%
% Copyright (C) 2016 by Yuichi Takeuchi

[~, recsize] = size(StructAP);
for k = 1:recsize
    index(k) = isempty(StructAP(k).APhw);
end
blanknum = length(find(index, 1));
StructAP(index) = [];

if isempty(blanknum)
    disp('no record has been removed!')
elseif blanknum == 1
    fprintf('%d record has been removed!\n',1)
else
    fprintf('%d records have been removed!\n', blanknum)
end
