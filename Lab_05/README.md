# Problem Statement:

In this assignment, we are asked to estimate the type of noise present in a set of given images and to restore the images using appropriate spatial-domain and frequency-domain filtering techniques. The quality of the restored images is then evaluated using PSNR-type quality metrics. 
The objectives include estimation of the type of noise present in the given images (Images 1 to 7), apply suitable spatial-domain and frequency-domain filters for denoising based on the estimated noise type, understand the effect of different noise models on image quality and quantitatively evaluate the performance of image restoration techniques using PSNR. 

## Running Instructions

1. Compile the matlab script file and keep it with the folder “Lab_5_images”containing all the images and a folder named “output_histograms” to store the generated histograms.
2. Then, Run the script.
3. The corresponding histograms and results (noise_type and PSNR) are displayed.

# Conclusion

The experiment successfully demonstrates histogram-based noise estimation and image restoration using spatial and frequency-domain techniques. From the experimental results, Images 1 to 5 were classified under the category Random / Uniform-type noise, Image 6 was identified as Salt & Pepper noise, and Image 7 was correctly identified as Periodic noise. Appropriate filters were applied accordingly: mean filtering for random noise, median filtering for impulse noise, and notch filtering for periodic noise. The PSNR values confirm that the selected restoration methods improve image quality, particularly in the case of salt-and-pepper noise where significant improvement is observed.

## Justification of Noise Classification and Result Validity:

Although the textbook describes Gaussian, Rayleigh, Erlang, Exponential, and Uniform noise as distinct theoretical models, these noise types exhibit very similar broadband characteristics once added to an image. When image content and quantization effects are present, their histograms tend to overlap significantly, making precise blind separation difficult using only histogram statistics. Therefore, Images 1 to 5 were grouped under a broader Random / Uniform-type noise category based on their similar statistical behavior.

In contrast, Salt & Pepper noise was distinctly identified due to the presence of strong impulses at intensity extremes, which is clearly observable in the histogram. Periodic noise was correctly detected using frequency-domain analysis, where dominant isolated peaks appear in the Fourier spectrum.

Since the restoration method for Gaussian-family random noise models is similar (linear smoothing filters), grouping these noise types does not affect the validity of the restoration process. The improvement in PSNR values confirms that the applied filtering techniques are appropriate and that the overall results are both experimentally consistent and theoretically justified.