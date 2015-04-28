close all;
clear;
clc;

%Fetching image and processing
B = importdata('S1249R02.jpg');
A = B;
A = im2double(A);
A(A>0.75) = 0;
A(A<0.25) = 0;
A = gaussfilt(A,5,10);

%Plotting image
figure
imshow(B);
hold on

%Circle parameters
rmax = 70;
rmin = 30;
xmin = 130;
xmax = 200;
ymin = 110;
ymax = 180;

%Finding pupil inside search area
centermax = cedgefinder2([xmin,xmax],[ymin,ymax],rmin,rmax,A);

%Plotting found circle
nbr_points = 360;
dPhi = 2*pi/nbr_points;
circle = zeros(nbr_points,2);
for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = centermax(2) + round(centermax(3)*cos(phi));
        circle(iPhi,1) = centermax(1) + round(centermax(3)*sin(phi));
end

plot(circle(:,1),circle(:,2),'b')
plot(centermax(1),centermax(2),'rx')

