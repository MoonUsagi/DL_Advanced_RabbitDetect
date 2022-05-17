function [bboxes,scores,labelsIndex] = generateYOLOv3DetectionsForCodegen(detectionsCell,...
    confidenceThreshold,overlapThreshold,imageSize,classes)
% Apply following post processing steps to filter the detections:
% * Filter detections based on threshold.
% * Convert bboxes from spatial to pixel dimension.
%#codegen

%   Copyright 2020-2021 The MathWorks, Inc.

% Combine the prediction from different heads.
numCells = size(detectionsCell, 1);
detectionSize = zeros(1, numCells);
for iCell = 1:numCells
    detectionSize(iCell) = numel(detectionsCell{iCell,1});
end
detectionSizeIndx = [0 cumsum(detectionSize)];
detections = zeros(detectionSizeIndx(end), 6,'single');
for iCell = 1:numCells
    for iCol = 1:5
        detections(detectionSizeIndx(iCell)+1:detectionSizeIndx(iCell+1),iCol) = reshapePredictions(detectionsCell{iCell,iCol});
    end
    detections(detectionSizeIndx(iCell)+1:detectionSizeIndx(iCell+1),6) = reshapeClasses(detectionsCell{iCell,6},numel(classes));
end

% Keep detections whose objectness score is greater than thresh.
confidenceTmp = detections(:,1);
detections = detections(confidenceTmp>confidenceThreshold,:);

% Initialize bboxes,scores,labels.
bboxes = zeros(0,'single');
scores = zeros(0,'single');
labelsIndex = zeros(0,'single');

% Filter the classes based on (confidence score * class probability).
if ~isempty(detections)
    [classProbs, classIdx] = max(detections(:,6:end),[],2);
    detections(:,1) = detections(:,1).*classProbs;
    detections(:,6) = classIdx;
    detections = detections(detections(:,1)>=confidenceThreshold,:);
    if ~isempty(detections)
        
        bboxes = detections(:,2:5);       
        scale = [imageSize(2) imageSize(1) imageSize(2) imageSize(1)];
        bboxes = bsxfun(@times, bboxes, scale);
        
        % Convert x and y position of detections from center to top-left.
        % Resize boxes to image size.
        bboxes = convertCenterToTopLeft(bboxes);
        
        scores = detections(:,1);
        labelsIndex = detections(:,6);
        
        % Apply suppression to the detections to filter out multiple
        % overlapping detections.
        if ~isempty(scores)
            [bboxes,scores,labelsIndex] = selectStrongestBboxMulticlass(bboxes,scores,labelsIndex ,...
                'RatioType','Union','OverlapThreshold',overlapThreshold);
        end
    end
end
end

% Convert x and y position of detections from center to top-left.
function bboxes = convertCenterToTopLeft(bboxes)
bboxes(:,1) = bboxes(:,1)- bboxes(:,3)/2 + 0.5;
bboxes(:,2) = bboxes(:,2)- bboxes(:,4)/2 + 0.5;
bboxes = floor(bboxes);
bboxes(bboxes<1) = 1;
end

function x = reshapePredictions(pred)
[h,w,c,n] = size(pred);
x = reshape(pred,h*w*c,1,n);
end

function x = reshapeClasses(pred,numclasses)
[h,w,c,n] = size(pred);
numanchors = c/numclasses;
x = reshape(pred,h*w,numclasses,numanchors,n);
x = permute(x,[1,3,2,4]);
[h,w,c,n] = size(x);
x = reshape(x,h*w,c,n);
end