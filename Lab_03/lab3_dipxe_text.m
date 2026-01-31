img_raw = imread('DIP3E_Original_Images_CH03/Fig0340(a)(dipxe_text).tif');
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

sz = 31; sig = 5; p = (sz - 1) / 2;
kernel = zeros(sz, sz); center = (sz + 1) / 2; k_sum = 0;
for i = 1:sz
    for j = 1:sz
        d2 = (i - center)^2 + (j - center)^2;
        kernel(i,j) = exp(-d2 / (2 * sig^2));
        k_sum = k_sum + kernel(i,j);
    end
end
kernel = kernel / k_sum;

padded = zeros(rows + 2*p, cols + 2*p);
padded(p+1:rows+p, p+1:cols+p) = img_gray;
for i = 1:p, padded(i, p+1:cols+p) = img_gray(1, :); padded(rows+p+i, p+1:cols+p) = img_gray(rows, :); end
for j = 1:p, padded(:, j) = padded(:, p+1); padded(:, cols+p+j) = padded(:, cols+p); end

f_bar = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        val = 0;
        for ki = 1:sz
            for kj = 1:sz
                val = val + padded(i+ki-1, j+kj-1) * kernel(ki, kj);
            end
        end
        f_bar(i,j) = val;
    end
end

g_mask = img_gray - f_bar;
img_unsharp = img_gray + 1.0 * g_mask;

img_highboost = img_gray + 4.5 * g_mask;

figure(1); imshow(uint8(img_gray)); title('3.49(a) Original');
figure(2); imshow(uint8(f_bar)); title('3.49(b) Gaussian Blurred (31x31)');
figure(3); imshow(uint8(g_mask + 128)); title('3.49(c) Mask (Offset for visibility)');
figure(4); imshow(uint8(img_unsharp)); title('3.49(d) Unsharp Masking (k=1)');
figure(5); imshow(uint8(img_highboost)); title('3.49(e) Highboost Filtering (k=4.5)');