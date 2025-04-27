import cv2
import os

def save_images(input_path, output_path):
    # Read the input image
    original_image = cv2.imread(input_path, cv2.IMREAD_COLOR)

    # Convert the image to grayscale
    grayscale_image = cv2.cvtColor(original_image, cv2.COLOR_BGR2GRAY)

    # Binarize the grayscale image using a threshold (adjust the threshold as needed)
    _, binarized_image = cv2.threshold(grayscale_image, 128, 255, cv2.THRESH_BINARY)

    # Save the original, grayscale, and binarized images
    # cv2.imwrite(output_path + '/original_image.jpg', original_image)
    # cv2.imwrite(output_path + '/grayscale_image.jpg', grayscale_image)
    cv2.imwrite(output_path, grayscale_image)

if __name__ == "__main__":
    input_dir = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/images/"
    output_dir = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/gray/"
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for file in os.listdir(input_dir):

        save_images(input_dir + file, output_dir + file)
