function tiledAnchors = generateTiledAnchors(YPredCell,anchorBoxes,...
    anchorBoxMask,anchorIndex)
% Generate tiled anchor offset for converting the predictions from the YOLO
% v3 grid cell coordinates to bounding box coordinates
%#codegen

%   Copyright 2020-2021 The MathWorks, Inc.

numPredictionHeads = size(YPredCell,1);
tiledAnchors = cell(numPredictionHeads, size(anchorIndex, 2));
for i = 1:numPredictionHeads
    anchors = anchorBoxes(anchorBoxMask{i}, :);
    [h,w,~,n] = size(YPredCell{i,1});
    [tiledAnchors{i,2},tiledAnchors{i,1}] = ndgrid(0:h-1,0:w-1,...
        1:size(anchors,1),1:n);
    [~,~,tiledAnchors{i,3}] = ndgrid(0:h-1,0:w-1,anchors(:,2),1:n);
    [~,~,tiledAnchors{i,4}] = ndgrid(0:h-1,0:w-1,anchors(:,1),1:n);
end
end
