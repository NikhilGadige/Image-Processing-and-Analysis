clc;
clear;
close all;

folder = 'Lab_5_images';
output_folder = 'output_histograms';

% ground truth
f_true = double(imread(fullfile(folder,'0.tif')));
[M0,N0] = size(f_true);

fprintf('\nLAB 5 IMAGE RESTORATION RESULTS :\n');

for k = 1:7
    % loading the noisy images
    g = double(imread(fullfile(folder, sprintf('%d.tif',k))));
    [M,N] = size(g);
    % histogram
    L = 256;
    histI = zeros(1,L);
    for i = 1:M
        for j = 1:N
            histI(round(g(i,j))+1) = histI(round(g(i,j))+1) + 1;
        end
    end
    histI = histI / (M*N);
    figure;
    stem(0:255, histI,'filled');
    title(['Histogram of ', num2str(k), '.tif']);
    xlabel('Intensity');
    ylabel('Probability');
    grid on;
    saveas(gcf, fullfile(output_folder,...
        ['histogram_',num2str(k),'.png']));
    % estimate noise
    impulse_ratio = histI(1) + histI(256);
    G = abs(fftshift(fft2(g)));
    G(round(M/2-5):round(M/2+5), round(N/2-5):round(N/2+5)) = 0;
    peak_ratio = max(G(:)) / (mean(G(:)) + eps);
    if peak_ratio > 200
        noiseType = 'Periodic';
    elseif impulse_ratio > 0.05
        noiseType = 'Salt & Pepper';
    else
        noiseType = 'Random';
    end
    % using spatial filter
    w = 3;
    r = floor(w/2);
    F_spatial = g;
    if strcmp(noiseType,'Salt & Pepper')
        % median filter
        for i = 1+r:M-r
            for j = 1+r:N-r
                window = [];
                for m = -r:r
                    for n1 = -r:r
                        window(end+1) = g(i+m,j+n1);
                    end
                end
                window = sort(window);
                F_spatial(i,j) = window(ceil(end/2));
            end
        end
    else
        % mean filter
        for i = 1+r:M-r
            for j = 1+r:N-r
                s = 0;
                for m = -r:r
                    for n1 = -r:r
                        s = s + g(i+m,j+n1);
                    end
                end
                F_spatial(i,j) = s/(w*w);
            end
        end
    end
    % frequency filter
    Gf = fftshift(fft2(g));
    H = ones(M,N);
    if strcmp(noiseType,'Periodic')
        % notch filter
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
    else
        % ideal low-pass filter
        D0 = 40;
        for u = 1:M
            for v = 1:N
                D = sqrt((u-M/2)^2 + (v-N/2)^2);
                if D > D0
                    H(u,v) = 0;
                end
            end
        end
    end
    F_freq = real(ifft2(ifftshift(Gf .* H)));
    % PSNR calculation
    Mmin = min(M0,M);
    Nmin = min(N0,N);
    f_crop = f_true(1:Mmin,1:Nmin);
    F_sp_crop = F_spatial(1:Mmin,1:Nmin);
    F_fr_crop = F_freq(1:Mmin,1:Nmin);
    mse_spatial = mean((f_crop(:) - F_sp_crop(:)).^2);
    mse_freq    = mean((f_crop(:) - F_fr_crop(:)).^2);
    psnr_spatial = 10*log10((255^2)/mse_spatial);
    psnr_freq    = 10*log10((255^2)/mse_freq);
    fprintf('Image: %d.tif -> Noise: %-12s -> PSNR Spatial: %6.2f dB and PSNR Freq: %6.2f dB\n',...
        k, noiseType, psnr_spatial, psnr_freq);
end

fprintf('Processing completed successfully.\n');