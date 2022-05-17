function predictions = extractPredictions(YPredictions, anchorBoxMask)
%#codegen

%   Copyright 2020-2021 The MathWorks, Inc.

numPredictionHeads = size(YPredictions, 1);
predictions = cell(numPredictionHeads,6);
for ii = 1:numPredictionHeads
    % Get the required info on feature size.
    numChannelsPred = size(YPredictions{ii},3);
    numAnchors = size(anchorBoxMask{ii},2);
    numPredElemsPerAnchors = numChannelsPred/numAnchors;
    allIds = (1:numChannelsPred);
    
    stride = numPredElemsPerAnchors;
    endIdx = numChannelsPred;
    
    YPredictionsData = extractdata(YPredictions{ii});
    
    % X positions.
    startIdx = 1;
    predictions{ii,2} = YPredictionsData(:,:,startIdx:stride:endIdx,:);
    xIds = startIdx:stride:endIdx;
    
    % Y positions.
    startIdx = 2;
    predictions{ii,3} = YPredictionsData(:,:,startIdx:stride:endIdx,:);
    yIds = startIdx:stride:endIdx;
    
    % Width.
    startIdx = 3;
    predictions{ii,4} = YPredictionsData(:,:,startIdx:stride:endIdx,:);
    wIds = startIdx:stride:endIdx;
    
    % Height.
    startIdx = 4;
    predictions{ii,5} = YPredictionsData(:,:,startIdx:stride:endIdx,:);
    hIds = startIdx:stride:endIdx;
    
    % Confidence scores.
    startIdx = 5;
    predictions{ii,1} = YPredictionsData(:,:,startIdx:stride:endIdx,:);
    confIds = startIdx:stride:endIdx;
    
    % Accumulate all the non-class indexes
    nonClassIds = [xIds yIds wIds hIds confIds];
    
    % Class probabilities.
    % Get the indexes which do not belong to the nonClassIds
    classIdx = setdiff(allIds, nonClassIds, 'stable');
    predictions{ii,6} = YPredictionsData(:,:,classIdx,:);
end
end