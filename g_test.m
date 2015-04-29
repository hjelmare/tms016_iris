clear;
clc;
clf;

iris_path = '../Iris/';
files = dir(iris_path);
iFile = 11;
fFile = [iris_path files(iFile).name];

A = imread(fFile);
A = im2double(A);
%A = (filter2(fspecial('gaussian',10,5),A));


rPupil = 32;
rIris = 100;         % Must not be smaller than rPupil
center = [180,162];
maxDev = 3;
angularBuffer = 0.15;

mask = eyelidfinder(center(2), center(1), rPupil,rIris,maxDev, angularBuffer,A);

xPupil = center(2) + rPupil*cos(0:0.01:2*pi);
yPupil = center(1) + rPupil*sin(0:0.01:2*pi);

xIris = center(2) + rIris*cos(0:0.01:2*pi);
yIris = center(1) + rIris*sin(0:0.01:2*pi);

mask(mask==0) = 0.25;
subplot(1,2,1)
imshow(immultiply(mask,A))

subplot(1,2,2)
imshow(A)
hold on
plot(center(2),center(1),'rx')
plot(xPupil,yPupil,'b')
plot(xIris,yIris,'g')
hold off

