clc; 
clear; 
close all;

files = { %% input images
 'DIP3E_Original_Images_CH03/Fig0320(1)(top_left).tif'
 'DIP3E_Original_Images_CH03/Fig0320(2)(2nd_from_top).tif'
 'DIP3E_Original_Images_CH03/Fig0320(3)(third_from_top).tif'
 'DIP3E_Original_Images_CH03/Fig0320(4)(bottom_left).tif'
};

for f = 1:4
    img = imread(files{f}); %% load the 4 input images of left column
    if ndims(img) == 3
        R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
        img = uint8(0.2989*double(R) + 0.5870*double(G) + 0.1140*double(B));
    end
    [M,N] = size(img);
    L = 256;

    %% make the histogram
    hist = zeros(1,256);
    for i = 1:M
        for j = 1:N
            hist(img(i,j)+1) = hist(img(i,j)+1) + 1;
        end
    end
    pdf = hist / (M*N);

    %% CDF
    cdf = zeros(1,256);
    cdf(1) = pdf(1);
    for k = 2:256
        cdf(k) = cdf(k-1) + pdf(k);
    end
    %% transformation as per equation 3.15
    T = zeros(1,256);
    for k = 1:256
        T(k) = round((L-1) * cdf(k));
    end
    %% mapping
    eq = zeros(M,N);
    for i = 1:M
        for j = 1:N
            eq(i,j) = T(img(i,j)+1);
        end
    end
    eq = uint8(eq);
    %% equalized image histogram
    hist_eq = zeros(1,256);
    for i = 1:M
        for j = 1:N
            hist_eq(eq(i,j)+1) = hist_eq(eq(i,j)+1) + 1;
        end
    end
    hist_eq = hist_eq / (M*N);

    %% displaying the four image types with their corresponding histogram-equalized images with their histograms
    figure;
    subplot(1,3,1), imshow(img), title('Original');
    subplot(1,3,2), imshow(eq), title('Equalized');
    subplot(1,3,3), stem(0:255,hist_eq,'filled');
    title('Equalized Histogram');
end