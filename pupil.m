clear;
clc;

A = importdata('S1249R02.jpg');
A(A>230) = 0;

%Manual approx center in pupil
center = [156,187];

%Circle parameters
maxr = 70;
minr = 30;
dr=5;
nbr_circles = (maxr - minr)/dr + 1;
nbr_points = 360;
dPhi = 2*pi/nbr_points;

imshow(A);
hold on

%Finding circle coordinates and calculating boundary integral
summa = zeros(nbr_circles,1);
for ir = 1:nbr_circles
    r = minr + (ir-1)*dr;
    for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        col = center(2) + round(r*cos(phi));
        row = center(1) + round(r*sin(phi));
        summa(ir) = summa(ir,1) + A(row,col);
    end
end

%Calculating derivative ddr
ddr = zeros(nbr_circles-1,1);
for ir = 2:nbr_circles
   ddr(ir-1) = summa(ir) - summa(ir-1);
end

%Finding highest derivative
[~,r] = max(ddr)
r=minr + r*dr;

for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = center(2) + round(r*cos(phi));
        circle(iPhi,1) = center(1) + round(r*sin(phi));
end

plot(circle(:,2),circle(:,1),'r')

