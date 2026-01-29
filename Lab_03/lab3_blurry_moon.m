img_raw = imread('DIP3E_Original_Images_CH03/Fig0338(a)(blurry_moon).tif');
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

w_a = [ 0,  1,  0; 
        1, -4,  1; 
        0,  1,  0];

w_b = [ 1,  1,  1; 
        1, -8,  1; 
        1,  1,  1];

p = 1; 
padded = zeros(rows + 2*p, cols + 2*p);
padded(p+1:rows+p, p+1:cols+p) = img_gray;

for i = 1:p, padded(i, p+1:cols+p) = img_gray(1, :); padded(rows+p+i, p+1:cols+p) = img_gray(rows, :); end
for j = 1:p, padded(:, j) = padded(:, p+1); padded(:, cols+p+j) = padded(:, cols+p); end

L_a = zeros(rows, cols); 
L_b = zeros(rows, cols); 

for i = 1:rows
    for j = 1:cols
        patch = padded(i:i+2, j:j+2);
        val_a = 0; val_b = 0;
        for ki = 1:3
            for kj = 1:3
                val_a = val_a + patch(ki, kj) * w_a(ki, kj);
                val_b = val_b + patch(ki, kj) * w_b(ki, kj);
            end
        end
        L_a(i,j) = val_a;
        L_b(i,j) = val_b;
    end
end

img_sharp_a = img_gray - L_a;
img_sharp_b = img_gray - L_b;

L_min = L_a(1,1); L_max = L_a(1,1);
for i = 1:rows
    for j = 1:cols
        if L_a(i,j) < L_min, L_min = L_a(i,j); end
        if L_a(i,j) > L_max, L_max = L_a(i,j); end
    end
end
L_scaled = 255 * (L_a - L_min) / (L_max - L_min);

figure(1); imshow(uint8(img_gray)); title('3.46(a) Original Blurry Moon');
figure(2); imshow(uint8(L_a)); title('3.46(b) Laplacian (Clipped)');
figure(3); imshow(uint8(img_sharp_a)); title('3.46(c) Sharpened (Kernel a)');
figure(4); imshow(uint8(img_sharp_b)); title('3.46(d) Sharpened (Kernel b)');
figure(5); imshow(uint8(L_scaled)); title('Figure 3.47 Scaled Laplacian');