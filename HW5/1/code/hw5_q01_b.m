tic;

clear;
close all;
clc;

image1 = double(imread('barbara256.png'));
image2 = double(imread('stream.png'));
sigma = 20;

image1_block = image1(1:256,1:256);
figure; imagesc(image1); colormap('gray'); title('Original Image Barbara');
im = image1_block;
im1 = im + randn(size(im)) * sigma;
denoised_image = myPCADenoising2(im1, sigma); 
figure; imagesc(im1); colormap('gray'); title('Original Noisy Image');
figure; imagesc(denoised_image); colormap('gray'); title('Denoised Image');
fprintf('The RMSE is %f\n', sqrt(sum((im1(:) - denoised_image(:)).^2) / sum(im1(:).^2)));
toc;




image2_block = image2(1:256, 1:256);
figure; imagesc(image2_block); colormap('gray'); title('Original Image');
im = image2_block;
im1 = im + randn(size(im)) * sigma;
denoised_image = myPCADenoising2(im1, sigma); 
figure; imagesc(im1); colormap('gray'); title('Original Noisy Image');
figure; imagesc(denoised_image); colormap('gray'); title('Denoised Image');
fprintf('The RMSE is %f\n', sqrt(sum((im1(:) - denoised_image(:)).^2) / sum(im1(:).^2)));
toc;