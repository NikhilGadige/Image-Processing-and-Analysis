clc;
clear;
close all;

%% Taking the Image as input
[file, path] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select an Image');
img = imread(fullfile(path, file));
% Grayscale conversion
if ndims(img) == 3
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    img = uint8(0.2989*double(R) + 0.5870*double(G) + 0.1140*double(B));
end
figure;
imshow(img);
title('Input Grayscale Image');

%% Central square cropping
[M, N] = size(img);
side = min(M, N);
rs = floor((M - side)/2) + 1;
cs = floor((N - side)/2) + 1;
img_crop = img(rs:rs+side-1, cs:cs+side-1);

%% Spatial Resolution
disp('Select Spatial Resolution');
disp('0 : 100 x 100');
disp('1 : 200 x 200');
disp('2 : 400 x 400');
disp('3 : 800 x 800');
s_idx = input('Enter choice (0-3): ');
resolutions = [100 200 400 800];
new_size = resolutions(s_idx+1);
step = side / new_size;
img_sampled = zeros(new_size, new_size);
for i = 1:new_size
    for j = 1:new_size
        x = round((i-0.5)*step + 0.5);
        y = round((j-0.5)*step + 0.5);
        img_sampled(i,j) = img_crop(x,y);
    end
end
img_sampled = uint8(img_sampled);

%% Intensity Resolution
disp('Select Intensity Resolution');
disp('0 : 1 bit (2 levels)');
disp('1 : 2 bits (4 levels)');
disp('2 : 4 bits (16 levels)');
disp('3 : 8 bits (256 levels)');
i_idx = input('Enter choice (0-3): ');
bit_depths = [1 2 4 8];
bits = bit_depths(i_idx+1);
levels = 2^bits;
img_quant = zeros(new_size, new_size);
for i = 1:new_size
    for j = 1:new_size
        p = img_sampled(i,j);
        q = floor(double(p) * levels / 256);
        img_quant(i,j) = q * (256 / levels);
    end
end
img_quant = uint8(img_quant);

%% Header
% [ S1 S0 I1 I0 ]
header = s_idx * 4 + i_idx;   % fits in 4 bits (0–15)

%% Making the binary file
fid = fopen('encoded_image.bin', 'wb');
fwrite(fid, header, 'uint8');         % Header
fwrite(fid, new_size, 'uint16');      % Image size
fwrite(fid, img_quant(:), 'uint8');   % Pixel data (linear stream)
fclose(fid);
disp('Encoding complete. Custom binary file created.');
