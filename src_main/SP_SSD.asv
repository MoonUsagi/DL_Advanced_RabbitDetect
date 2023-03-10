%% SP_SSD
% Fred liu 2022.2.16
% 2022.5.16 updata Augmentation function using MATLAB 2022a version
% 2023.03.08 update ssdObjectDetector
% SSD Demno for RabbitData

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

%%  Build Network

basenet = resnet50;
classNames = "rabbit";
anchorBoxes = {[30 60;60 30;50 50;100 100], ...
               [40 70;70 40;60 60;120 120], ...
               [50 80;80 60;70 70;140 140]};
featureExtractionLayers = ["activation_11_relu" "activation_22_relu" "activation_40_relu"];
basenet = layerGraph(basenet);
detector = ssdObjectDetector(basenet,classNames,anchorBoxes,DetectionNetworkSource=featureExtractionLayers);


%% Preprocess Training Data
% 流程前處理 資料Size校正
preprocessedTrainingData = transform(augmentedTrainingData,@(data)SSDpreprocessData(data,inputSize));

data = read(preprocessedTrainingData);

I = data{1};
bbox = data{2};
annotatedImage = insertShape(I,'Rectangle',bbox);
annotatedImage = imresize(annotatedImage,2);
figure
imshow(annotatedImage)

%% Train Options
% 資料參數
options = trainingOptions('sgdm', ...
        'MiniBatchSize', 16, ....
        'InitialLearnRate',1e-1, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropPeriod', 30, ...
        'LearnRateDropFactor', 0.8, ...
        'MaxEpochs', 50, ...
        'VerboseFrequency', 50, ...        
        'CheckpointPath', tempdir, ...
        'Shuffle','every-epoch');

%% Train
SSDdetector = trainSSDObjectDetector(preprocessedTrainingData,detector,options);

%% Test Single Image

data = read(testData);
I = data{1,1};
I = imresize(I,inputSize(1:2));
[bboxes,scores] = detect(SSDdetector,I, 'Threshold', 0.5);

I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)

%% Test Dataset
preprocessedTestData = transform(testData,@(data)SSDpreprocessData(data,inputSize));
detectionResults = detect(SSDdetector, preprocessedTestData, 'Threshold', 0.4);
[ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);

figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f',ap))

%% Supporting Functions
% 輔助函式

function B = augmentData(A)
% Apply random horizontal flipping, and random X/Y scaling. Boxes that get
% scaled outside the bounds are clipped if the overlap is above 0.25. Also,
% jitter image color.

B = cell(size(A));

I = A{1};
sz = size(I);
if numel(sz)==3 && sz(3) == 3
    I = jitterColorHSV(I,...
        'Contrast',0.2,...
        'Hue',0,...
        'Saturation',0.1,...
        'Brightness',0.2);
end

% Randomly flip and scale image.
tform = randomAffine2d('XReflection',true,'Scale',[1 1.1]);
rout = affineOutputView(sz,tform,'BoundsStyle','CenterOutput');
B{1} = imwarp(I,tform,'OutputView',rout);

% Sanitize box data, if needed.
A{2} = helperSanitizeBoxes(A{2}, sz);

% Apply same transform to boxes.
[B{2},indices] = bboxwarp(A{2},tform,rout,'OverlapThreshold',0.25);
B{3} = A{3}(indices);

% Return original data only when all boxes are removed by warping.
if isempty(indices)
    B = A;
end
end


function data = SSDpreprocessData(data,targetSize)
% Resize image and bounding boxes to the targetSize.
sz = size(data{1},[1 2]);
scale = targetSize(1:2)./sz;
data{1} = imresize(data{1},targetSize(1:2));

% Sanitize box data, if needed.
data{2} = helperSanitizeBoxes(data{2},sz);

% Resize boxes to new image size.
data{2} = bboxresize(data{2},scale);
end

function boxes = helperSanitizeBoxes(boxes, ~)
persistent hasInvalidBoxes
valid = all(boxes > 0, 2);
if any(valid)
    if ~all(valid) && isempty(hasInvalidBoxes)
        % Issue one-time warning about removing invalid boxes.
        hasInvalidBoxes = true;
        warning('Removing ground truth bouding box data with values <= 0.')
    end
    boxes = boxes(valid,:);
end
end

