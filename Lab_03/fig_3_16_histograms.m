clc; 
clear; 
close all;

files = { %% input images
 'DIP3E_Original_Images_CH03/Fig0316(1)(top_left).tif'
 'DIP3E_Original_Images_CH03/Fig0316(2)(2nd_from_top).tif'
 'DIP3E_Original_Images_CH03/Fig0316(3)(third_from_top).tif'
 'DIP3E_Original_Images_CH03/Fig0316(4)(bottom_left).tif'
};
titles = {'Dark Image','Light Image','Low Contrast','High Contrast'};

for f = 1:4
    img = imread(files{f}); %% load the 4 input images
    if ndims(img) == 3
        R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
        img = uint8(0.2989*double(R) + 0.5870*double(G) + 0.1140*double(B));
    end
    [M,N] = size(img);
    %% make the histogram
    hist = zeros(1,256);
    for i = 1:M
        for j = 1:N
            hist(img(i,j)+1) = hist(img(i,j)+1) + 1;
        end
    end
    hist = hist / (M*N);

    %% Display the four image types with their corresponding histograms
    figure;
    subplot(1,2,1), imshow(img), title(titles{f});
    subplot(1,2,2), stem(0:255,hist,'filled');
    xlabel('Intensity'); ylabel('Probability');
    title('Histogram');
end