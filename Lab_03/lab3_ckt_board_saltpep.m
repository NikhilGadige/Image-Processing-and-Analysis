img_raw = imread('DIP3E_Original_Images_CH03/Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
[rows, cols, channels] = size(img_raw);
if channels == 3
    img_gray = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            img_gray(i,j) = 0.299*double(img_raw(i,j,1)) + ...
                            0.587*double(img_raw(i,j,2)) + ...
                            0.114*double(img_raw(i,j,3));
        end
    end
else
    img_gray = double(img_raw);
end

sz_g = 19; sig_g = 3; pg = (sz_g - 1) / 2;
kernel_g = zeros(sz_g, sz_g); cg = (sz_g + 1) / 2; k_sum = 0;
for i = 1:sz_g
    for j = 1:sz_g
        d2 = (i - cg)^2 + (j - cg)^2;
        kernel_g(i,j) = exp(-d2 / (2 * sig_g^2));
        k_sum = k_sum + kernel_g(i,j);
    end
end
kernel_g = kernel_g / k_sum;

padded_g = zeros(rows + 2*pg, cols + 2*pg);
padded_g(pg+1:rows+pg, pg+1:cols+pg) = img_gray;
for i = 1:pg, padded_g(i, pg+1:cols+pg) = img_gray(1, :); padded_g(rows+pg+i, pg+1:cols+pg) = img_gray(rows, :); end
for j = 1:pg, padded_g(:, j) = padded_g(:, pg+1); padded_g(:, cols+pg+j) = padded_g(:, cols+pg); end

img_gaussian = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        val = 0;
        for ki = 1:sz_g
            for kj = 1:sz_g
                val = val + padded_g(i+ki-1, j+kj-1) * kernel_g(ki, kj);
            end
        end
        img_gaussian(i,j) = val;
    end
end

sz_m = 7; pm = (sz_m - 1) / 2;
padded_m = zeros(rows + 2*pm, cols + 2*pm);
padded_m(pm+1:rows+pm, pm+1:cols+pm) = img_gray;

for i = 1:pm, padded_m(i, pm+1:cols+pm) = img_gray(1, :); padded_m(rows+pm+i, pm+1:cols+pm) = img_gray(rows, :); end
for j = 1:pm, padded_m(:, j) = padded_m(:, pm+1); padded_m(:, cols+pm+j) = padded_m(:, cols+pm); end
img_median = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        neighborhood = padded_m(i:i+sz_m-1, j:j+sz_m-1);
        vector = neighborhood(:);
        
        n = length(vector);
        for m = 1:n-1
            for k = 1:n-m
                if vector(k) > vector(k+1)
                    temp = vector(k);
                    vector(k) = vector(k+1);
                    vector(k+1) = temp;
                end
            end
        end
        img_median(i,j) = vector((n+1)/2); 
    end
end

figure(1); imshow(uint8(img_gray)); title('3.43(a) Salt-and-Pepper Noise');
figure(2); imshow(uint8(img_gaussian)); title('3.43(b) Gaussian Filtered (19x19)');
figure(3); imshow(uint8(img_median)); title('3.43(c) Median Filtered (7x7)');