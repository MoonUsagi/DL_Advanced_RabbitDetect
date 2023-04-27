# RabbitDetect 
Bulit on 2022/02 by Fred Liu
Major update 2022/5 
[Youtube Link](https://www.youtube.com/channel/UCnUuSyqkkXaFy57qL7aURAA)  
  
版本:MATALB: update to 2023a,minimum vervion 2022a.  
需要工具箱: Deeplearning , Image Processing, Computer Vision, Parallel Computing  
需要支援包: YOLOv3,YOLOv4 Package & pretrain modle Package  
  
首先請閱讀setup_readme.m (First to read setup_readme )

因為內建資料庫資料較少，因此在訓練一些模型上效果可能較差，範例提供整體流程，但實作請換較大型的資料庫使用。
Due to the limited amount of data in the built-in database, the performance of some models may 
be poorer during training. The example provides the overall process, but for implementation, 
it is recommended to use a larger database.
  
![image](https://github.com/MoonUsagi/RabbitDetect/blob/main/rabbitLog_label.jpg)
---------------------------------------


基於MATLAB 物件偵測於rabbit dataset   
(MATLAB Object Detection with rabbit dataset)
---------------------------------------
- - -

1.資料請下載(data download):Rabbit_myself_416.zip or Rabbit_myself_608.zip  
2.已訓練模型(Pretain_model):model\Modeldownload  
3.演算法(algorithm):src_main\FasterRCNN,SSD,YLOLv2,YOLOv3,YOLOv4  
4.標記檔案(label data):Rabbit_myself_608.mat   
5.src_input: XMLinput , Jsoninput 
  
  
  
- - -
使用流程(Use the process):
---------------------------------------
- - -
  
  
1.首先請閱讀setup_readme.m (First to read setup_readme )  

2.標記影像：可使用image labeler標記　or 載入Rabbit_myselft_608標記資料(可使用Change_gTruthPath.m)    
(Label Image:use image labeler to label or download "Rabbit_myselft_608" label dataset.  
It can use "Change_gTruthPath.m" to change path.)

3.模型：可以自行透過演算法訓練(src_main)，也使用Pre-trained進行測試(model)  
(Model:you can train through the algorithm by yourself, and also use Pre-trained for testing)
  
  
- - -
基於MATLAB 語意分割於rabbit dataset  
(MATLAB semantic segmentation with rabbit dataset)
---------------------------------------
- - -
1.資料請下載(data download):Rabbit_myself_416 or Rabbit_myself_608  
2.已訓練模型(Pretain_model):model\Modeldownload  
3.演算法(algorithm): SP_DeepLabv3  
4.標記檔案(label data):gTruth_Pixel_2.mat 
5.src_input:JsonSegInput.m,readFcn.m,readFcn2.m

- - -
基於MATLAB 實例分割於coco dataset
---------------------------------------
- - -
1.資料請下載(data download):https://github.com/cocodataset/cocoapi
Download:"2014 Train images" and "2014 Train/Val annotations" links 

2.已訓練模型(Pretain_model): NaN 
3.演算法(algorithm): SP_MaskRCNN 
4.標記檔案(label data):Using coco dataset 
5.src_input: 

