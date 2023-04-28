%%  Instance Segmantic Labeler Transfer
% Fred liu 2023.4.28
% 此範例介紹如何對單張的影像進行標記格式的轉換
% This example demonstrates how to convert the annotation format for a single image.
% 將Polygon的標記格式，轉成可以讓Instance Segmantic所需的mask與bboxes
% Converting the Polygon annotation format into masks and bboxes required for Instance Segmentation.
%% Use the gatherLabelData property and store the output.
% 從標記資料中拿出Polygon資訊
load("label/gTruth_Instance.mat")
out = gatherLabelData(gTruth,[labelType.Polygon],'GroupLabelData','LabelType');

% Show the contents of the table.
out{1}.PolygonData

%%  Preallocate a mask stack for instance segmentation
polygons = out{1}.PolygonData{1}(:,1);
numPolygons = size(polygons,1);

imageSize = [608 608]; % size(boats_im)
maskStack = false([imageSize(1:2) numPolygons]);

%% Convert polygons to instance masks
for i = 1:numPolygons
    maskStack(:,:,i) = poly2mask(polygons{i}(:,1), ...
                       polygons{i}(:,2),imageSize(1),imageSize(2));
end

figure,imshow(maskStack)
%% Polygons to Boundingbox
x1 = polygons{1}(:,1);
y1 = polygons{1}(:,2);
poyin = polyshape({x1},{y1});
[xlim,ylim] = boundingbox(poyin);

bboxes = round([xlim(1,1),ylim(1,1),xlim(1,2)-xlim(1,1),ylim(1,2)-ylim(1,1)]);
%% Show Image
% Read Image (請更換資料路徑或使用自己的資料|Change data path or using self data
img = imread(gTruth.DataSource.Source{1});
% Load Label
label = gTruth.LabelData.Properties.VariableNames;

imOverlay = insertObjectMask(img,maskStack);
figure,imshow(imOverlay)
showShape("rectangle",bboxes,Label=label,Color="red");











