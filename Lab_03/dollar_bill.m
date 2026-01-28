clc;
clear;
close all;

img = imread('DIP3E_Original_Images_CH03/Fig0314(a)(100-dollars).tif');   

if size(img,3) == 3
    img = rgb2gray(img);
end

img = uint8(img);   

figure('Color','w','Position',[100 50 1400 700]);

subplot(3,3,1);
imshow(img);
title('(a) Original Image','FontWeight','bold');
axis off;

labels = {'(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)'};

idx = 2;
for k = 8:-1:1
    bit_plane = bitget(img, k);     
    bit_plane = uint8(bit_plane * 255); 

    subplot(3,3,idx);
    imshow(bit_plane);
    title([labels{idx-1} '  Bit Plane ' num2str(k)], ...
          'FontWeight','bold','FontSize',10);
    axis off;

    idx = idx + 1;
end

sgtitle('FIGURE 3.14  Bit-Plane Slicing of an 8-bit Image', ...
        'FontWeight','bold','FontSize',14);
