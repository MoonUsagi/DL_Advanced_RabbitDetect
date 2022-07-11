%% GTruth
% Fred liu 2022.7.7
% Change GTruth Data Path for Segmentation RabbitData

%%
function [imds,pxds] = Change_gTruthPath_Seg(dataPath,labelPath)

FileData ='label\gTruth_Seg2.mat';
load(FileData);
%需更改兩處path，原始資料＋標記資料

% image datastore
imgfile = gTruth.DataSource.Source;
[PfPath, PfName, PfExt] = fileparts(imgfile);
ImgNewPath = strcat({dataPath},PfName,PfExt);
imds = imageDatastore(ImgNewPath);

% label datastore
Labelfile = gTruth.LabelData.PixelLabelData;
[LfPath, LfName, LfExt] = fileparts(Labelfile);
LabelNewPath = strcat({labelPath},LfName,LfExt);

labelIDs = gTruth.LabelDefinitions.PixelLabelID;
classes = gTruth.LabelDefinitions.Name;

pxds = pixelLabelDatastore(LabelNewPath,classes,labelIDs);

end