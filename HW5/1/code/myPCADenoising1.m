function denoised_image = myPCADenoising1(im1, sigma)
    patch_size = 7;
    P = im2col(im1, [patch_size, patch_size], 'sliding');
    N = size(P, 2);
    [V, D] = eig(P * P');
    alphas = V' * P;
    alpha_i = max(0, (1 / N) * (sum(alphas.^2, 2)) - sigma^2);
    alphas_updated = zeros(size(alphas));

    for i = 1:patch_size^2
        alphas_updated(i, :) = alphas(i, :) / (1 + sigma^2 / alpha_i(i));
    end
    P_denoised = V * alphas_updated;
    [m, n] = size(im1);

    indices = reshape(1:m * n, [m, n]);
    subs = im2col(indices, [7, 7], 'sliding');

    denoised_image = accumarray(subs(:), P_denoised(:)) ./ accumarray(subs(:), 1);
    denoised_image = reshape(denoised_image, m, n);
    denoised_image = (denoised_image - min(denoised_image(:))) / (max(denoised_image(:)) - min(denoised_image(:))) * 255;
end
