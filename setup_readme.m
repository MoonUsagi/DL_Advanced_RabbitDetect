%% ALL Setup
% Fred liu 2022.3.1

%% Setup
addpath('src_main');
addpath('src_input');
addpath('models');
addpath('gen_code');

%% Load gTruth and change path
NewPath = 'D:\Fred\MATLAB_Library(Github)\RabbitDetect\Rabbit_myself_608';
Change_gTruthPath(NewPath)

%% readme
% DataSet : Rabbit_myself_608
% Label Data : src_input/RabbitTrain_Data.mat
% Model : models/...
% Json Label input : src_input/Jsoninput.m
% XML Label input : src_input/XMLinput.m
% ====================================================
% FasterRCNN : SP_FasterRCNN
