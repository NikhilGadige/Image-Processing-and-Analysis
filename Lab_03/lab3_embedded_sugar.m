img_raw = imread('DIP3E_Original_Images_CH03/Fig0326(a)(embedded_square_noisy_512).tif');
[rows, cols, channels] = size(img_raw);
if channels == 3
   img_gray = zeros(rows, cols);
   for i = 1:rows
       for j = 1:cols
           img_gray(i,j) = 0.299*double(img_raw(i,j,1)) + ...
                           0.587*double(img_raw(i,j,2)) + ...
                           0.114*double(img_raw(i,j,3));
       end
   end
else
   img_gray = double(img_raw);
end
total_sum = 0;
for i = 1:rows
   for j = 1:cols
       total_sum = total_sum + img_gray(i,j);
   end
end
mG = total_sum / (rows * cols);
sq_diff_sum = 0;
for i = 1:rows
   for j = 1:cols
       sq_diff_sum = sq_diff_sum + (img_gray(i,j) - mG)^2;
   end
end
sigmaG = sqrt(sq_diff_sum / (rows * cols));
figure(1); imshow(uint8(img_gray)); title('3.26(a) Original');
h_global = zeros(256, 1);
for i = 1:rows
   for j = 1:cols
       val = floor(img_gray(i,j)) + 1;
       if val > 256, val = 256; end
       h_global(val) = h_global(val) + 1;
   end
end
pdf_global = h_global / (rows * cols);
cdf_global = zeros(256, 1);
curr_sum = 0;
for i = 1:256
   curr_sum = curr_sum + pdf_global(i);
   cdf_global(i) = curr_sum;
end
T_global = round(cdf_global * 255);
img_global = zeros(rows, cols);
for i = 1:rows
   for j = 1:cols
       val = floor(img_gray(i,j)) + 1;
       if val > 256, val = 256; end
       img_global(i,j) = T_global(val);
   end
end
figure(2); imshow(uint8(img_global)); title('3.26(b) Global Equalization');
window_size = 3;
p = floor(window_size/2);
img_padded = zeros(rows + 2*p, cols + 2*p);
img_padded(p+1:rows+p, p+1:cols+p) = img_gray;
for i = 1:p
   img_padded(i, p+1:cols+p) = img_gray(1, :);
   img_padded(rows+p+i, p+1:cols+p) = img_gray(rows, :);
end
for j = 1:p
   img_padded(:, j) = img_padded(:, p+1);
   img_padded(:, cols+p+j) = img_padded(:, cols+p);
end
img_local = zeros(rows, cols);
for i = 1:rows
   for j = 1:cols
      
       neighborhood = img_padded(i:i+window_size-1, j:j+window_size-1);
       center_pixel = img_gray(i,j);
      
      
       smaller_count = 0;
       for ni = 1:window_size
           for nj = 1:window_size
               if neighborhood(ni,nj) <= center_pixel
                   smaller_count = smaller_count + 1;
               end
           end
       end
       img_local(i,j) = (smaller_count / (window_size^2)) * 255;
   end
end
figure(3); imshow(uint8(img_local)); title('3.26(c) Local Equalization');
C = 22.8; k0 = 0; k1 = 0.1; k2 = 0; k3 = 0.1;
img_stat_enhanced = img_gray;
for i = 1:rows
   for j = 1:cols
      
       sum_nb = 0;
       for ni = 0:window_size-1
           for nj = 0:window_size-1
               sum_nb = sum_nb + img_padded(i+ni, j+nj);
           end
       end
       ms_xy = sum_nb / (window_size^2);
      
       sq_diff_nb = 0;
       for ni = 0:window_size-1
           for nj = 0:window_size-1
               sq_diff_nb = sq_diff_nb + (img_padded(i+ni, j+nj) - ms_xy)^2;
           end
       end
       sigmaS_xy = sqrt(sq_diff_nb / (window_size^2));
      
      
       if (ms_xy >= k0*mG && ms_xy <= k1*mG) && ...
          (sigmaS_xy >= k2*sigmaG && sigmaS_xy <= k3*sigmaG)
           img_stat_enhanced(i,j) = C * img_gray(i,j);
       end
   end
end
figure(4); imshow(uint8(img_stat_enhanced)); title('3.27(b) Local Statistics');
