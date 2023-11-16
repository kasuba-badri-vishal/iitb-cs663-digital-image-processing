% Create the image
N = 201;
image = zeros(N, N);
image(101, 1:N) = 255;

% Compute the 2D Fourier transform
F = fft2(image);

% Shift the zero frequency components to the center
F_shifted = fftshift(F);
log_magnitude = log(1 + abs(F_shifted));  % Adding 1 to avoid log(0)

% Plot the logarithm of the Fourier magnitude
figure(1); imshow(log_magnitude, [min(log_magnitude(:)) max(log_magnitude(:))]);
title('Logarithm of Fourier Magnitude');
colormap('jet');
colorbar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the logarithm of the Fourier magnitude
%figure(2); imshow(log_magnitude, []);
%title('Logarithm of Fourier Magnitude_1');
%colormap('jet');
%colorbar;



