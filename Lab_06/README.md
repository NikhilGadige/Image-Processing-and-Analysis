# Color Image Processing Demo (MATLAB)

This folder contains a MATLAB script `color_image_processing.m` that demonstrates a set of classical color-image processing operations on an input RGB image.

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

## 🔧 How to run

1. Open MATLAB and set the current folder to this repository (`d:\Lab_6`).
2. Make sure `butterfly.jpeg` is present in the folder (or update the script to load your image).
3. Run:

```matlab
color_image_processing
```

The script will display the result images in multiple figure windows (4 images per window).

## ✅ Requirements

- MATLAB (tested on modern versions with Image Processing functions)
- A color JPEG image file named `butterfly.jpeg` in the same folder (or update the filename in the script)



