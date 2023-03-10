%% Json Image Segmetation Label File Read
% Fred liu 2022.7.11
% Simple Cdoe For Label Transfer 

%% Load Json and Decode to MATLAB Label
filename = " ";
strData = fileread(filename);
DecodeData = jsondecode(strData);

imgPath = DecodeData.imagePath;
FilePath = " ";
FilePath = [FilePath,'\',imgPath];
img = imread(FilePath);
Points = DecodeData.shapes(1).points;
Points2 = DecodeData.shapes(2).points;

BW = poly2mask(Points(:,1),Points(:,2),DecodeData.imageHeight,DecodeData.imagewidth);
BW2 = poly2mask(Points2(:,1),Points2(:,2),DecodeData.imageHeight,DecodeData.imagewidth);
BW3 = BW + BW2;
