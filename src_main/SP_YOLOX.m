%% SP_YOLOX
% Fred liu 2023.12.07
% YOLOX Demno for RabbitData

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

%% Build Network(Define YOLOX Object Detector)
%(定義YOLOX物件偵測演算法)
type = 1;

classNames = {'rabbit',};
inputSize = [800 800 3];
switch type
    case 1
        detectorIn = yoloxObjectDetector("tiny-coco",classNames,InputSize=inputSize);
    case 2
        detectorIn = yoloxObjectDetector("small-coco",classNames,InputSize=inputSize);
    case 3
        detectorIn = yoloxObjectDetector("uninitialized",classNames,InputSize=inputSize);
end

%% Train Options
% 資料參數
options = trainingOptions("sgdm", ...
    InitialLearnRate=5e-4, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.99, ...
    LearnRateDropPeriod=1, ...   
    MiniBatchSize=20, ...
    MaxEpochs=100, ...
    BatchNormalizationStatistics="moving", ...
    ExecutionEnvironment="auto", ...
    Shuffle="every-epoch", ...
    VerboseFrequency=25, ...
    ValidationFrequency=100, ...
    ValidationData=testData, ...
    ResetInputNormalization=false, ...
    OutputNetwork="best-validation-loss", ...
    GradientThreshold=30, ...
    L2Regularization=5e-4);
%% Train
% 訓練
[detector,info] = trainYOLOXObjectDetector(augmentedTrainingData,detectorIn,options,"FreezeSubNetwork","none");

%% Test Single Image
% 測試單張影像
data = read(testData);
I = data{1,1};
I = imresize(I,inputSize(1:2));
[bboxes, scores, labels] = detect(detector,I,'Threshold', 0.1);

I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure,imshow(I)

%% Test Dataset
detectionResults = detect(detector,testData);

% Evaluate the object detector using Average Precision metric.
[ap,recall,precision] = evaluateDetectionPrecision(detectionResults,testData);

figure
plot(recall,precision)
xlabel("Recall")
ylabel("Precision")
grid on
title(sprintf("Average Precision = %.2f",ap))


%% Supporting Functions
% 輔助函式

function data = augmentData(A)
% Apply random horizontal flipping, and random X/Y scaling. Boxes that get
% scaled outside the bounds are clipped if the overlap is above 0.25. Also,
% jitter image color.

data = cell(size(A));
for ii = 1:size(A,1)
    I = A{ii,1};
    bboxes = A{ii,2};
    labels = A{ii,3};
    sz = size(I);

    if numel(sz) == 3 && sz(3) == 3
        I = jitterColorHSV(I,...
            contrast=0.0,...
            Hue=0.1,...
            Saturation=0.2,...
            Brightness=0.2);
    end
    
    % Randomly flip image.
    tform = randomAffine2d(XReflection=true,Scale=[1 1.1]);
    rout = affineOutputView(sz,tform,BoundsStyle="centerOutput");
    I = imwarp(I,tform,OutputView=rout);
    
    % Apply same transform to boxes.
    [bboxes,indices] = bboxwarp(bboxes,tform,rout,OverlapThreshold=0.25);
    labels = labels(indices);
    
    % Return original data only when all boxes are removed by warping.
    if isempty(indices)
        data(ii,:) = A(ii,:);
    else
        data(ii,:) = {I,bboxes,labels};
    end
end
end

function data = preprocessData(data,targetSize)
% Resize the images and scale the pixels to between 0 and 1. Also scale the
% corresponding bounding boxes.

for ii = 1:size(data,1)     
    I = data{ii,1};
    imgSize = size(I);
    
    bboxes = data{ii,2};

    I = im2single(imresize(I,targetSize(1:2)));
    scale = targetSize(1:2)./imgSize(1:2);
    bboxes = bboxresize(bboxes,scale);
    
    data(ii,1:2) = {I,bboxes};
end
end

