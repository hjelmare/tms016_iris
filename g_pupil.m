clear;
clc;
clf;

iris_path = '../Iris/';
files = dir(iris_path);
iFile = 4;
fFile = [iris_path files(iFile).name];

A = imread(fFile);

A = threshold(A, 1, 0);

n=10;
w = (1/n^2).*ones(n);
A = filter2(w,A);
A = (1/255).*A;
imshow(A)

%Manual approx center in pupil
center = [170,125];

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
[~,r] = max(ddr);
r=minr + (r-1)*dr;

for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = center(2) + round(r*cos(phi));
        circle(iPhi,1) = center(1) + round(r*sin(phi));
end

plot(circle(:,2),circle(:,1),'r')

