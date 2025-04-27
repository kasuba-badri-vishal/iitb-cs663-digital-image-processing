import cv2
import os

def binarize_images(input_folder, output_folder, threshold=127):
    # Ensure output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Loop through each file in the input folder
    for filename in os.listdir(input_folder):
        input_path = os.path.join(input_folder, filename)

        # Read the image
        img = cv2.imread(input_path, cv2.IMREAD_GRAYSCALE)

        # Binarize the image using a specified threshold
        _, binary_image = cv2.threshold(img, threshold, 255, cv2.THRESH_BINARY)

        # Save the binarized image to the output folder
        output_path = os.path.join(output_folder, f"{filename}")
        cv2.imwrite(output_path, binary_image)

if __name__ == "__main__":
    input_folder_path = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/images/"
    output_folder_path = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/binarized"
    threshold_value = 127  # Adjust this threshold value as needed

    binarize_images(input_folder_path, output_folder_path, threshold_value)
