
filename = 'DIP3E_Original_Images_CH03/Fig0323(a)(mars_moon_phobos).tif';

if exist(filename, 'file')
    img = imread(filename);
else
  
    [X, Y] = meshgrid(1:500, 1:500);
    img = uint8(255 * (X + Y) / 1000); 
    warning('Image file not found. Using synthetic placeholder.');
end

img = double(img);
[rows, cols] = size(img);
n_pixels = rows * cols;


h_orig = histcounts(img, 0:256)'; 
pdf_orig = h_orig / n_pixels;
cdf_orig = cumsum(pdf_orig);

T = round(255 * cdf_orig);

img_equalized = T(uint8(img) + 1);

z = (0:255)';

target_pdf = (z.^0.4) .* exp(-z/50); 
target_pdf = target_pdf / sum(target_pdf); 
cdf_spec = cumsum(target_pdf);


M = zeros(256, 1);
for r = 1:256
    [~, best_z_idx] = min(abs(cdf_orig(r) - cdf_spec));
    M(r) = best_z_idx - 1;
end

img_specified = M(uint8(img) + 1);

figure('Name', 'Histogram Specification Comparison', 'Color', 'w');
subplot(1,3,1); imshow(uint8(img)); title('Original (3.23a)');
subplot(1,3,2); imshow(uint8(img_equalized)); title('Equalized (3.24b)');
subplot(1,3,3); imshow(uint8(img_specified)); title('Specified (3.25c)');