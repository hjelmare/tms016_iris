close all;
clear;
clc;

%Fetching image and processing
B = importdata('Iris Images/S1178L05.jpg');
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
plotcircle(centermax(1),centermax(2),centermax(3));

%Finding iris
[x0,y0,r] = iris(A,centermax(1),centermax(2),centermax(3));
plotcircle(x0,y0,r);

