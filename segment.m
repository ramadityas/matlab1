function varargout = segment(varargin)
% SEGMENT M-file for segment.fig
%      SEGMENT, by itself, creates a new SEGMENT or raises the existing
%      singleton*.
%
%      H = SEGMENT returns the handle to a new SEGMENT or the handle to
%      the existing singleton*.
%
%      SEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENT.M with the given input arguments.
%
%      SEGMENT('Property','Value',...) creates a new SEGMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segment

% Last Modified by GUIDE v2.5 12-Jan-2015 20:52:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segment_OpeningFcn, ...
                   'gui_OutputFcn',  @segment_OutputFcn, ...
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


% --- Executes just before segment is made visible.
function segment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segment (see VARARGIN)

% Choose default command line output for segment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name_file1,name_path1] = uigetfile( ...
{'*.bmp;*.jpg;*.tif','Files of type (*.bmp,*.jpg,*.tif)';
'*.bmp','File Bitmap (*.bmp)';...
'*.jpg','File jpeg (*.jpg)';
'*.tif','File Tif (*.tif)';
'*.*','All Files (*.*)'},...
'Open Image');
 
if ~isequal(name_file1,0)
handles.data1 = imread(fullfile(name_path1,name_file1));
guidata(hObject,handles);
axes(handles.axes1);
imshow(handles.data1);
else
return;
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.data1;
B=rgb2gray(image1);
C=double(B);
for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction:
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %Sobel mask for y-direction:
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
     
        %The gradient of the image
        %B(i,j)=abs(Gx)+abs(Gy);
        B(i,j)=sqrt(Gx.^2+Gy.^2);
     
    end
end
handles.data2 = B;
guidata(hObject,handles);
axes(handles.axes2);
imshow(handles.data2);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.data2;
B = graythresh(I);
BW = im2bw(handles.data1,B);
BW2 = not(BW);
BW3 = bwareaopen(BW2, 0);
handles.data3 = BW3;
guidata(hObject,handles);
axes(handles.axes3);
imshow(handles.data3);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.data1;
BW3 = handles.data3;
a=2000;
z=4000;
BW4 = xor(bwareaopen(BW3,a),bwareaopen(BW3,z));
row = size(img,1);
col = size(img,2);
for i = 1 : row
    for j = 1 : col
        if BW4(i,j) == 0
           I(i,j) = 0;
        elseif BW4(i,j) == 1
           I(i,j) = img(i,j);
        end
    end
end
imMasked = uint8(I);
figure, imshow(imMasked), title('Hasil crop Citra Asli');
