clear;
clc;
clf;

iris_path = '../Iris/';
files = dir(iris_path);

for i = 3:13
    
iFile = i;
fFile = [iris_path files(iFile).name];

A = imread(fFile);
A = im2double(A);

rPupil = 32;
rIris = 100;         % Must not be smaller than rPupil


rmin = 30;
rmax = 70;

[x, y] = GetPupilLocation(A);
centermax = cedgefinder(x,y,rmin,rmax,A);
x = centermax(1);
y = centermax(2);
rPupil = centermax(3);
[x,y,rIris] = iris(A,x,y,rPupil);

center = [y,x];

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

drawnow
pause(0.5)
end
