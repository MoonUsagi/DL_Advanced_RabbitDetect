%% SP_YOLOv4
% Fred liu 2022.4.20
% YOLOv4 Demno for RabbitData

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

%% Build Network(Define YOLO v4 Object Detector)
%(定義YOLOv4物件偵測演算法)

% Load Pre-Train Model
model = 1;
switch model
    case 1 
        name = 'tiny-yolov4-coco';
        networkInputSize = [416 416 3];
        numAnchors = 6;
    case 2 
        name = 'csp-darknet53-coco';
        networkInputSize = [608 608 3];
        numAnchors = 9;
end
%analyzeNetwork(net)
classNames = {'rabbit',};

%% Anchors Box Design

trainingDataForEstimation = transform(trainingData, @(data)preprocessData(data, networkInputSize));
[anchors, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors)

area = anchors(:, 1).*anchors(:, 2);
[~, idx] = sort(area, 'descend');
anchors = anchors(idx, :);

if numAnchors == 9
anchorBoxes = {anchors(1:3,:)
    anchors(4:6,:)
    anchors(7:9,:)
    };

elseif numAnchors == 6
    anchorBoxes = {anchors(1:3,:)
    anchors(4:6,:)
    };
end

%% Combined network architecture(組合網路架構) 
detector = yolov4ObjectDetector(name,classNames,anchorBoxes,InputSize=networkInputSize);


%% Train Options
% 資料參數

options = trainingOptions("adam",...
    GradientDecayFactor=0.9,...
    SquaredGradientDecayFactor=0.999,...
    InitialLearnRate=0.001,...
    LearnRateSchedule="none",...
    MiniBatchSize=4,...
    L2Regularization=0.0005,...
    MaxEpochs=70,...
    BatchNormalizationStatistics="moving",...
    DispatchInBackground=true,...
    ResetInputNormalization=false,...
    Shuffle="every-epoch",...
    VerboseFrequency=20,...
    CheckpointPath=tempdir);
%   ValidationData=validationData

%% Train
% 訓練
[detector,info] = trainYOLOv4ObjectDetector(augmentedTrainingData,detector,options);

%% Test Single Image
% 測試單張影像
data = read(testData);
I = data{1,1};
I = imresize(I,inputSize(1:2));
[bboxes, scores, labels] = detect(detector,I,'Threshold', 0.1);

I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)

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

