%% ALL Setup
% Fred liu 2022.3.1
% 2022.5.17 update

%% Setup
addpath('src_main');
addpath('src_input');
addpath('src_fun');
addpath('label');
addpath('models');
addpath('Img');


%% Load gTruth and change path
% 這裡更改你的資料路徑 Change your data path
NewPath = 'D:\Fred\MATLAB_Library(Github)\RabbitDetect\Rabbit_myself_608\';
T_gTruth = Change_gTruthPath(NewPath);


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
% Unet:       SP_Unet.m(not yet)
% ====================================================

% ====================================================
% instance Segmentation algorithm
% MaskRCNN:  SP_MaskRCNN.m(not yet)
% ====================================================





