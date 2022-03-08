%% Resize Rabbit Dataset
% Fred liu 2022.2.15
% Resize image size for rabbit dataset 

%%
Path = 'D:\Fred\MATLAB_Library(Github)\SpeedTrain\Rabbit_myself_608\';
srcFiles = dir([Path,'*.jpg']);
imgInputSize = [608 608]

for i = 1 : length(srcFiles)
   
    filename = strcat(Path,srcFiles(i).name);
    im = imread(filename);
    k=imresize(im,imgInputSize);
    if i <9
        newfilename=strcat(Path,'Rabbit_00',num2str(i),'.jpg');
    elseif i >= 10
        newfilename=strcat(Path,'Rabbit_0',num2str(i),'.jpg');
    end
    imwrite(k,newfilename,'jpg');
end
