%% XML Label File Read 
% Fred liu 2022.3.1

%%  Load XML File & String Normalization(載入XML標記資訊 & 字串正規化)
ds = fileDatastore('Train_Dataset\Train_Labels','ReadFcn',@readFcn);
T_bbox= readall(ds);
ds2 = fileDatastore('Train_Dataset\Train_Labels','ReadFcn',@readFcn2);
T_file= readall(ds2);

gTruth_labeler = table(T_file,T_bbox);

% Test==============================================
dsTest = fileDatastore('Test_Dataset\Test_Labels','ReadFcn',@readFcn);
dsTest_bbox= readall(dsTest);
dsTest2 = fileDatastore('Test_Dataset\Test_Labels','ReadFcn',@readFcn2);
dsTest_file= readall(dsTest2);

Test_gTruth_labeler = table(dsTest_file,dsTest_bbox);