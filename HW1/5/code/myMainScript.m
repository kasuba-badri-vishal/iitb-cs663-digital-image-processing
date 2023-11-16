%% MyMainScript

tic;

% part-a

clear all; 
im1 = imread('./HW1/goi1.jpg');
im2 = imread('./HW1/goi2_downsampled.jpg');
img1=double(im1);
img2=double(im2);
imshow(im1)
n = 12;
for i=1:n 
    figure(1); imshow(img1/255); 
    [x1(i), y1(i)] = ginput(1);
    figure(2); imshow(img2/255); 
    [x2(i), y2(i)] = ginput(1);
end
disp("Figure 1 goi1 selected points are:")
disp([x1, y1])
disp("Figure 2 goi2 selected points are:")
disp([x2, y2])

%{
output:
Figure 1 goi1 selected points are:
Columns 1 through 12

   99.0600  426.7400   24.8200  127.2200  380.6600  454.9000  255.2200  564.9800  173.3000  362.7400  163.0600  165.6200

  Columns 13 through 24

  168.9800  176.6600  171.5400   28.1800   43.5400  238.1000  327.7000  192.0200  248.3400  243.2200   71.7000   48.6600

Figure 1 goi1 selected points are:
  Columns 1 through 12

  132.3400  472.8200   37.6200  165.6200  419.0600  503.5400  303.8600  623.8600  209.1400  403.7000  403.7000  204.0200

  Columns 13 through 24

  186.9000  181.7800  186.9000   43.5400   58.9000  256.0200  343.0600  197.1400  266.2600  243.2200  102.4200   76.8200
%}

% part-b

im2 = imread('./HW1/goi1.jpg');
im1 = imread('./HW1/goi2_downsampled.jpg');
[f1, Points1] = extractFeatures(im1, detectSURFFeatures(im1));
[f2, Points2] = extractFeatures(im2, detectSURFFeatures(im2));

indexPairs = matchFeatures(f1, f2);
matchedPoints1 = Points1(indexPairs(:, 1), :);
matchedPoints2 = Points2(indexPairs(:, 2), :);

tform1 = estimateGeometricTransform(matchedPoints1, matchedPoints2, 'affine');
transformedImage = imwarp(im1, tform1);
if isequal(transformedImage, im2)
    disp('goi2_downsampled is a transformation of goi1.');
end

scalingFactor = size(im1) ./ size(im2);
threshold = 0.001; 
if abs(scalingFactor(1) - scalingFactor(2)) < threshold && abs(scalingFactor(2) - 1) < threshold
    disp('goi2_downsampled is a scaling of goi1.');
end

tform = fitgeotrans(matchedPoints1.Location, matchedPoints2.Location, 'affine');
isSheared = any(abs(tform.T(2, 1)) > 1e-6 || abs(tform.T(1, 2)) > 1e-6);
if isSheared
    disp('goi2_downsampled is a shear of goi1.');
end

isRotated = abs(tform.T(1, 1) - tform.T(2, 2)) < 1e-6 && abs(tform.T(2, 1)) < 1e-6 && abs(tform.T(1, 2)) < 1e-6;
if isRotated
    disp('goi2_downsampled is a rotation of goi1.');
end


% part-c

[height, width, ~] = size(im2);
warped_image = uint8(zeros(height, width, 3));
affine_matrix = tform.T;
for y = 1:height
    for x = 1:width
        source_point = [x y 1]/affine_matrix;
        source_x = round(source_point(1));
        source_y = round(source_point(2));
        if source_x >= 1 && source_x <= size(im1, 2) && source_y >= 1 && source_y <= size(im1, 1)
            warped_image(y, x, :) = im1(source_y, source_x, :);
        end
    end
end

imshow(warped_image);
imwrite(warped_image, 'warped_image_linear_c_part.jpg'); 

% part-d

warped_image = uint8(zeros(height, width, 3));
affine_matrix = tform.T;
for y = 1:height
    for x = 1:width
        source_point = [x y 1] / affine_matrix;
        source_x = round(source_point(1));
        source_y = round(source_point(2));
        x1 = floor(source_x);
        x2 = ceil(source_x);
        y1 = floor(source_y);
        y2 = ceil(source_y);

        if x1 >= 1 && x2 <= size(im1, 2) && y1 >= 1 && y2 <= size(im1, 1)
            dx = source_x - x1;
            dy = source_y - y1;
            w1 = uint8((1 - dx) * (1 - dy));
            w2 = uint8(dx * (1 - dy));
            w3 = uint8((1 - dx) * dy);
            w4 = uint8(dx * dy);
            warped_image(y, x, :) = w1 * im1(y1, x1, :) + w2 * im1(y1, x2, :) + w3 * im1(y2, x1, :) + w4 * im1(y2, x2, :);
        end
    end
end
imshow(warped_image);
imwrite(warped_image, 'warped_image_bilinear_d_part.jpg');



toc;
