clc; clear; close all;
M = 256;
N = 256;
ramp = repmat(linspace(0,1,N), M, 1);
gamma_display = 2.5;
img_gamma_displayed = ramp .^ gamma_display;
gamma_correction = 1 / gamma_display;
gamma_corrected = ramp .^ gamma_correction;
gamma_corrected_displayed = gamma_corrected .^ gamma_display;
figure;

subplot(2,2,1);
imshow(ramp);
title('(a) Original Intensity Ramp');

subplot(2,2,2);
imshow(img_gamma_displayed);
title('(b) Viewed on Monitor (\gamma = 2.5)');

subplot(2,2,3);
imshow(gamma_corrected);
title('(c) Gamma Corrected Image');

subplot(2,2,4);
imshow(gamma_corrected_displayed);
title('(d) Corrected Image on Same Monitor');
