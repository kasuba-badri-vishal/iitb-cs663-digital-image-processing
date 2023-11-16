function denoised_image = myPCADenoising2(im1, sigma)
    patch_size = 7;
    neighbourhood_size = 31;
    [m, n] = size(im1);
    P_image = []; 
    for j = 1:n - patch_size + 1

        for i = 1:m - patch_size + 1
            patch = im1(i:i + patch_size - 1, j:j + patch_size - 1);
            neighbourhood_top = max(1, i - floor(neighbourhood_size / 2));
            neighbourhood_bottom = min(m - patch_size + 1, i + floor(neighbourhood_size / 2));
            neighbourhood_left = max(1, j - floor(neighbourhood_size / 2));
            neighbourhood_right = min(n - patch_size + 1, j + floor(neighbourhood_size / 2));
            patch_neighbourhood = im1(neighbourhood_top:neighbourhood_bottom, neighbourhood_left:neighbourhood_right);
            patch_neighbourhood_patches = im2col(patch_neighbourhood, [patch_size, patch_size], 'sliding');
            distances = sum((patch_neighbourhood_patches - patch(:)).^2);
            [~, sorted_indices] = sort(distances);
            K = min(200, size(distances, 2));
            P = patch_neighbourhood_patches(:, sorted_indices(1:K));
            N = size(P, 2);
            [V, D] = eig(P * P');
            alphas = V' * P;
            alpha_central_patch = V' * patch(:);
            alpha_i = max(0, (1 / N) * (sum(alphas.^2, 2)) - sigma^2);
            for i = 1:patch_size^2
                alpha_central_patch(i) = alpha_central_patch(i) / (1 + sigma^2 / alpha_i(i));
            end
            P_denoised = V * alpha_central_patch;
            P_image = [P_image, P_denoised]; 
        end

    end

    [m, n] = size(im1);

    indices = reshape(1:m * n, [m, n]);
    subs = im2col(indices, [7, 7], 'sliding');
    denoised_image = accumarray(subs(:), P_image(:)) ./ accumarray(subs(:), 1);
    denoised_image = reshape(denoised_image, m, n);
    denoised_image = (denoised_image - min(denoised_image(:))) / (max(denoised_image(:)) - min(denoised_image(:))) * 255;
end
