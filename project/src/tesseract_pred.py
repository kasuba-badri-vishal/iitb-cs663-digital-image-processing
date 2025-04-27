import os
import pytesseract
import cv2
import argparse



def get_tesseract_predictions(args):
    
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)
    
    for image in os.listdir(args.input_folder):
        img = cv2.imread(os.path.join(args.input_folder,image))
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        img = cv2.threshold(img, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
        text = pytesseract.image_to_string(img, lang = args.language)
        with open(os.path.join(args.output_folder, image.split('.')[0] + '.txt'), 'w') as f:
            f.write(text)
        
        hocr = pytesseract.image_to_pdf_or_hocr(img, lang = args.language, extension = 'hocr')
        
        with open(os.path.join(args.output_folder, image.split('.')[0] + '.hocr'), 'wb') as f:
            f.write(hocr)
            

def parse_args():
    parser = argparse.ArgumentParser(description="Preprocessing image", formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument("-i", "--input_folder", type=str, default=None, help="path to the input img folder")
    parser.add_argument("-o", "--output_folder", type=str, default="OUTPUT", help="path to the output img directory")
    parser.add_argument("-l", "--language", type=str, default="tam", help="language to OCR")

    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = parse_args()
    get_tesseract_predictions(args)