# Problem Statement:

In this assignment, we are asked to recreate all the Image Enhancements of Chapter 3 from the textbook but for colour image, by performing colour image processing.

## 📌 What this script does

The script performs the following operations (using manual implementations where useful):

1. Negative transformation (RGB)
2. Log transformation (HSV value channel)
3. Gamma correction (HSV value channel)
4. Contrast stretching (HSV value channel)
5. Thresholding (binary mask on value channel)
6. Intensity-level slicing (HSV value channel)
7. Bit-plane slicing (red channel)
8. Histogram computation
9. Histogram equalization (HSV value channel)
10. Histogram specification
11. Gaussian smoothing filter
12. Median filter
13. Laplacian sharpening (HSV value channel)
14. Sobel edge detection (HSV value channel)
15. Global histogram equalization demo
16. Local histogram equalization
17. Local statistical enhancement
18. Large Gaussian blur
19. Unsharp masking
20. High boost filtering
21. Gradient magnitude map
22. Smoothed gradient
23. Mask image composition
24. Final gamma enhancement

It also includes manual conversion functions:
- `rgb_to_hsv_manual(rgb)`
- `hsv_to_rgb_manual(hsv)`

## Running Instructions

1. Place the matlab code file “colour_processing.m” with the input image(butterfly.jpeg) in the same folder.
2. Run the Matlab code file.
3. The corresponding results are displayed.