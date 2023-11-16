
% Provide Cutoff Frequency
cutoff_frequency = 60

% Reading Image
img = imread('barbara256.png')

% Casting Image to Double
img_pro = im2double(img)

%% Display the original image
figure; imshow(img_pro); colormap("gray"); title('Original Image');

% Pad the image to make the dimensions twice as large
img_padded = padarray(img_pro, [size(img_pro, 1) / 2, size(img_pro, 2) / 2]);

% Get Ideal Low pass filtered image
img_filtered_ideal = IdealLowPass(img_padded, cutoff_frequency);

% Display filtered image when using an ideal Low Pass Filter
figure; imshow(img_filtered_ideal); colormap("gray"); title('Ideal Low Pass Filter Image');

% Gaussian Low Pass filtered image
img_filtered_gaussian = GaussianLowPass(img_padded, cutoff_frequency);

% Extract the central part of the image
img_filtered_gaussian = img_filtered_gaussian(size(img, 1) / 2 + 1:size(img, 1) / 2 + size(img, 1), size(img, 2) / 2 + 1:size(img, 2) / 2 + size(img, 2));

% Display filtered image when using a Gaussian Low Pass Filter
figure; imshow(img_filtered_gaussian); colormap("gray"); title('Gaussian Low Pass Filter Image');



function img_filtered = IdealLowPass(img, cutoff_freq)


    %% Compute the Fourier transform of the image along with shift
    F = fftshift(fft2(img));
    log_F = log(abs(F) + 1);
    figure; imshow(log_F, [min(log_F(:)) max(log_F(:))]); colormap("jet"); colorbar; title('Fourier Transform of the Image');


    % Apply the low pass filter of cutoff frequency
    Filter = zeros(size(F));
    [x, y] = meshgrid(-size(Filter, 1) / 2:size(Filter, 1) / 2 - 1, -size(Filter, 2) / 2:size(Filter, 2) / 2 - 1);
    valid_indices = (x.^2 + y.^2) <= cutoff_freq^2;
    Filter(valid_indices) = 1;
    figure; imshow(log(1 + Filter), [min(log(1 + Filter(:))) max(log(1 + Filter(:)))]); colormap("jet"); colorbar; title('Ideal Low Pass Filter');

    %% Display the magnitude of the Fourier transform of the filtered image
    F_filtered = F .* Filter;
    log_F_filtered = log(abs(F_filtered) + 1);
    figure; imshow(log_F_filtered, [min(log_F_filtered(:)) max(log_F_filtered(:))]); colormap("jet"); colorbar; title('Fourier Transform of the Filtered Image');
    img_filtered = ifft2(ifftshift(F_filtered));
end


function img_filtered = GaussianLowPass(img, sigma)
    
    %% Compute the Fourier transform of the image along with shift
    F = fftshift(fft2(img));
    log_F = log(abs(F) + 1); 
    figure; imshow(log_F, [min(log_F(:)) max(log_F(:))]); colormap("jet"); colorbar; title('Fourier Transform of the Image');

    % Apply the low pass filter of cutoff frequency 50
    Filter = zeros(size(F));
    [x, y] = meshgrid(-size(Filter, 1) / 2:size(Filter, 1) / 2 - 1, -size(Filter, 2) / 2:size(Filter, 2) / 2 - 1);
    Filter = exp(-((x.^2 + y.^2) / (2 * sigma^2)));
    figure; imshow(log(1 + Filter), [min(log(1 + Filter(:))) max(log(1 + Filter(:)))]); colormap("jet"); colorbar; title('Gaussian Low Pass Filter');

    %% Display the magnitude of the Fourier transform of the filtered image
    F_filtered = F .* Filter;
    log_F_filtered = log(abs(F_filtered) + 1);
    figure; imshow(log_F_filtered, [min(log_F_filtered(:)) max(log_F_filtered(:))]); colormap("jet"); colorbar; title('Fourier Transform of the Filtered Image');
    img_filtered = ifft2(ifftshift(F_filtered));
end