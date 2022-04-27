%% GTruth
% Fred liu 2022.4.27
% Change GTruth Data Path for RabbitData

%% 
FileData ='Rabbit_myself_608.mat';
load(FileData)

imgfile = T_gTruth.imageFilename;
[fPath, fName, fExt] = fileparts(imgfile);

NewPath = 'This is write your path';
C = {NewPath,fName,fExt};
Newpath = strcat({NewPath},fName,fExt);
T_gTruth.imageFilename = Newpath;