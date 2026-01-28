clc; clear; close all;

img = imread('DIP3E_Original_Images_CH03/Fig0309(a)(washed_out_aerial_image).tif');  
if size(img,3) == 3
    img = rgb2gray(img);
end

img = im2double(img);

gamma_values = [3.0 4.0 5.0];
c = 1;

figure;

subplot(2,2,1);
imshow(img);
title('(a) Original Aerial Image');

for i = 1:length(gamma_values)
    gamma = gamma_values(i);
    gamma_img = c * (img .^ gamma);

    subplot(2,2,i+1);
    imshow(gamma_img);
    title(['(\gamma = ', num2str(gamma), ')']);
end
