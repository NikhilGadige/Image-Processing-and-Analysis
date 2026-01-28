clc;
clear;
close all;

img = imread('DIP3E_Original_Images_CH03/Fig0326(a)(embedded_square_noisy_512).tif');  

if size(img,3) == 3
    img = rgb2gray(img);
end

img = im2double(img);  

figure('Color','w','Position',[100 100 1200 400]);

subplot(1,3,1);
imshow(img);
title('(a) Original Image','FontWeight','bold');
axis off;

global_eq = histeq(img);

subplot(1,3,2);
imshow(global_eq);
title('(b) Global Histogram Equalization','FontWeight','bold');
axis off;

window = 7;   

global_mean = mean(img(:));
global_std  = std(img(:));

E = 4;       
k0 = 0.4;
k1 = 0.02;
k2 = 0.4;

pad = floor(window/2);
img_pad = padarray(img,[pad pad],'symmetric');

local_enhanced = img;

for i = 1:size(img,1)
    for j = 1:size(img,2)

        Sxy = img_pad(i:i+window-1, j:j+window-1);

        local_mean = mean(Sxy(:));
        local_std  = std(Sxy(:));

        if (local_mean <= k0*global_mean) && ...
           (local_std >= k1*global_std) && ...
           (local_std <= k2*global_std)

            local_enhanced(i,j) = E * img(i,j);
        end
    end
end

local_enhanced = min(max(local_enhanced,0),1);

subplot(1,3,3);
imshow(local_enhanced);
title('(c) Local Histogram Enhancement','FontWeight','bold');
axis off;

sgtitle('FIGURE 3.26  Histogram Statistics for Image Enhancement', ...
        'FontWeight','bold');
