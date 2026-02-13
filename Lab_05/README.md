# Problem Statement:

In this assignment, we are asked to estimate the type of noise present in a set of given images and to restore the images using appropriate spatial-domain and frequency-domain filtering techniques. The quality of the restored images is then evaluated using PSNR-type quality metrics. 
The objectives include estimation of the type of noise present in the given images (Images 1 to 7), apply suitable spatial-domain and frequency-domain filters for denoising based on the estimated noise type, understand the effect of different noise models on image quality and quantitatively evaluate the performance of image restoration techniques using PSNR. 

## Running Instructions

1. Compile the matlab script file and keep it with the folder “Lab_5_images”containing all the images and a folder named “output_histograms” to store the generated histograms.
2. Then, Run the script.
3. The corresponding histograms and results (noise_type and PSNR) are displayed.

# Conclusion

The experiment successfully implements histogram-based noise estimation followed by both spatial-domain and frequency-domain filtering for image restoration. Based on histogram characteristics and frequency spectrum analysis, Images 1–5 were classified as Random noise, Image 6 as Salt & Pepper noise, and Image 7 as Periodic noise.
For each noisy image, both spatial filtering (mean/median filter) and frequency filtering (low-pass/notch filter) were applied. The PSNR values indicate that for random noise, spatial and frequency filtering yield comparable performance. For Salt & Pepper noise, spatial median filtering significantly outperforms frequency filtering. For periodic noise, frequency-domain notch filtering is specifically applied, demonstrating the necessity of frequency-based techniques for structured interference.

## Justification of Noise Classification and Result Validity:

Although the textbook introduces Gaussian, Rayleigh, Erlang, Exponential, and Uniform noise as distinct theoretical distributions, these noise types exhibit similar broadband behavior once superimposed on image content. When only the noisy image is available, histogram-based estimation cannot reliably separate these distributions due to overlapping statistical characteristics. Therefore, Images 1–5 were grouped under the broader category of Random noise based on their similar histogram shapes and absence of impulse or periodic characteristics.
Salt & Pepper noise was distinctly identified due to the presence of strong intensity impulses at extreme gray levels, clearly visible in the histogram. Periodic noise was detected through dominant peaks in the Fourier spectrum, which is a well-established method for identifying sinusoidal interference.
The PSNR comparison between spatial and frequency-domain filtering further validates the correctness of the classification:
- Random noise: Similar PSNR values for spatial and frequency filters confirm broadband characteristics.
- Salt & Pepper noise: Higher PSNR for spatial median filtering confirms its suitability for impulse noise.
- Periodic noise: Frequency-domain notch filtering is specifically designed for structured sinusoidal components.

Since the applied filtering methods align with theoretical expectations and produce consistent quantitative improvements, the results are experimentally valid.