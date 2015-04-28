close all;
clear;
clc;

%Fetching image and processing
B = importdata('eyeSmallPupil.jpg');
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

