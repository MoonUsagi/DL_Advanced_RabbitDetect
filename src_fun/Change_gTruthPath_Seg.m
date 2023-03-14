%% GTruth
% Fred liu 2022.7.7
% Change GTruth Data Path for Segmentation RabbitData

%%
function [imds,pxds] = Change_gTruthPath_Seg(dataPath,labelPath,FileData)


load(FileData);
%需更改兩處path，原始資料＋標記資料

% image datastore
imgfile = gTruth_Pixel.DataSource.Source;
[PfPath, PfName, PfExt] = fileparts(imgfile);
ImgNewPath = strcat({dataPath},PfName,PfExt);
imds = imageDatastore(ImgNewPath);

% label datastore
Labelfile = gTruth_Pixel.LabelData.PixelLabelData;
[LfPath, LfName, LfExt] = fileparts(Labelfile);
LabelNewPath = strcat({labelPath},LfName,LfExt);

labelIDs = gTruth_Pixel.LabelDefinitions.PixelLabelID;
classes = gTruth_Pixel.LabelDefinitions.Name;

pxds = pixelLabelDatastore(LabelNewPath,classes,labelIDs);

end