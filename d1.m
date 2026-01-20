clc;
clear;
close all;

%% Reading the binary file 
fid = fopen('encoded_image.bin', 'rb');
if fid == -1
    error('encoded_image.bin not found. Run encoder.m first.');
end
resolutions = [100 200 400 800];
bit_depths = [1 2 4 8];

% REading the header
header = fread(fid, 1, 'uint8');
decoded_s = floor(header / 4);
decoded_i = mod(header, 4);
decoded_res = resolutions(decoded_s+1);
decoded_bits = bit_depths(decoded_i+1);
img_size = fread(fid, 1, 'uint16');
img_data = fread(fid, img_size * img_size, 'uint8');
decoded_img = reshape(img_data, img_size, img_size);
decoded_img = uint8(decoded_img);
fclose(fid);

%% Displaying the final image
disp(['Decoded Spatial Resolution : ', num2str(decoded_res), ' x ', num2str(decoded_res)]);
disp(['Decoded Intensity Depth    : ', num2str(decoded_bits), ' bits']);
figure;
imshow(decoded_img);
title('Decoded Image');
