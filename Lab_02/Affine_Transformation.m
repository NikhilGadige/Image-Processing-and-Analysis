clc;
clear;
close all;
%% Taking the Image as input
[file, path] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select an Image');
if isequal(file,0)
    disp('No image selected');
    return;
end
img = imread(fullfile(path, file));
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
[H, W] = size(img);
%% inputs for the parameters
sx  = input('Horizontal scaling factor: ');
sy  = input('Vertical scaling factor: ');
theta = input('Rotation angle (degrees): ');
tx  = input('Horizontal translation: ');
ty  = input('Vertical translation: ');
shx = input('Horizontal shear factor: ');
shy = input('Vertical shear factor: ');
theta = deg2rad(theta);
%% matrices for transformation
S = [ sx   0   0
      0   sy   0
      0    0   1 ];
Sh = [ 1   shx   0
      shy   1    0
       0    0    1 ];
R = [ cos(theta)  -sin(theta)   0
      sin(theta)   cos(theta)   0
           0            0       1 ];
T = [ 1   0   tx
      0   1   ty
      0   0    1 ];
M = T * R * Sh * S; %% composite matrix
M_inv = inv(M); %% inverse matrix
output = zeros(H, W); %% output image
%% affine transformation applied
for y = 1:H
    for x = 1:W
        src = M_inv * [x; y; 1];
        src_x = round(src(1));
        src_y = round(src(2));
        if src_x >= 1 && src_x <= W && src_y >= 1 && src_y <= H
            output(y, x) = img(src_y, src_x);
        end
    end
end
%% displayed result
figure;
subplot(1,2,1);
imshow(uint8(img));
title('Original Image');
subplot(1,2,2);
imshow(uint8(output));
title('Affine Transformed Image');