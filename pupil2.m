close all;
clear;
clc;

%Fetching image and processing
B = importdata('eye2.jpg');
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

