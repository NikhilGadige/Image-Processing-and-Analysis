clc; 
clear; 
close all;

%% Load the 3.10 original image  
img = imread('DIP3E_Original_Images_CH03/Fig0310(b)(washed_out_pollen_image).tif');
if ndims(img) == 3
    R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
    img = uint8(0.2989*double(R) + 0.5870*double(G) + 0.1140*double(B));
end
img = double(img);
[M,N] = size(img);
L = 256;

%% finding the r_min and r_max manually
rmin = 255; rmax = 0;
for i = 1:M
    for j = 1:N
        if img(i,j) < rmin, rmin = img(i,j); end
        if img(i,j) > rmax, rmax = img(i,j); end
    end
end

%% Contrast Stretching for the part c of 3.10 of the book image 
cs = zeros(M,N);
for i = 1:M
    for j = 1:N
        cs(i,j) = (img(i,j) - rmin) * (L-1) / (rmax - rmin);
    end
end
cs = uint8(cs);

%% Thresholding using mean for the part d of 3.10 book image
sum_val = 0;
for i = 1:M
    for j = 1:N
        sum_val = sum_val + img(i,j);
    end
end
mean_val = sum_val / (M*N);
th = zeros(M,N);
for i = 1:M
    for j = 1:N
        if img(i,j) >= mean_val
            th(i,j) = 255;
        else
            th(i,j) = 0;
        end
    end
end
th = uint8(th);

%% Displaying the results
figure, imshow(uint8(img)), title('Fig 3.10(b): Original'); %% Input lowcontrast electron microscope image of pollen, magnified 700 times  
figure, imshow(cs), title('Fig 3.10(c): Contrast Stretched'); %% Result of contrast stretching
figure, imshow(th), title('Fig 3.10(d): Thresholded'); %% Result of thresholding. 