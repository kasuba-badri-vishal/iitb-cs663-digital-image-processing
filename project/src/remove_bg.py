import cv2
import numpy as np
import os

def keep_dark_pixels(image_path, output_path, threshold=50):
    # Read the image
    img = cv2.imread(image_path)

    # Convert the image to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Create a binary mask for pixels darker than the threshold
    _, mask = cv2.threshold(gray, threshold, 255, cv2.THRESH_BINARY)

    # Create an all-white image
    result = np.ones_like(img) * 255

    # Copy only the dark pixels from the original image to the result image
    result[mask == 0] = img[mask == 0]

    # Save the result
    cv2.imwrite(output_path, result)

if __name__ == "__main__":
    
    input_dir = '/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/images/'
    output_dir = '/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/bg_removed/'
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for file in os.listdir(input_dir):
    
        threshold_value = 100  # Adjust this threshold value as needed

        keep_dark_pixels(input_dir + file, output_dir + file, threshold_value)



    # keep_black_color(input_image_path, output_image_path)
