# RabbitDetect 
Bulit on 2022/02  by Fred Liu<br>
[Youtube Link](https://www.youtube.com/channel/UCnUuSyqkkXaFy57qL7aURAA)<br>
<br>
需要工具箱: MATLAB,Deeplearning , Image Processing, Computer Vision, Parallel Computing<br>
需要支援包: YOLOv3,YOLOv4 Package & pretrain modle Package
<br>
首先請閱讀setup_readme (First to read setup_readme )<br>
<br>
![image](https://github.com/MoonUsagi/RabbitDetect/blob/main/rabbitLog_label.jpg)
---------------------------------------






基於MATLAB 物件偵測於rabbit dataset   
(MATLAB Object Detection with rabbit dataset)
---------------------------------------
- - -

1.資料請下載(data download):Rabbit_myself_416.zip or Rabbit_myself_608.zip
2.被訓練過模型(model):model\Modeldownload  
3.演算法(algorithm):FasterRCNN,SSD,YLOLv2,YOLOv3,YOLOv4  
4.標記檔案(label data):Rabbit_myself_608.mat,Change_gTruthPath
6.src_input: 各種labele的匯入api (any label input api)  
  
  
  
  
- - -
使用流程(Use the process):

標記影像：可使用image labeler標記　or 載入Rabbit_myselft_608標記資料(可使用Change_gTruthPath.m)    
(Label Image:use image labeler to label or download "Rabbit_myselft_608" label dataset.  
It can use "Change_gTruthPath.m" to change path.)

模型：可以自行透過演算法訓練，也使用Pre-trained進行測試  
(Model:you can train through the algorithm by yourself, and also use Pre-trained for testing)
  
  
  
  
- - -
正在更新內容(updating content)
- - -
基於MATLAB 語意分割於rabbit dataset  
(MATLAB semantic segmentation with rabbit dataset)
---------------------------------------
1.資料請下載(data download):Rabbit_myself_416 or Rabbit_myself_608  
2.模型(model):future  
3.演算法(algorithm):SP_DeepLabv3
  
  
  
  
- - -
未來更新(future update)
  
1.instance segmentation  
2.text detection