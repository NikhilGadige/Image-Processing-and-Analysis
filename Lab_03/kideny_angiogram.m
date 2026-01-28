clc;
clear;
close all;

img = imread('DIP3E_Original_Images_CH03/Fig0312(a)(kidney).tif');

if size(img,3) == 3
    img = rgb2gray(img);
end

img = im2double(img);

A = 0.55;
B = 0.95;

binary_slice = zeros(size(img));
binary_slice(img >= A & img <= B) = 1;

slice_no_bg = img;
slice_no_bg(img >= A & img <= B) = 1;
slice_no_bg(img < A | img > B) = slice_no_bg(img < A | img > B) * 0.4;

figure('Position', [100 100 1200 400]);  

subplot(1,3,1);
imshow(img);
title('(a) Original Aortic Angiogram','FontSize',10);

subplot(1,3,2);
imshow(binary_slice);
title('(b) Binary Intensity-Level Slicing','FontSize',10);

subplot(1,3,3);
imshow(slice_no_bg);
title('(c) Slicing without Background Suppression','FontSize',10);

sgtitle('Intensity-Level Slicing Results','FontSize',12,'FontWeight','bold');
