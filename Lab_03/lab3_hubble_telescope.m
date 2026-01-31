img_raw = imread('DIP3E_Original_Images_CH03/Fig0334(a)(hubble-original).tif');
if size(img_raw, 3) == 3, img_raw = rgb2gray(img_raw); end

img = double(img_raw) / 255; 
[H, W] = size(img);

sz = 151; 
sigma = 12; 
p = (sz - 1) / 2; 
kernel = zeros(sz, sz);
center = (sz + 1) / 2;
k_sum = 0;

for i = 1:sz
    for j = 1:sz
        dist_sq = (i - center)^2 + (j - center)^2;
        kernel(i,j) = exp(-dist_sq / (2 * sigma^2));
        k_sum = k_sum + kernel(i,j);
    end
end
kernel = kernel / k_sum; 

padded = padarray(img, [p, p], 'replicate');
img_filtered = zeros(H, W);

for i = 1:H
    for j = 1:W
        patch = padded(i:i+sz-1, j:j+sz-1);
        val = 0;
        for ki = 1:sz
            for kj = 1:sz
                val = val + patch(ki, kj) * kernel(ki, kj);
            end
        end
        img_filtered(i,j) = val;
    end
end

T = 0.4;
img_thresholded = zeros(H, W);

for i = 1:H
    for j = 1:W
        if img_filtered(i,j) > T
            img_thresholded(i,j) = 1.0;
        else
            img_thresholded(i,j) = 0.0;
        end
    end
end

figure(1); imshow(img); title('3.41(a) Original');
figure(2); imshow(img_filtered); title(['3.41(b) Reduced Blur (\sigma=', num2str(sigma), ')']);
figure(3); imshow(img_thresholded, []); title('3.41(c) Thresholded Result');