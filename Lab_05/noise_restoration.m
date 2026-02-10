clc;
clear;
close all;

folder = 'Lab_5_images';

% loading the main image
f = double(imread(fullfile(folder,'0.tif')));
[Mf,Nf] = size(f);

fprintf('\nImage Noise Estimation and PSNR calculating Results:\n');

for k = 1:7
    % loading the images 1-7
    g = double(imread(fullfile(folder, sprintf('%d.tif',k))));
    [Mg,Ng] = size(g);
    % size alignment
    M = min(Mf,Mg);
    N = min(Nf,Ng);
    f2 = f(1:M,1:N);
    g2 = g(1:M,1:N);
    % noise
    n = g2 - f2;
    % Noise histogram
    L = 512;
    offset = L/2;
    h = zeros(1,L);
    for i = 1:M
        for j = 1:N
            idx = round(n(i,j)) + offset + 1;
            if idx >= 1 && idx <= L
                h(idx) = h(idx) + 1;
            end
        end
    end
    h = h / sum(h);
    impulse_ratio = h(1) + h(end);
    % FFT of the noise
    Fn = abs(fftshift(fft2(n)));
    Fn(M/2-5:M/2+5, N/2-5:N/2+5) = 0;   % remove DC
    % conjugate the peak dominance
    sorted_peaks = sort(Fn(:),'descend');
    peak_ratio = sorted_peaks(1) / (sorted_peaks(5) + eps);
    % noise classification
    if peak_ratio > 50
        noiseType = 'Periodic';
    elseif impulse_ratio > 0.02
        noiseType = 'Salt & Pepper';
    else
        noiseType = 'Random (Gaussian-family)';
    end
    % filtering
    w = 3;
    r = floor(w/2);
    F = g2;
    if strcmp(noiseType,'Salt & Pepper')
        % median filter
        for i = 1+r:M-r
            for j = 1+r:N-r
                win = [];
                for m = -r:r
                    for n1 = -r:r
                        win(end+1) = g2(i+m,j+n1);
                    end
                end
                win = sort(win);
                F(i,j) = win(ceil(end/2));
            end
        end
    elseif strcmp(noiseType,'Periodic')
        % notch filter
        G = fftshift(fft2(g2));
        H = ones(M,N);
        D0 = 10;
        for u = 1:M
            for v = 1:N
                D1 = sqrt((u-M/2-30)^2 + (v-N/2-30)^2);
                D2 = sqrt((u-M/2+30)^2 + (v-N/2+30)^2);
                if D1 < D0 || D2 < D0
                    H(u,v) = 0;
                end
            end
        end
        F = real(ifft2(ifftshift(G .* H)));
    else
        % mean filter (for the random noise family)
        for i = 1+r:M-r
            for j = 1+r:N-r
                s = 0;
                for m = -r:r
                    for n1 = -r:r
                        s = s + g2(i+m,j+n1);
                    end
                end
                F(i,j) = s/(w*w);
            end
        end
    end
    % calculating PSNR
    mse = mean((f2(:) - F(:)).^2);
    psnrVal = 10*log10((255^2)/mse);
    fprintf('Image: %d.tif | Noise: %-25s | PSNR: %6.2f dB\n',...
            k, noiseType, psnrVal);
end
fprintf('Processing completed successfully.\n');