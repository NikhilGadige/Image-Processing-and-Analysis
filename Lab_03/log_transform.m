
img = imread(['DIP3E_Original_Images_CH03/Fig0305(a)(DFT_no_log).tif']);

if size(img,3) == 3
    img = rgb2gray(img);
end

img = double(img);

c = 1;
log_img = c * log(1 + img);

log_img = log_img / max(log_img(:)) * 255;

log_img = uint8(log_img);

figure;
subplot(1,2,1), imshow(img,[]), title('Original Image');
subplot(1,2,2), imshow(log_img), title('Log Transformed Image');
