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


%Circle parameters
rmax = 70;
rmin = 30;
dr=2;
nbr_circles = (rmax - rmin)/dr + 1;

figure
imshow(B);
hold on

%Image sweep parameters
dpix = 2;
xmin = 160;
xmax = 200;
ymin = 130;
ymax = 180;
npix = ceil((xmax-xmin)*(ymax-ymin)/dpix);
centermax = zeros(npix,4);

iCent = 1;
for ix = xmin:dpix:xmax
    for iy = ymin:dpix:ymax
        centermax(iCent,:) = cedgefinder(ix,iy,rmin,rmax,dr,nbr_circles,A);
        iCent = iCent + 1;
    end
end

%Finding highest derivative
[~,nbr] = max(centermax(:,1));
centermax = centermax(nbr,2:4);

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

