%% GTruth
% Fred liu 2022.7.7
% Change GTruth Data Path for Segmentation RabbitData

%%
function [imds,pxds] = Change_gTruthPath_Seg(dataPath,labelPath)

FileData ='label\gTruth_Seg2.mat';
load(FileData);
%需更改兩處path，原始資料＋標記資料

imds = datastore(dataPath);
lbds = datastore(labelPath);

labelIDs = gTruth.LabelDefinitions.PixelLabelID;
classes = gTruth.LabelDefinitions.Name;

pxds = pixelLabelDatastore(lbds.Files,classes,labelIDs);

end