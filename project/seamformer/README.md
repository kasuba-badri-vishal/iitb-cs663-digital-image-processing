# Seamformer 

## Description

It is a vision transformer based model that is used for text detection in manuscripts with characters with different heights. 


## Setup
1) Python  3.8.0
2) Install the requirements in the requirements.txt

By default this doesnt allow usage of GPU. Incase of need to use GPU, torch 0.10.0+113cu is needed. Install it using the below command. For older GPUs cuda 11.2 or 10.x might be enough

```
pip install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
```

## Pre Trained weights

There are two checkpoints available. BKS and Indic. 

```
pip install gdown 
gdown 1O_CtJToNUPrQzbMN38FsOJwEdxCDXqHh
gdown 1nro1UjYRSlMIaYUwkMTrfZzrE_kz0QDF
```

## Inferences

Inference can be performed by using either a json file storing paths of images or by image folders

Case I : Via JSON File
```
python3 inference.py --exp_name v0 --input_image_json test.json --output_image_folder ./output --model_weights_path BKS.pt --input_json
```

Case I : Via Image Folder Path
```
python3 inference.py --exp_name v0 --input_image_folder images --output_image_folder output --model_weights_path BKS.pt --input_folder
```

## Training

### Data Preparation

1) Have a Dataset with images of manuscripts and bounding regions mapped to it. [Example dataset](https://drive.google.com/file/d/1bYqKGPeqZ0XpFJS6d9X8rKk078ESTUHn/view?usp=sharing)

2)  Use datapreparation.py to get binary and scribble patches from image and bounding regions. 
```
python datapreparation.py \
 --datafolder './data/' \
 --outputfolderPath './SD_patches' \
 --inputjsonPath './data/ICDARTrain/SD_DATA/SD_TRAIN/SD_TRAIN.json' \
 --binaryFolderPath './data/ICDARTrain/SD_DATA/SD_TRAIN/binaryImages'
 ```

### Training

1) Have a configuration file. Refer Sample_Exp_Confiuration.json

2) Can train either scribble generation / binarisation branch

```
python train.py --exp_json_path Sample_Exp_Configuration.json --mode train --train_binary
python train.py --exp_json_path Sample_Exp_Configuration.json --mode train --train_scribble
```
