close all;
clear;
clc;

%Fetching image and processing
fileName = 'S1249R02';
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

%Finding pupil
centermax = cedgefinder(x,y,rmin,rmax,A);
xCenter_p = centermax(1);
yCenter_p = centermax(2);
r_p = centermax(3);
plotcircle(xCenter_p, yCenter_p, r_p);

%Finding Iris
[xCenter_s, yCenter_s, r_s] = iris(A, xCenter_p, yCenter_p, r_p);
plotcircle(xCenter_s, yCenter_s, r_s)

%Checking if valid (more or less concentric)
center_distance = sqrt((xCenter_p-xCenter_s)^2 + (yCenter_p-yCenter_s)^2);

if center_distance < 10
    lid = eyelid(A,xCenter_p,yCenter_p,r_p,r_s);
    plot(lid(:,1),'b')
    plot(lid(:,2),'r') 
else
    error('BAD SPECIMEN/TEST')
end



%-----------------------unwrapping of iris-------------------------------
[uImage, mask] = unwrap(A, r_p, r_s, [xCenter_p, yCenter_p], [xCenter_s, yCenter_s], [100 300], lid);
mask = eyelash(uImage,mask);
figure(2)
subplot(2,1,1)
imshow(uImage)
subplot(2,1,2)
imshow(mask)

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

