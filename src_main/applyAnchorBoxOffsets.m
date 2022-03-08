function YPredCell = applyAnchorBoxOffsets(tiledAnchors,YPredCell,...
    inputImageSize,anchorIndex)   %#codegen
% Convert the predictions from the YOLO v3 grid cell coordinates to
% bounding box coordinates

%   Copyright 2020-2021 The MathWorks, Inc.

for i = 1:size(YPredCell,1)
    [h,w,~,~] = size(YPredCell{i,1});  
    YPredCell{i,anchorIndex(1)} = (tiledAnchors{i,1}+...
        YPredCell{i,anchorIndex(1)})./w;
    YPredCell{i,anchorIndex(2)} = (tiledAnchors{i,2}+...
        YPredCell{i,anchorIndex(2)})./h;
    YPredCell{i,anchorIndex(3)} = (tiledAnchors{i,3}.*...
        YPredCell{i,anchorIndex(3)})./inputImageSize(2);
    YPredCell{i,anchorIndex(4)} = (tiledAnchors{i,4}.*...
        YPredCell{i,anchorIndex(4)})./inputImageSize(1);
end
end