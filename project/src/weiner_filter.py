import cv2
import os
import numpy as np
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import mean_squared_error
from scipy.signal import wiener
import matplotlib.pyplot as plt

def add_noise(image, noise_level=25):
    """Add Gaussian noise to an image."""
    row, col, _ = image.shape
    gauss = np.random.normal(0, noise_level, (row, col, 3))
    noisy = np.clip(image + gauss, 0, 255)
    return noisy.astype(np.uint8)

def wiener_filter(image, kernel_size=5, noise_var=25):
    """Apply Wiener filter to restore the image."""
    psf = (kernel_size, kernel_size)
    restored_image = np.zeros_like(image)
    for i in range(3):  # Iterate over RGB channels
        restored_image[:, :, i] = wiener(image[:, :, i], mysize=psf, noise=noise_var)

    return np.clip(restored_image, 0, 255).astype(np.uint8)

input_folder = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/images"
output_folder = "/home/ganesh/BADRI/MANUSCRIPTS/data/project_data/wiener/"

# Ensure the output folder exists
os.makedirs(output_folder, exist_ok=True)

# List all image files in the input folder
image_files = [f for f in os.listdir(input_folder) if f.endswith(('.jpg', '.png', '.jpeg'))]

# Process each image in the input folder
for image_file in image_files:
    input_path = os.path.join(input_folder, image_file)
    output_path = os.path.join(output_folder, f"{image_file}")
    original_image = cv2.imread(input_path)
    original_image = cv2.cvtColor(original_image, cv2.COLOR_BGR2RGB)

    # Add Gaussian noise to the image
    noisy_image = add_noise(original_image)

    # Apply Wiener filter for image restoration
    restored_image = wiener_filter(noisy_image)
    # Save the result image
    cv2.imwrite(output_path, cv2.cvtColor(restored_image.astype(np.uint8), cv2.COLOR_RGB2BGR))

    print(f"Processed: {image_file} -> {output_path}")


    # Calculate Structural Similarity Index (SSI)
    ssi_index, _ = ssim(original_image, restored_image, full=True, multichannel=True)

    # Calculate Mean Squared Error (MSE)
    mse_value = mean_squared_error(original_image, restored_image)

    # Print the metrics
    print(f"Structural Similarity Index (SSI): {ssi_index:.4f}")
    print(f"Mean Squared Error (MSE): {mse_value:.4f}")