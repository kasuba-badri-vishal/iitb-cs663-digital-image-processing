import cv2
import os
import numpy as np
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import mean_squared_error
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

def pca_denoising(image_path, output_path, n_components=0.95, threshold=50):
    # Load the image
    img = cv2.imread(image_path)

    # Convert the image to RGB (OpenCV uses BGR by default)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Reshape the image to a 2D array for each color channel
    flat_img = img.reshape((-1, 3))

    # Standardize the data
    standardized_img = (flat_img - np.mean(flat_img, axis=0)) / np.std(flat_img, axis=0)

    # Apply PCA separately to each color channel
    pca_red = PCA(n_components=n_components)
    denoised_red = pca_red.fit_transform(standardized_img[:, 0].reshape(-1, 1))
    denoised_red = pca_red.inverse_transform(denoised_red).reshape(-1)

    pca_green = PCA(n_components=n_components)
    denoised_green = pca_green.fit_transform(standardized_img[:, 1].reshape(-1, 1))
    denoised_green = pca_green.inverse_transform(denoised_green).reshape(-1)

    pca_blue = PCA(n_components=n_components)
    denoised_blue = pca_blue.fit_transform(standardized_img[:, 2].reshape(-1, 1))
    denoised_blue = pca_blue.inverse_transform(denoised_blue).reshape(-1)

    # Stack the denoised color channels
    denoised_img = np.stack([denoised_red, denoised_green, denoised_blue], axis=-1)

    # Reshape the denoised image back to 3D
    denoised_img = denoised_img.reshape(img.shape)

    # Convert the denoised image to grayscale
    gray_denoised = cv2.cvtColor(denoised_img.astype(np.uint8), cv2.COLOR_RGB2GRAY)

    # Thresholding: Keep only the black part
    _, black_mask = cv2.threshold(gray_denoised, threshold, 255, cv2.THRESH_BINARY_INV)
    result_img = cv2.bitwise_and(img, img, mask=black_mask)

    # Save the result image
    cv2.imwrite(output_path, cv2.cvtColor(result_img.astype(np.uint8), cv2.COLOR_RGB2BGR))

    # Plot the input and output images side by side
    plt.figure(figsize=(10, 5))

    plt.subplot(1, 2, 1)
    plt.imshow(img)
    plt.title('Input Image')

    plt.subplot(1, 2, 2)
    plt.imshow(result_img.astype(np.uint8))
    plt.title('Result Image')

    plt.show()

    # Calculate Structural Similarity Index (SSI)
    ssi_index, _ = ssim(img, result_img, full=True, multichannel=True)

    # Calculate Mean Squared Error (MSE)
    mse_value = mean_squared_error(img, result_img)

    # Print the metrics
    print(f"Structural Similarity Index (SSI): {ssi_index:.4f}")
    print(f"Mean Squared Error (MSE): {mse_value:.4f}")


# Input and output folders
input_folder = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/images"
output_folder = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/pca_denoising"

# Ensure the output folder exists
os.makedirs(output_folder, exist_ok=True)

# List all image files in the input folder
image_files = [f for f in os.listdir(input_folder) if f.endswith(('.jpg', '.png', '.jpeg'))]

# Process each image in the input folder
for image_file in image_files:
    input_path = os.path.join(input_folder, image_file)
    output_path = os.path.join(output_folder, f"{image_file}")

    # Apply PCA denoising and save the output
    pca_denoising(input_path, output_path)

    print(f"Processed: {image_file} -> {output_path}")