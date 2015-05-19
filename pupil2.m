close all;
clear;
clc;

%Fetching image and processing
fileName = 'eyeSmallPupil';
B = importdata([fileName '.jpg']);
A = B;
A = im2double(A);

%Plotting image
figure
imshow(B);
hold on

%Circle parameters
rmax = 70;
rmin = 30;
[x, y] = GetPupilLocation(A);

%Finding pupil inside search area
centermax = cedgefinder(x,y,rmin,rmax,A);
xCenter_p = centermax(1);
yCenter_p = centermax(2);
r_p = centermax(3);

%Plotting found circle
plotcircle(xCenter_p, yCenter_p, r_p);

[xCenter_s, yCenter_s, r_s] = iris(A, xCenter_p, yCenter_p, r_p);

plotcircle(xCenter_s, yCenter_s, r_s)



%-----------------------unwrapping of iris-------------------------------
uImage = unwrap(A, r_p, r_s, [xCenter_p, yCenter_p], [xCenter_s, yCenter_s], [100 300]);
figure(2)
imshow(uImage)

alpha = [pi pi/100 pi/20 pi/5];
beta = alpha;
omega = 3./beta;

% %for i = 1:length(alpha)
% %    for j = 1:length(beta)
%         waveletParams = [alpha; beta; omega];
%         position = [uImage(1,1) uImage(1,2)];
%         [ReH, ImH] = WaveletIntegral(waveletParams, position, uImage)
% %    end
% %end

%%
im = uImage;
nscale = 1;
minWaveLength = pi/20;
mult = 2;
sigmaOnf = 10;

[E0, filtersum] = gaborconvolve(im, nscale, minWaveLength, mult, sigmaOnf);

E1 = E0{1};
%Phase quantisation
H1 = real(E1) > 0;
H2 = imag(E1) > 0;

[lengthIm, hightIm] = size(E1);
template = zeros(lengthIm*2, hightIm);
for i = 1:2:hightIm
    template(1:lengthIm, i) = H1(:,i);
    template(lengthIm+1:end ,i) = H2(:,i);
end

figure(3)
imshow(template)

save(['irisTemplates/' fileName], 'template')

