import cv2
import os
from tqdm import tqdm
from pytesseract import image_to_data, Output
import pandas as pd
import pytesseract
from PIL import Image, ImageDraw, ImageFont



# tesseract models for different languages
terms = {
    'hindi': 'devanagari',
    'tamil': 'tam',
    'telugu': 'tel',
}

terms_2 = {
    'hindi': 'Devanagari',
    'tamil': 'Tamil',
    'telugu': 'Telugu',
}


input_dir = '/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/processed_images/local_histogram/'
output_dir = '/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/tesseract_results/local_histogram2/'

if not os.path.exists(output_dir):
    os.makedirs(output_dir)
    os.makedirs(output_dir + 'recognition')
    os.makedirs(output_dir + 'detection')

for file in os.listdir(input_dir):

    lang = file.split('_')[0]

    img = cv2.imread(input_dir + file)
    gray=cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    d = image_to_data(gray, output_type=Output.DICT, lang=terms[lang])
    data = []
    for i in range(len(d['level'])):
        if d['level'][i]==5:
            (x, y, w, h) = (d['left'][i], d['top'][i], d['width'][i], d['height'][i])
            (x1, y1, w, h) = (int(x), int(y), int(w), int(h))
            cv2.rectangle(img, (x1, y1), (x1+w, y1+h), (0, 0, 255), 2)
            text = d['text'][i]
            data.append([text,x1, y1, x1+w, y1+h])
            
        
    height, width, _ = img.shape
    # width, height = 1024, 1024
    background_color = "white"
    img2 = Image.new("RGB", (width, height), background_color)
    draw = ImageDraw.Draw(img2)

    # try:
    font = ImageFont.truetype(f'/usr/share/fonts/truetype/lohit-{terms[lang]}/Lohit-{terms_2[lang]}.ttf', 30) 
    for text, x1, y1, x2, y2 in data:
        draw.text((x1, y1), text, font=font, fill="black")
        
    img2.save(output_dir + '/recognition/' + file)    
    cv2.imwrite(output_dir + '/detection/' + file, img)
    
    

    