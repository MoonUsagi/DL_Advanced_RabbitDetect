%% Json Label File Read
% Fred liu 2022.3.1

%% Json Read(載入Json標記資訊 & 字串正規化)
% Train
filename = 'D:\Fred\MATLAB Library(Github)\ObjectDetection\DataSet\Cottontail-Rabbits.v1-augmented-data.coco\train\_annotations.coco.json';
strData = fileread(filename);
DecodeData = jsondecode(strData);
%
idx = findgroups([DecodeData.annotations.image_id]);
T_bbox = splitapply(@(x){x},[DecodeData.annotations.bbox],idx)';
T_file = {DecodeData.images.file_name}';
% arrayfun(@(x)getfield(x,'file_name'),DecodeData.images,'UniformOutput',false);
gTruth_labeler = table(T_file,T_bbox);

% Test
filename2 = 'D:\Fred\MATLAB Library(Github)\ObjectDetection\DataSet\Cottontail-Rabbits.v1-augmented-data.coco\test\_annotations.coco.json';
strData2 = fileread(filename2);
DecodeData2 = jsondecode(strData2);
%
idx2 = findgroups([DecodeData2.annotations.image_id]);
T_bbox2 = splitapply(@(x){x},[DecodeData2.annotations.bbox],idx2)';
T_file2 = {DecodeData2.images.file_name}';
% arrayfun(@(x)getfield(x,'file_name'),DecodeData.images,'UniformOutput',false);
gTruth_labeler2 = table(T_file2,T_bbox2);

%% String Normalization(字串正規化)
PathTrain = 'D:\Fred\MATLAB Library(Github)\ObjectDetection\DataSet\Cottontail-Rabbits.v1-augmented-data.coco\train';
PathTrain2 = [PathTrain,'\'];
TrainImg = strcat(PathTrain2,string(gTruth_labeler.T_file));

PathTest = 'D:\Fred\MATLAB Library(Github)\ObjectDetection\DataSet\Cottontail-Rabbits.v1-augmented-data.coco\test';
PathTest2 = [PathTest,'\'];
TestImg = strcat(PathTest2,string(gTruth_labeler2.T_file2));


