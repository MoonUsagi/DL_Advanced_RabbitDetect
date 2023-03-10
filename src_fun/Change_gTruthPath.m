%% GTruth
% Fred liu 2022.4.27
% Change GTruth Data Path for RabbitData

%% 
function T_gTruth = Change_gTruthPath_Seg(NewPath)

FileData ='label\Rabbit_myself_608.mat';
load(FileData)

imgfile = T_gTruth.imageFilename;
[fPath, fName, fExt] = fileparts(imgfile);

C = {NewPath,fName,fExt};
Newpath = strcat({NewPath},fName,fExt);
T_gTruth.imageFilename = Newpath;

end