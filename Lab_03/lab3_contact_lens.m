img_raw = imread('DIP3E_Original_Images_CH03/Fig0342(a)(contact_lens_original).tif'); 
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

w_x = [-1, -2, -1; 
        0,  0,  0; 
        1,  2,  1];

w_y = [-1,  0,  1; 
       -2,  0,  2; 
       -1,  0,  1];

p = 1; 
padded = zeros(rows + 2*p, cols + 2*p);
padded(p+1:rows+p, p+1:cols+p) = img_gray;

for i = 1:p
    padded(i, p+1:cols+p) = img_gray(1, :);
    padded(rows+p+i, p+1:cols+p) = img_gray(rows, :);
end
for j = 1:p
    padded(:, j) = padded(:, p+1);
    padded(:, cols+p+j) = padded(:, cols+p);
end

grad_mag = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        gx = 0; gy = 0;
        for ki = 1:3
            for kj = 1:3
                gx = gx + padded(i+ki-1, j+kj-1) * w_x(ki, kj);
                gy = gy + padded(i+ki-1, j+kj-1) * w_y(ki, kj);
            end
        end
        
        grad_mag(i,j) = abs(gx) + abs(gy);
    end
end

figure(1);
subplot(1,2,1); imshow(uint8(img_gray)); 
title('3.51(a) Original Contact Lens');
subplot(1,2,2); imshow(uint8(grad_mag)); 
title('3.51(b) Sobel Gradient Magnitude');