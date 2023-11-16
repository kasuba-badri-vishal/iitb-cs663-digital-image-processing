%% MyMainScript

tic;

%%% PART - A

% Reading Images
T1 = imread('./../images/T1.jpg');
T2 = imread('./../images/T2.jpg');

% Casting Images to double
J1 = im2double(T1);
J2 = im2double(T2);


% Rotation of J3 image with Bilinear Interpolation
theta = 28.5;
J3 = imrotate(J2, theta, "bilinear", "crop");

% Assigning 0 value to unoccupied pixels
J3(isnan(J3)) = 0;

% Saving the Image
imshow(J3)
imwrite(J3, 'J3.jpg' ,'jpg')



%%% PART - B

% Range of angles for search
angles = -45:1:45;

% Initialization to store NCC, JE, and QMI values
nccValues = zeros(size(angles));
jeValues  = zeros(size(angles));
qmiValues = zeros(size(angles));

% Computing NCC, JE, and QMI values
for i = 1:length(angles)

    % Rotating J3 image accordingly
    angle = angles(i);
    J4 = imrotate(J3, angle, 'bilinear', 'crop');
    J4(isnan(J4)) = 0;
    
    % Normalizing J4 and J1
    J4_norm = (J4 - mean(J4(:))) / std(J4(:));
    J1_norm = (J1 - mean(J1(:))) / std(J1(:));
    
    % NCC calculation
    nccValues(i) = sum(J1_norm(:) .* J4_norm(:)) / numel(J1);
    
    % JE Calculation
    jointHist = histcounts2(J1_norm(:), J4_norm(:), 256);

    jointProb = jointHist / sum(jointHist(:));
    jeValues(i) = -sum(jointProb(jointProb > 0) .* log2(jointProb(jointProb > 0)));
    
    % QMI Calculation
    qmiValues(i) = computeQMI(J1, J4);
end

% Display the results and find the best angles
[bestNCCValue, bestNCCIndex] = min(nccValues);
[bestJEValue, bestJEIndex] = min(jeValues);
[bestQMIValue, bestQMIIndex] = max(qmiValues);

bestNCCAngle = angles(bestNCCIndex);
bestJEAngle = angles(bestJEIndex);
bestQMIAngle = angles(bestQMIIndex);

fprintf('Best NCC angle: %.2f degrees (NCC value: %.4f)\n', bestNCCAngle, bestNCCValue);
fprintf('Best JE angle: %.2f degrees (JE value: %.4f)\n', bestJEAngle, bestJEValue);
fprintf('Best QMI angle: %.2f degrees (QMI value: %.4f)\n', bestQMIAngle, bestQMIValue);


% Plot and save NCC values
figure;
plot(angles, nccValues, 'b--o');
title('Normalized Cross-Correlation (NCC)');
xlabel('Rotation Angle (degrees)');
ylabel('NCC Value');
saveas(gcf, 'NCC_Plot.png');

% Plot and save JE values
figure;
plot(angles, jeValues, 'b--o');
title('Joint Entropy (JE)');
xlabel('Rotation Angle (degrees)');
ylabel('JE Value');
saveas(gcf, 'JE_Plot.png');

% Plot and save QMI values
figure;
plot(angles, qmiValues, 'b--o');
title('Quadratic Mutual Information (QMI)');
xlabel('Rotation Angle (degrees)');
ylabel('QMI Value');
saveas(gcf, 'QMI_Plot.png');



%% Part - E Plotting Histogram

% Rotate J3 using the optimal angle
J4_optimal = imrotate(J3, bestJEAngle, 'bilinear', 'crop');
J4_optimal(isnan(J4_optimal)) = 0; 


% Define the number of intensity bins
num_bins = 26;

% Calculate histograms for both images
hist_image1 = histcounts(J1(:), num_bins, 'Normalization', 'probability');
hist_image2 = histcounts(J4_optimal(:), num_bins, 'Normalization', 'probability');

% Initialize the joint histogram for (image1, image2)
hist_joint = zeros(num_bins);

% Calculate the joint histogram using nested loops
for i = 1:size(J1, 1)
    for j = 1:size(J4_optimal, 2)
        intensity_bin1 = floor(J1(i, j) * (num_bins - 1)) + 1;
        intensity_bin2 = floor(J4_optimal(i, j) * (num_bins - 1)) + 1;
        hist_joint(intensity_bin1, intensity_bin2) = hist_joint(intensity_bin1, intensity_bin2) + 1;
    end
end

% Normalize the joint histogram to create a joint probability distribution
p_joint = hist_joint / sum(hist_joint(:));

% Plot the joint histogram
figure;
imagesc(p_joint);
colormap jet;
colorbar;
xlabel('Intensity in J4 (Rotated)');
ylabel('Intensity in J1');
title('Joint Histogram between J1 and J4 (Optimal JE)');
axis xy;
 
% Save the plot as an image
saveas(gcf, 'Joint_Histogram_Optimal_JE.png');


function qmi = computeQMI(image1, image2)

    num_bins = 256;

    % Calculate histograms for both images
    hist_image1 = histcounts(image1(:), num_bins, 'Normalization', 'probability');
    hist_image2 = histcounts(image2(:), num_bins, 'Normalization', 'probability');
    
    % Initialize the joint histogram for (image1, image2)
    hist_joint = zeros(num_bins);
    
    % Calculate the joint histogram using nested loops
    for i = 1:size(image1, 1)
        for j = 1:size(image1, 2)
            intensity_bin1 = floor(image1(i, j) * (num_bins - 1)) + 1;
            intensity_bin2 = floor(image2(i, j) * (num_bins - 1)) + 1;
            hist_joint(intensity_bin1, intensity_bin2) = hist_joint(intensity_bin1, intensity_bin2) + 1;
        end
    end
    
    % Normalize the joint histogram to create a joint probability distribution
    p_joint = hist_joint / sum(hist_joint(:));
    
    % Calculate the mutual information using the joint and marginal probabilities
    mutual_info = 0;
    for i = 1:num_bins
        for j = 1:num_bins
            p_ij = p_joint(i, j);
            p_i = hist_image1(i);
            p_j = hist_image2(j);
            
            if p_ij > 0 && p_i > 0 && p_j > 0
                mutual_info = mutual_info + p_ij * log2(p_ij / (p_i * p_j));
            end
        end
    end

    qmi = mutual_info;
end


toc;







