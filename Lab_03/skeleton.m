clc;
clear;
close all;

I = imread('DIP3E_Original_Images_CH03/Fig0343(a)(skeleton_orig).tif');   

if size(I,3) == 3
    I = rgb2gray(I);
end

I = im2double(I);

figure;
imshow(I);
title('(a) Original Bone Scan Image');

lap_kernel = [0 -1 0; 
             -1 4 -1; 
              0 -1 0];

lap = imfilter(I, lap_kernel, 'replicate');

lap_disp = mat2gray(lap);  

figure;
imshow(lap_disp);
title('(b) Laplacian of Original Image');

sharp1 = I + lap;
sharp1 = mat2gray(sharp1);

figure;
imshow(sharp1);
title('(c) Sharpened Image: (a) + (b)');

Gx = imfilter(I, fspecial('sobel')'/8, 'replicate');
Gy = imfilter(I, fspecial('sobel')/8, 'replicate');

grad = sqrt(Gx.^2 + Gy.^2);
grad_disp = mat2gray(grad);

figure;
imshow(grad_disp);
title('(d) Sobel Gradient Magnitude');

h = fspecial('average', [5 5]);
grad_smooth = imfilter(grad, h, 'replicate');

grad_smooth = mat2gray(grad_smooth);

figure;
imshow(grad_smooth);
title('(e) Smoothed Sobel Gradient (5×5)');

mask_raw = abs(lap) .* abs(grad_smooth);
mask = mat2gray(mask_raw);

figure;
imshow(mask);
title('(f) Mask Image (Laplacian × Smoothed Gradient)');

sharp2 = I + mask;
sharp2 = mat2gray(sharp2);

figure;
imshow(sharp2);
title('(g) Sharpened Image using Mask');

gamma = 0.5;    
c = 1;

final = c * (sharp2 .^ gamma);
final = mat2gray(final);

figure;
imshow(final);
title('(h) Final Image after Power-law Transformation');
