%% ALL Setup
% Fred liu 2022.03.01
% 2022.05.17 update  
% 2023.03.08 major update(Instance Segmentation)
%% 使用流程 Manual
% 1.先使用此份檔案做Setup的路徑載入，以及gTruth檔案的載入
% (Load the path for Setup using this file first, and load the gTruth file.)

% 2.選擇 num =1 > 物件偵測  num = 2 > 語意分割
%(Select num = 1 for object detection, and num = 2 for semantic segmentation.)

% 3.更改你的資料路徑(NewPath or Source,Label)
%(Change your data path.)

%% 教學Live Script
% HowToUseGPU.mlx : GPU使用教學
% YOLOv4_inference.mlx : 進行YOLOv4推理(使用內建模型)
% YOLOv4_bulid.mlx : 客製化YOLOv4架構

%% Setup
addpath('src_main');  %主程式main funcion
addpath('src_input'); %格式載入input function
addpath('src_fun');   %副程式function list
addpath('label');     %標記資料Label
addpath('model');     %模型Model 
addpath('Img');       %範例影像Example Image

%% Load gTruth and change path
% 選擇要載入的標記檔案，可以使用物件偵測與語意分割
% (You can select the tag file to load and use object detection and semantic segmentation)

num = 1;
switch(num)
    
    %(NewPath) 這裡更改你的資料路徑Change your data path
    case 1 % Object Detection（物件偵測）
        NewPath = 'D:\Fred\MATLAB_Library(Github)\RabbitDetect\Rabbit_myself_608\';
        T_gTruth = Change_gTruthPath(NewPath);
    
    %(SourceData) 這裡更改你的資料路徑Change your data path
    %(LabelData) 這裡更改你的資料路徑Change your data path
    case 2 % Semantic segmentation（語意分割）
        SourceData = 'D:\Fred\MATLAB_Library(Github)\RabbitDetect\Rabbit_myself_608\';
        LabelData = 'D:\Fred\MATLAB_Library(Github)\RabbitDetect\label\PixelLabelData_2\';
        FileData ='label\gTruth_Pixel_2.mat';
        [imds,pxds]  = Change_gTruthPath_Seg(SourceData,LabelData,FileData);
end
%% readme

% DataSet : Rabbit_myself_608.zip , Rabbit_myself_416.zip
% Label Data : label/Rabbit_myself_608.mat
% Model : models/Modeldownload
% Json Label input : src_input/Jsoninput.m
% XML Label input : src_input/XMLinput.m
% Algorithm : src_main\~~~

% ====================================================
% Object Detection algorithm
% FasterRCNN: SP_FasterRCNN.m
% SSD:        SP_SSD.m
% YOLOv2:     SP_YOLOv2.m
% YOLOv3:     SP_YOLOv3.m
% YOLOv4:     SP_YOLOv4.m
% ====================================================

% ====================================================
% Semantic Segmentation algorithm
% DeepLabv3+: SP_DeepLabv3.m
% ====================================================

% ====================================================
% instance Segmentation algorithm
% MaskRCNN:  SP_MaskRCNN.m(not yet)
% ====================================================





