%% SP_FasterRCNN
% Fred liu 2022.2.15
% FasterRCNN Demno for RabbitData

%% DataSet Split
% 切割資料
rng(0)
shuffledIndices = randperm(height(T_gTruth));
idx = floor(0.8 * height(T_gTruth));

trainingIdx = 1:idx;
trainingDataTbl = T_gTruth(shuffledIndices(trainingIdx),:);

testIdx = trainingIdx(end)+1 : length(shuffledIndices);
testDataTbl = T_gTruth(shuffledIndices(testIdx),:);
%% Build Datasotre
% 建立資料庫
% Train
imdsTrain = imageDatastore(trainingDataTbl.imageFilename);
bldsTrain = boxLabelDatastore(trainingDataTbl(:,2:end));

% Test
imdsTest = imageDatastore(testDataTbl.imageFilename);
bldsTest = boxLabelDatastore(testDataTbl(:,2:end));

%% Combine Datastore
% 整併資料庫
trainingData = combine(imdsTrain,bldsTrain);
testData = combine(imdsTest,bldsTest);

%% Data Augmentation
% 資料增量
augmentedTrainingData = transform(trainingData,@augmentData);

augmentedData = cell(4,1);
for k = 1:4
    data = read(augmentedTrainingData);
    augmentedData{k} = insertShape(data{1},'Rectangle',data{2});
    reset(augmentedTrainingData);
end
figure
montage(augmentedData,'BorderSize',10)

%% Build Network
% 建置網路架構 FasterRCNN + mobilenetv2
inputSize  = [224 224 3];
numClasses = 1;
network = 'mobilenetv2';
featureLayer = 'out_relu';
anchorBoxes = [64,64; 128,128; 192,192];
lgraph = fasterRCNNLayers(inputSize ,numClasses,anchorBoxes, ...
                          network,featureLayer);
%analyzeNetwork(lgraph)

%% Preprocess Training Data
% 流程前處理 資料Size校正
trainingData = transform(augmentedTrainingData,@(data)preprocessData(data,inputSize));
data = read(trainingData);

I = data{1};
bbox = data{2};
annotatedImage = insertShape(I,'Rectangle',bbox);
annotatedImage = imresize(annotatedImage,2);
figure
imshow(annotatedImage)

%% Train Options
% 資料參數
options = trainingOptions('sgdm',...
    'MaxEpochs',50,...
    'MiniBatchSize',32,...
    'InitialLearnRate',0.001,...
    'CheckpointPath',tempdir,...
    'ValidationData',testData);
%% Training
[detector, info] = trainFasterRCNNObjectDetector(trainingData,lgraph,options, ...
        'NegativeOverlapRange',[0 0.3], ...
        'PositiveOverlapRange',[0.6 1]);

%% Test Single Image
% 測試單張影像
data = read(testData);
I = data{1,1};
I = imresize(I,inputSize(1:2));
[bboxes,scores] = detect(detector,I,'Threshold',0.3);

I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)

%% Test Dataset
% 測試完整資料集
preprocessedTestData = transform(testData,@(data)preprocessData(data,inputSize));
detectionResults = detect(detector, preprocessedTestData, 'Threshold', 0.4);
[ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);

figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f',ap))
%% Supporting Functions
% 輔助函式

function data = augmentData(data)
% Randomly flip images and bounding boxes horizontally.
tform = randomAffine2d('XReflection',true);
sz = size(data{1});
rout = affineOutputView(sz,tform);
data{1} = imwarp(data{1},tform,'OutputView',rout);

% Sanitize box data, if needed.
data{2} = helperSanitizeBoxes(data{2}, sz);

% Warp boxes.
data{2} = bboxwarp(data{2},tform,rout);
end


function data = preprocessData(data,targetSize)
% Resize image and bounding boxes to targetSize.
sz = size(data{1},[1 2]);
scale = targetSize(1:2)./sz;
data{1} = imresize(data{1},targetSize(1:2));

% Sanitize box data, if needed.
data{2} = helperSanitizeBoxes(data{2}, sz);

% Resize boxes.
data{2} = bboxresize(data{2},scale);
end


function boxes = helperSanitizeBoxes(boxes, imageSize)
persistent hasInvalidBoxes
valid = all(boxes > 0, 2);
if any(valid)
    if ~all(valid) && isempty(hasInvalidBoxes)
        % Issue one-time warning about removing invalid boxes.
        hasInvalidBoxes = true;
        warning('Removing ground truth bouding box data with values <= 0.')
    end
    boxes = boxes(valid,:);
    boxes = roundFractionalBoxes(boxes, imageSize);
end

end

function boxes = roundFractionalBoxes(boxes, imageSize)
% If fractional data is present, issue one-time warning and round data and
% clip to image size.
persistent hasIssuedWarning

allPixelCoordinates = isequal(floor(boxes), boxes);
if ~allPixelCoordinates
    
    if isempty(hasIssuedWarning)
        hasIssuedWarning = true;
        warning('Rounding ground truth bounding box data to integer values.')
    end
    
    boxes = round(boxes);
    boxes(:,1:2) = max(boxes(:,1:2), 1); 
    boxes(:,3:4) = min(boxes(:,3:4), imageSize([2 1]));
end
end