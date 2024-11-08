%% Train MaskRCNN
% 因為資料量需求較大，因此請大家直接參考以下範例
% Due to the large amount of data required, please refer to the following examples directly

% Doc:Perform Instance Segmentation Using Mask R-CNN

%% Show Image
num = 15;
img = readimage(imds,num);
pixelImg = imread(pxds.Files{num});
pixelImg

figure,imshow(img)

%% 影像與標記資料預檢視
%C = readimage(pxds,5);
pixelImg = imread(pxds.Files{num});
%pixelImg = readimage(pxds,num);

cmap = camvidColorMap;
layImg = labeloverlay(img,pixelImg,'ColorMap',cmap);
figure,imshow(layImg)
pixelLabelColorbar(cmap,[pxds.ClassNames;'other']);

%%
overlayedImage = insertObjectMask(img,masks);
figure,imshow(overlayedImage)
boxes = getBoxFromMask(masks);
showShape("rectangle",boxes,Label="Scores: "+num2str(scores),LabelOpacity=0.2)

%% Bulid Datastore



%%
