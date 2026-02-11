clc;
clear;
close all;

folder = 'Lab_5_images';
output_folder = 'output_histograms';

% 0.tif ground truth for PSNR
f_true = double(imread(fullfile(folder,'0.tif')));
[M0,N0] = size(f_true);

fprintf('\nImage Noise Estimation and PSNR Calculation Results:\n');

for k = 1:7
    % noisy images loaded
    g = double(imread(fullfile(folder, sprintf('%d.tif',k))));
    [M,N] = size(g);
    % compute their histograms
    L = 256;
    histI = zeros(1,L);
    for i = 1:M
        for j = 1:N
            histI(round(g(i,j))+1) = histI(round(g(i,j))+1) + 1;
        end
    end
    histI = histI / (M*N);
    % display generated histograms
    figure;
    stem(0:255, histI,'filled');
    title(['Histogram of ', num2str(k), '.tif']);
    xlabel('Intensity');
    ylabel('Probability');
    grid on;
    saveas(gcf, fullfile(output_folder, ...
        ['histogram_', num2str(k), '.png']));

    % estimate the noise
    impulse_ratio = histI(1) + histI(256);
    % detect periodic
    G = abs(fftshift(fft2(g)));
    G(round(M/2-5):round(M/2+5), round(N/2-5):round(N/2+5)) = 0;
    max_peak = max(G(:));
    mean_energy = mean(G(:));
    peak_ratio = max_peak / (mean_energy + eps);
    if peak_ratio > 200
        noiseType = 'Periodic';
    elseif impulse_ratio > 0.05
        noiseType = 'Salt & Pepper';
    else
        % classify
        z = 0:255;
        mean_val = sum(z .* histI);
        var_val  = sum((z - mean_val).^2 .* histI);
        skew_val = sum((z - mean_val).^3 .* histI) / (var_val^(3/2) + eps);
        kurt_val = sum((z - mean_val).^4 .* histI) / (var_val^2 + eps);
        if abs(skew_val) < 0.3 && kurt_val > 2.5
            noiseType = 'Gaussian';
        elseif abs(skew_val) < 0.3 && kurt_val < 2.2
            noiseType = 'Uniform';
        elseif skew_val > 1.2
            noiseType = 'Exponential';
        elseif skew_val > 0.5
            noiseType = 'Rayleigh / Erlang';
        else
            noiseType = 'Uniform / Random';
        end
    end
    % filtering
    w = 3;
    r = floor(w/2);
    F = g;
    if strcmp(noiseType,'Salt & Pepper')
        % median Filter
        for i = 1+r:M-r
            for j = 1+r:N-r
                window = [];
                for m = -r:r
                    for n1 = -r:r
                        window(end+1) = g(i+m,j+n1);
                    end
                end
                window = sort(window);
                F(i,j) = window(ceil(end/2));
            end
        end
    elseif strcmp(noiseType,'Periodic')
        % notch filter
        G = fftshift(fft2(g));
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
        % mean filter
        for i = 1+r:M-r
            for j = 1+r:N-r
                s = 0;
                for m = -r:r
                    for n1 = -r:r
                        s = s + g(i+m,j+n1);
                    end
                end
                F(i,j) = s/(w*w);
            end
        end
    end
    % calculate PSNR
    Mmin = min(M0,M);
    Nmin = min(N0,N);
    f_crop = f_true(1:Mmin,1:Nmin);
    F_crop = F(1:Mmin,1:Nmin);
    mse = mean((f_crop(:) - F_crop(:)).^2);
    psnrVal = 10*log10((255^2)/mse);
    fprintf('Image: %d.tif | Noise: %-20s | PSNR: %6.2f dB\n',...
            k, noiseType, psnrVal);
end

fprintf('Processing completed successfully.\n');