import cv2
import argparse
import os
from tqdm import tqdm
from pdf2image import convert_from_path

DPI = 300
JPEGOPT={
    "quality"     : 100,
    "progressive" : True,
    "optimize"    : False
}

def simple_counter_generator(prefix="", suffix=""):
    i=0
    while True:
        i+=1
        yield 'p'

def extract_manuscript(file_path,output_folder):
    img_name=os.path.basename(file_path).split('.')[0]
    img=cv2.imread(file_path)
    gray=cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    blur=cv2.GaussianBlur(gray,(17,17),100)
    kernel=cv2.getStructuringElement(cv2.MORPH_RECT,(10,10))
    thres_inv= cv2.adaptiveThreshold(blur, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,cv2.THRESH_BINARY_INV, 73, 2)
    thresh=cv2.threshold(thres_inv,50,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)[1] # inverted image
    dilate=cv2.dilate(thresh,kernel,iterations=1)
    cnts=cv2.findContours(dilate,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cnts=cnts[0] if len(cnts)==2 else cnts[1]
    cnts=sorted(cnts,key=lambda x:cv2.boundingRect(x)[1])
    xl,yl,xh,yh=0,0,0,0
    yp,xp=img.shape[:2]
    manuscripts=[]
    for c in cnts:
        x,y,w,h=cv2.boundingRect(c)
        if h>yp/6:  
            manuscripts.append([x,y,w,h])
            # cv2.rectangle(img,(x,y),(x+w,y+h),(0,255,0),5)
    if len(manuscripts)>=2:
        itr=2
    else:
        itr=len(manuscripts)
    
    for i in range(itr):
        x,y,w,h=manuscripts[i]
        cv2.imwrite(os.path.join(output_folder,f'{img_name}_{str(i+1)}.jpg'),img[y:y+h,x:x+w])
        

def main(args):
    op_folder = args.output_folder_name
    output_directory = os.path.join(op_folder, 'output')
    images_folder = os.path.join(op_folder, "Images")

    if not os.path.exists(op_folder):
        os.makedirs(op_folder)
        os.makedirs(output_directory)
        os.makedirs(images_folder)

    if args.input_type=='pdf':
        
        if not os.path.exists(op_folder):
            os.makedirs(op_folder)
            os.makedirs(output_directory)
            os.makedirs(images_folder)

        output_file=simple_counter_generator("page",".jpg")
        if len(os.listdir(images_folder))==0:
            print('Converting PDF to Images')  
            convert_from_path(args.input_file ,output_folder=images_folder, dpi=DPI,fmt='jpeg',jpegopt=JPEGOPT,output_file=output_file)
            print("Images Creation Done.")

        img_files=os.listdir(images_folder)
        curr_page=0
        for img in tqdm(img_files):
            if(args.start_page is not None and curr_page < int(args.start_page)):
                curr_page += 1
                continue
            else:
                curr_page += 1
            extract_manuscript(os.path.join(images_folder,img),output_directory)
    else:
        if not os.path.exists(op_folder):
            os.makedirs(op_folder)
        extract_manuscript(args.input_file,op_folder)
    
    print('DONE')


def parse_args():
    parser = argparse.ArgumentParser(description="Preprocessing image", formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument("-i", "--input_file", type=str, default=None, help="path to the input img file")
    parser.add_argument("-o", "--output_folder_name", type=str, default="OUTPUT", help="path to the output img directory")
    parser.add_argument("-t", "--input_type", type=str, default="pdf", help="image/pdf")
    parser.add_argument("-s", "--start_page", type=int, default=None, help="start Page")

    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = parse_args()
    main(args)
