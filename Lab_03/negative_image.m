
img = imread(['DIP3E_Original_Images_CH03/Fig0304(a)(breast_digital_Xray).tif']);
if size(img,3) == 3
    img = rgb2gray(img);
end
neg = 255 - img;
figure;
subplot(1,2,1), imshow(img), title('Original Image');
subplot(1,2,2), imshow(neg), title('Negative Image');
