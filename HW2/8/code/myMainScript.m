% Clering memory
clear; 
close all;

% Reading the Images
img_bar = imread('barbara256.png');
img_kod = imread('kodak24.png');

% Images preprocessing
img_bar = im2double(img_bar);
img_kod = im2double(img_kod);

% Drawing Original Images
figure(1); imagesc(img_bar); colormap("gray"); title("Original barbara256"); saveas(gcf, '1_Original_barbara256.png');
figure(2); imagesc(img_kod); colormap("gray"); title("Original kodak24"); saveas(gcf, '2_Original_kodak24.png');

% Adding zero-mean Gaussian noise
gau_std_1 = 5;
img_bar_n_1 = img_bar + gau_std_1/255*randn(size(img_bar)); 
img_kod_n_1 = img_kod + gau_std_1/255*randn(size(img_kod));


% Drawing Images with adding Guassian Noise
figure(3); imagesc(img_bar_n_1); colormap("gray"); title("noisy barbara256 with \sigma_n = " + num2str(gau_std_1)); saveas(gcf, '3_Noisy_barbara256_5.png');
figure(4); imagesc(img_kod_n_1); colormap("gray"); title("noisy kodak24 with \sigma_n = " + num2str(gau_std_1)); saveas(gcf, '4_Noisy_kodak24_5.png');


% Define the parameter configurations
configurations = [
    struct('sig_s', 2, 'sig_r', 2);
    struct('sig_s', 0.1, 'sig_r', 0.1);
    struct('sig_s', 3, 'sig_r', 15);
];

count = 5;

% Apply the bilateral filter to both images for each configuration
for i = 1:length(configurations)
    config = configurations(i);
    
    bil_fil_bar = mybilateralfilter(img_bar_n_1,config.sig_s, config.sig_r);
    bil_fil_kod = mybilateralfilter(img_kod_n_1,config.sig_s, config.sig_r);

    filename = [num2str(count),'_barbara256_', num2str(gau_std_1), '_', num2str(config.sig_s), '_', num2str(config.sig_r), '.png'];
    figure(count); imagesc(bil_fil_bar); colormap("gray"); 
    title("filtered barbara256 with \sigma_n = " + num2str(gau_std_1) + ", \sigma_s = " + num2str(config.sig_s) + ", \sigma_r = " + num2str(config.sig_r));
    saveas(gcf, filename);

    filename = [num2str(count+1),'_kodak24_', num2str(gau_std_1), '_', num2str(config.sig_s), '_', num2str(config.sig_r), '.png'];
    figure(count+1); imagesc(bil_fil_kod); colormap("gray");
    title("filtered kodak24 with \sigma_n = " + num2str(gau_std_1) + ", \sigma_s = " + num2str(config.sig_s) + ", \sigma_r = " + num2str(config.sig_r));
    saveas(gcf, filename);
    count= count+2;


end


% Adding zero-mean Gaussian noise
gau_std_1 = 10;
img_bar_n_1 = img_bar + gau_std_1/255*randn(size(img_bar));
img_kod_n_1 = img_kod + gau_std_1/255*randn(size(img_kod));

figure(count); imagesc(img_bar_n_1); colormap("gray"); title("noisy barbara256 with \sigma_n = " + num2str(gau_std_1));  saveas(gcf, '11_Noisy_barbara256_10.png');
figure(count+1); imagesc(img_kod_n_1); colormap("gray"); title("noisy kodak24 with \sigma_n = " + num2str(gau_std_1));   saveas(gcf, '12_Noisy_kodak24_10.png');

count = count + 2;

% Apply the bilateral filter to both images for each configuration
for i = 1:length(configurations)
    config = configurations(i);
    
    bil_fil_bar = mybilateralfilter(img_bar_n_1,config.sig_s, config.sig_r);
    bil_fil_kod = mybilateralfilter(img_kod_n_1,config.sig_s, config.sig_r);

    filename = [num2str(count), '_barbara256_', num2str(gau_std_1), '_', num2str(config.sig_s), '_', num2str(config.sig_r), '.png'];
    figure(count); imagesc(bil_fil_bar); colormap("gray"); 
    title("filtered barbara256 with \sigma_n = " + num2str(gau_std_1) + ", \sigma_s = " + num2str(config.sig_s) + ", \sigma_r = " + num2str(config.sig_r));
    saveas(gcf, filename);

    filename = [num2str(count+1), '_kodak24_', num2str(gau_std_1), '_', num2str(config.sig_s), '_', num2str(config.sig_r), '.png'];
    figure(count+1); imagesc(bil_fil_kod); colormap("gray");
    title("filtered kodak24 with \sigma_n = " + num2str(gau_std_1) + ", \sigma_s = " + num2str(config.sig_s) + ", \sigma_r = " + num2str(config.sig_r));
    saveas(gcf, filename);
    count= count+2;


end

