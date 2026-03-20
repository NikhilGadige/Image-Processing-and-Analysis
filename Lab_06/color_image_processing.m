clc;
clear;
close all;
%% Load Image
img = imread('butterfly.jpeg');
img = double(img)/255;
img = img(1:4:end,1:4:end,:);
[rows,cols,~] = size(img);
results = {};
titles = {};

% RGB → HSV

function hsv = rgb_to_hsv_manual(rgb)
[r,c,~] = size(rgb);
hsv = zeros(r,c,3);
for i=1:r
for j=1:c
R = rgb(i,j,1);
G = rgb(i,j,2);
B = rgb(i,j,3);
maxv = max([R G B]);
minv = min([R G B]);
d = maxv-minv;
if d==0
H=0;
elseif maxv==R
H=mod((G-B)/d,6);
elseif maxv==G
H=((B-R)/d)+2;
else
H=((R-G)/d)+4;
end
H=H/6;
if maxv==0
S=0;
else
S=d/maxv;
end
V=maxv;
hsv(i,j,:)=[H S V];
end
end
end

% HSV → RGB

function rgb = hsv_to_rgb_manual(hsv)
[r,c,~]=size(hsv);
rgb=zeros(r,c,3);
for i=1:r
for j=1:c
H=hsv(i,j,1)*6;
S=hsv(i,j,2);
V=hsv(i,j,3);
C=V*S;
X=C*(1-abs(mod(H,2)-1));
m=V-C;
if H<1
rp=C;gp=X;bp=0;
elseif H<2
rp=X;gp=C;bp=0;
elseif H<3
rp=0;gp=C;bp=X;
elseif H<4
rp=0;gp=X;bp=C;
elseif H<5
rp=X;gp=0;bp=C;
else
rp=C;gp=0;bp=X;
end
rgb(i,j,:)=[rp+m gp+m bp+m];
end
end
end

% 1. Negative Transformation
% Color Space: RGB
% Reason: invert pixel intensity

neg = 1 - img;
results{end+1} = neg;
titles{end+1} = 'Negative';

% 2. Log Transformation
% Color Space: HSV
% Reason: compress high intensities

hsv = rgb_to_hsv_manual(img);
V = hsv(:,:,3);
V_original = V; 
Vindex = floor(V_original * 255) + 1;
Vlog = log(1+V);
Vlog = Vlog/max(Vlog(:));
hsv(:,:,3)=Vlog;
log_img = hsv_to_rgb_manual(hsv);
results{end+1}=log_img;
titles{end+1}='Log';

% 3. Gamma Transformation
% Color Space: HSV

gamma = 0.5;
V = V_original.^gamma;
hsv(:,:,3)=V;
gamma_img = hsv_to_rgb_manual(hsv);
results{end+1}=gamma_img;
titles{end+1}='Gamma';

% 4. Contrast Stretching

rmin = min(V(:));
rmax = max(V(:));
Vcs = (V - rmin) / (rmax - rmin);
hsv(:,:,3)=Vcs;
contrast_img = hsv_to_rgb_manual(hsv);
results{end+1}=contrast_img;
titles{end+1}='Contrast Stretch';

% 5. Thresholding

T = mean(V(:));
th = V >= T;
results{end+1}=th;
titles{end+1}='Threshold';

% 6. Intensity Level Slicing

A=0.4;
B=0.7;
slice = V;
for i=1:rows
   for j=1:cols
       if V(i,j)>=A && V(i,j)<=B
           slice(i,j) = 1;        
       else
           slice(i,j) = V(i,j);   
       end
   end
end
hsv(:,:,3)=slice;
slice_img = hsv_to_rgb_manual(hsv);
results{end+1}=slice_img;
titles{end+1}='Intensity Slice';

% 7. Bit Plane Slicing

img8 = uint8(img*255);
bit_plane=zeros(rows,cols);
for i=1:rows
for j=1:cols
bit_plane(i,j)=bitget(img8(i,j,1),7);
end
end
results{end+1}=bit_plane;
titles{end+1}='Bit Plane';

% 8. Histogram Computation

hist = zeros(256,1);
for i = 1:rows
for j = 1:cols
idx = Vindex(i,j);
hist(idx) = hist(idx) + 1;
end
end
% Normalizing histogram
hist_norm = hist / max(hist);
% Converting histogram into an image
hist_img = zeros(200,256);
for k = 1:256
height = round(hist_norm(k)*200);
for h = 200-height+1 : 200
hist_img(h,k) = 1;
end
end
% Resizing to match image display size
hist_img = imresize(hist_img,[rows cols]);
results{end+1} = hist_img;
titles{end+1} = 'Histogram';

% 9. Histogram Equalization

pdf=hist/(rows*cols);
cdf=zeros(256,1);
cdf(1)=pdf(1);
for k=2:256
cdf(k)=cdf(k-1)+pdf(k);
end
Ve = zeros(rows,cols);
for i=1:rows
   for j=1:cols
       idx = Vindex(i,j);
       if idx > 256
           idx = 256;
       end
       Ve(i,j) = cdf(idx);
   end
end
hsv(:,:,3)=Ve;
hist_eq = hsv_to_rgb_manual(hsv);
results{end+1}=hist_eq;
titles{end+1}='Histogram Equalization';

% 10. Histogram Specification

target=zeros(256,1);
for z=1:256
target(z)=(z^0.4)*exp(-z/50);
end
target=target/sum(target);
cdf_spec=cumsum(target);
map=zeros(256,1);
for r=1:256
[~,idx]=min(abs(cdf(r)-cdf_spec));
map(r)=(idx-1)/255;
end
Vs=zeros(rows,cols);
for i=1:rows
for j=1:cols
idx = Vindex(i,j);
Vs(i,j)=map(idx);
end
end
hsv(:,:,3)=Vs;
spec_img=hsv_to_rgb_manual(hsv);
results{end+1}=spec_img;
titles{end+1}='Histogram Spec';

% 11. Gaussian Smoothing

kernel=[1 2 1;2 4 2;1 2 1]/16;
blur=zeros(rows,cols,3);
for k=1:3
for i=2:rows-1
for j=2:cols-1
sumv=0;
for m=-1:1
for n=-1:1
sumv=sumv+img(i+m,j+n,k)*kernel(m+2,n+2);
end
end
blur(i,j,k)=sumv;
end
end
end
results{end+1}=blur;
titles{end+1}='Gaussian Blur';

% 12. Median Filter

med=zeros(rows,cols,3);
for k=1:3
for i=2:rows-1
for j=2:cols-1
vec=zeros(9,1);
t=1;
for m=-1:1
for n=-1:1
vec(t)=img(i+m,j+n,k);
t=t+1;
end
end
vec=sort(vec);
med(i,j,k)=vec(5);
end
end
end
results{end+1}=med;
titles{end+1}='Median';

% 13. Laplacian Sharpening
% Color Space: HSV

lap_kernel=[0 1 0;1 -4 1;0 1 0];
lap=zeros(rows,cols);
for i=2:rows-1
for j=2:cols-1
sumv=0;
for m=-1:1
for n=-1:1
sumv=sumv+V(i+m,j+n)*lap_kernel(m+2,n+2);
end
end
lap(i,j)=sumv;
end
end
lap = lap / (max(abs(lap(:))) + 1e-8);
hsv(:,:,3)=lap;
lap_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=lap_rgb;
titles{end+1}='Laplacian';

% 14. Sobel Edge Detection

gx=[-1 0 1;-2 0 2;-1 0 1];
gy=[-1 -2 -1;0 0 0;1 2 1];
sob=zeros(rows,cols);
for i=2:rows-1
for j=2:cols-1
sx=0;
sy=0;
for m=-1:1
for n=-1:1
sx=sx+V(i+m,j+n)*gx(m+2,n+2);
sy=sy+V(i+m,j+n)*gy(m+2,n+2);
end
end
sob(i,j)=abs(sx)+abs(sy);
end
end
sob = sob / (max(sob(:)) + 1e-8);
hsv(:,:,3)=sob;
sob_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=sob_rgb;
titles{end+1}='Sobel';

% 15. GLOBAL HISTOGRAM EQUALIZATION (separate demo)
% Color Space: HSV
% Reason: enhance overall brightness contrast

hsv(:,:,3) = Ve;
global_eq = hsv_to_rgb_manual(hsv);
results{end+1} = global_eq;
titles{end+1} = 'Global Histogram EQ';


% 16. LOCAL HISTOGRAM EQUALIZATION
% Color Space: HSV
% Reason: enhance local contrast

window = 15;
p = floor(window/2);
local_eq = zeros(rows,cols);
for i = 1+p : rows-p
for j = 1+p : cols-p
hist_local = zeros(256,1);
for m = -p:p
for n = -p:p
val = Vindex(i+m,j+n);
hist_local(val) = hist_local(val) + 1;
end
end
cdf_local = cumsum(hist_local)/(window*window);
idx = Vindex(i,j);
local_eq(i,j) = cdf_local(idx);
end
end
% Replacing the V channel
hsv(:,:,3) = local_eq;
% Converting back to RGB
local_eq_rgb = hsv_to_rgb_manual(hsv);
results{end+1} = local_eq_rgb;
titles{end+1} = 'Local Histogram EQ';

% 17. LOCAL STATISTICAL ENHANCEMENT
% Color Space: HSV
% Reason: enhance regions with low local contrast

C=22.8;
k0=0;
k1=0.1;
k2=0;
k3=0.1;
mean_global = mean(V(:));
sigma_global = std(V(:));
stat_img = V;
for i=1+p:rows-p
for j=1+p:cols-p
neigh = V(i-p:i+p,j-p:j+p);
ms = mean(neigh(:));
sig = std(neigh(:));
if (ms>=k0*mean_global && ms<=k1*mean_global) && ...
(sig>=k2*sigma_global && sig<=k3*sigma_global)
stat_img(i,j)=C*V(i,j);
end
end
end
% Normalizing
stat_img = stat_img / max(stat_img(:));
% Replacing V channel
hsv(:,:,3) = stat_img;
% Converting back to RGB
stat_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=stat_rgb;
titles{end+1}='Local Statistical Enhancement';

% 18. LARGE GAUSSIAN BLUR
% Color Space: RGB
% Reason: To simulate blur reduction step

kernel = [1 4 6 4 1;
         4 16 24 16 4;
         6 24 36 24 6;
         4 16 24 16 4;
         1 4 6 4 1];
kernel = kernel/sum(kernel(:));
blur_big = zeros(rows,cols,3);
for k=1:3
for i=3:rows-2
for j=3:cols-2
sumv=0;
for m=-2:2
for n=-2:2
sumv=sumv+img(i+m,j+n,k)*kernel(m+3,n+3);
end
end
blur_big(i,j,k)=sumv;
end
end
end
results{end+1}=blur_big;
titles{end+1}='Large Gaussian Blur';

% 19. UNSHARP MASKING

mask = img - blur_big;
unsharp = img + mask;
results{end+1}=unsharp;
titles{end+1}='Unsharp Mask';

% 20. HIGH BOOST FILTERING

k=4.5;
highboost = img + k*mask;
results{end+1}=highboost;
titles{end+1}='High Boost';

% 21. GRADIENT MAGNITUDE (used in sharpening pipeline)

gx=[-1 0 1;-2 0 2;-1 0 1];
gy=[-1 -2 -1;0 0 0;1 2 1];
grad=zeros(rows,cols);
for i=2:rows-1
for j=2:cols-1
sx=0;
sy=0;
for m=-1:1
for n=-1:1
sx = sx + V_original(i+m,j+n)*gx(m+2,n+2);
sy = sy + V_original(i+m,j+n)*gy(m+2,n+2);
end
end
grad(i,j)=sqrt(sx^2+sy^2);
end
end
grad = grad / (max(grad(:)) + 1e-8);
hsv(:,:,3)=grad;
grad_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=grad_rgb;
titles{end+1}='Gradient Magnitude';

% 22. SMOOTHED GRADIENT

smooth_grad=zeros(rows,cols);
for i=2:rows-1
for j=2:cols-1
sumv=0;
for m=-1:1
for n=-1:1
sumv=sumv + grad(i+m,j+n);
end
end
smooth_grad(i,j) = sumv/9;
end
end
smooth_grad = smooth_grad / (max(smooth_grad(:)) + 1e-8);
hsv(:,:,3)=smooth_grad;
smooth_grad_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=smooth_grad_rgb;
titles{end+1}='Smoothed Gradient';

% 23. MASK IMAGE

mask_img = abs(lap) .* smooth_grad;
mask_img = mask_img - min(mask_img(:));
mask_img = mask_img / (max(mask_img(:)) + 1e-8);
hsv(:,:,3)=mask_img;
mask_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=mask_rgb;
titles{end+1}='Mask Image';

% 24. FINAL GAMMA ENHANCEMENT

gamma=0.5;
enhanced = V_original + mask_img;
final_img = enhanced.^gamma;
final_img = final_img / (max(final_img(:)) + 1e-8);
hsv(:,:,3)=final_img;
final_rgb = hsv_to_rgb_manual(hsv);
results{end+1}=final_rgb;
titles{end+1}='Final Gamma';

% DISPLAYING RESULTS

n=length(results);
fig=1;
for i=1:4:n
figure(fig)
for j=0:3
if (i+j)<=n
subplot(2,2,j+1)
imshow(results{i+j},[])
title(titles{i+j})
end
end
fig=fig+1;
end