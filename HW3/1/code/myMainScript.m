% Load the images
barbara = imread('barbara256.png');
kodak = imread('kodak24.png');

% Gaussian noise with σ = 5 
sigma_noise = 5;
noisy_barbara = imnoise(barbara, 'gaussian', 0, (sigma_noise/255)^2);
imshow(noisy_barbara);
imwrite(noisy_barbara, 'Noisy Barbara_sigma 5.png');

noisy_kodak = imnoise(kodak, 'gaussian', 0, (sigma_noise/255)^2);
imshow(noisy_kodak);
imwrite(noisy_kodak, 'Noisy kodak_sigma 5.png');

% Define parameter configurations
configurations = [
    struct('sigma_s', 2, 'sigma_r', 2);
    struct('sigma_s', 0.1, 'sigma_r', 0.1);
    struct('sigma_s', 3, 'sigma_r', 15)
];

% Apply mean shift filter for each configuration
filtered_images_barbara = cell(length(configurations), 1);
filtered_images_kodak = cell(length(configurations), 1);

for i = 1:length(configurations)
    sigma_s = configurations(i).sigma_s;
    sigma_r = configurations(i).sigma_r;
    
    % Apply mean shift filter
    filtered_images_barbara{i} = imfilter(noisy_barbara, fspecial('gaussian', [5 5], sigma_s), 'symmetric');
    filtered_images_kodak{i} = imfilter(noisy_kodak, fspecial('gaussian', [5 5], sigma_s), 'symmetric');
end

imshow(filtered_images_barbara{1});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(1).sigma_s), ', \sigma_r = ', num2str(configurations(1).sigma_r)]);
imwrite(filtered_images_barbara{1},"barbara_sigma_5_sigmas_sigmar_2.png");

imshow(filtered_images_barbara{2});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(2).sigma_s), ', \sigma_r = ', num2str(configurations(2).sigma_r)]);
imwrite(filtered_images_barbara{2},"barbara_sigma_5_sigmas_sigmar_0.1.png");

imshow(filtered_images_barbara{3});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(3).sigma_s), ', \sigma_r = ', num2str(configurations(3).sigma_r)]);
imwrite(filtered_images_barbara{3},"barbara_sigma_5_sigmas_3_sigmar_15.png");
 
imshow(filtered_images_kodak{1});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(1).sigma_s), ', \sigma_r = ', num2str(configurations(1).sigma_r)]);
imwrite(filtered_images_kodak{1},"kodak_sigma_5_sigmas_sigmar_2.png");

imshow(filtered_images_kodak{2});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(2).sigma_s), ', \sigma_r = ', num2str(configurations(2).sigma_r)]);
imwrite(filtered_images_kodak{2},"kodak_sigma_5_sigmas_sigmar_0.1.png");

imshow(filtered_images_kodak{3});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(3).sigma_s), ', \sigma_r = ', num2str(configurations(3).sigma_r)]);
imwrite(filtered_images_kodak{3},"kodak_sigma_5_sigmas_3_sigmar_15.png");

% Gaussian noise with σ = 10
sigma_noise = 10;
noisy_barbara = imnoise(barbara, 'gaussian', 0, (sigma_noise/255)^2);
imshow(noisy_barbara);
imwrite(noisy_barbara, 'Noisy Barbara_sigma 10.png');

noisy_kodak = imnoise(kodak, 'gaussian', 0, (sigma_noise/255)^2);
imshow(noisy_kodak);
imwrite(noisy_kodak, 'Noisy kodak_sigma 10.png');

% Define parameter configurations
configurations = [
    struct('sigma_s', 2, 'sigma_r', 2);
    struct('sigma_s', 0.1, 'sigma_r', 0.1);
    struct('sigma_s', 3, 'sigma_r', 15)
];

% Apply mean shift filter for each configuration
filtered_images_barbara = cell(length(configurations), 1);
filtered_images_kodak = cell(length(configurations), 1);

for i = 1:length(configurations)
    sigma_s = configurations(i).sigma_s;
    sigma_r = configurations(i).sigma_r;
    
    % Apply mean shift filter
    filtered_images_barbara{i} = imfilter(noisy_barbara, fspecial('gaussian', [10 10], sigma_s), 'symmetric');
    filtered_images_kodak{i} = imfilter(noisy_kodak, fspecial('gaussian', [10 10], sigma_s), 'symmetric');
end

imshow(filtered_images_barbara{1});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(1).sigma_s), ', \sigma_r = ', num2str(configurations(1).sigma_r)]);
imwrite(filtered_images_barbara{1},"barbara_sigma_10_sigmas_sigmar_2.png");

imshow(filtered_images_barbara{2});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(2).sigma_s), ', \sigma_r = ', num2str(configurations(2).sigma_r)]);
imwrite(filtered_images_barbara{2},"barbara_sigma_10_sigmas_sigmar_0.1.png");

imshow(filtered_images_barbara{3});
title(['Filtered Barbara - \sigma_s = ', num2str(configurations(3).sigma_s), ', \sigma_r = ', num2str(configurations(3).sigma_r)]);
imwrite(filtered_images_barbara{3},"barbara_sigma_10_sigmas_3_sigmar_15.png");
 
imshow(filtered_images_kodak{1});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(1).sigma_s), ', \sigma_r = ', num2str(configurations(1).sigma_r)]);
imwrite(filtered_images_kodak{1},"kodak_sigma_10_sigmas_sigmar_2.png");

imshow(filtered_images_kodak{2});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(2).sigma_s), ', \sigma_r = ', num2str(configurations(2).sigma_r)]);
imwrite(filtered_images_kodak{2},"kodak_sigma_10_sigmas_sigmar_0.1.png");

imshow(filtered_images_kodak{3});
title(['Filtered kodak - \sigma_s = ', num2str(configurations(3).sigma_s), ', \sigma_r = ', num2str(configurations(3).sigma_r)]);
imwrite(filtered_images_kodak{3},"kodak_sigma_10_sigmas_3_sigmar_15.png");
