clc;
clear;
close all;

% step1: generating image
M = 64;
N = 64;
img = zeros(M, N);
% user inputs
x0 = input('Enter top-left row index (0–63): ');
y0 = input('Enter top-left column index (0–63): ');
w  = input('Enter rectangle width: ');
h  = input('Enter rectangle height: ');
theta_deg = input('Enter rotation angle (degrees): ');
theta = theta_deg * pi / 180;
% rectangle center
xc = x0 + h/2;
yc = y0 + w/2;
for x = 0:M-1
    for y = 0:N-1
        xp = x + 0.5;
        yp = y + 0.5;
        % inverse rotation
        xr =  (xp - xc)*cos(theta) + (yp - yc)*sin(theta);
        yr = -(xp - xc)*sin(theta) + (yp - yc)*cos(theta);
        if abs(xr) <= h/2 && abs(yr) <= w/2
            img(x+1, y+1) = 1;
        end
    end
end
figure;
imshow(img, []);
title('Input Image for FFT Analysis');

% step2: uncentered 2D fft
FFT_img = fft2(img);
figure;
imshow(log(1 + abs(FFT_img)), []);
title('Magnitude Spectrum using FFT (Uncentered)');

% step3: centered fft
FFT_centered = fftshift(FFT_img);
figure;
imshow(log(1 + abs(FFT_centered)), []);
title('Magnitude Spectrum using FFT (Centered)');