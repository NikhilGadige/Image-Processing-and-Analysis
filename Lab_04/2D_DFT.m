clc;
clear;
close all;

% step1: generating the basis of an 8×8 2-D DFT and display it as a 64×64 image
N = 8;
basis_img = zeros(N*N, N*N);
for u = 0:N-1
    for v = 0:N-1
        basis = zeros(N, N);
        for x = 0:N-1
            for y = 0:N-1
                basis(x+1, y+1) = exp(-1j*2*pi*(u*x/N + v*y/N));
            end
        end
        % placing basis magnitude into 64x64 image
        row = u*N + 1;
        col = v*N + 1;
        basis_img(row:row+N-1, col:col+N-1) = abs(basis);
    end
end
figure;
imshow(mat2gray(basis_img));
title('8×8 2-D DFT Basis Functions (64×64)');

% step2: creating a binary 64×64 image containing a rectangle
M = 64; 
N = 64;
img = zeros(M, N);
% user inputs
x0 = input('Enter top-left row index (0-63): ');
y0 = input('Enter top-left column index (0-63): ');
w  = input('Enter rectangle width: ');
h  = input('Enter rectangle height: ');
% creating rectangle
img(x0+1:x0+h, y0+1:y0+w) = 1;
figure;
imshow(img);
title('Binary Rectangle Image');

% step3: Compute and plot the 2-D DFT for the image from step2
DFT = zeros(M, N);
for u = 0:M-1
    for v = 0:N-1
        sum_val = 0;
        for x = 0:M-1
            for y = 0:N-1
                sum_val = sum_val + img(x+1,y+1) * ...
                    exp(-1j*2*pi*(u*x/M + v*y/N));
            end
        end
        DFT(u+1,v+1) = sum_val;
    end
end
figure;
imshow(log(1 + abs(DFT)), []);
title('Magnitude Spectrum (Uncentered DFT)');

% step4: Compute and plot the 2-D DFT for the centered image
centered_img = zeros(M,N);
for x = 0:M-1
    for y = 0:N-1
        centered_img(x+1,y+1) = img(x+1,y+1) * (-1)^(x+y);
    end
end
DFT_centered = zeros(M, N);
for u = 0:M-1
    for v = 0:N-1
        sum_val = 0;
        for x = 0:M-1
            for y = 0:N-1
                sum_val = sum_val + centered_img(x+1,y+1) * ...
                    exp(-1j*2*pi*(u*x/M + v*y/N));
            end
        end
        DFT_centered(u+1,v+1) = sum_val;
    end
end
figure;
imshow(log(1 + abs(DFT_centered)), []);
title('Magnitude Spectrum (Centered DFT)');