clear;
clc;
clf;

iris_path = '../Iris/';
files = dir(iris_path);

for i = 3:3
    
iFile = i;
fFile = [iris_path files(iFile).name];

A = imread(fFile);
A = im2double(A);

rMin = 32;
rMax = 95;
phi = 0:2*pi/100:2*pi;

pCenter = [175 172];
sCenter = [177 170];

xPupil = pCenter(2) + rMin * cos(phi);
yPupil = pCenter(1) + rMin * sin(phi);
xIris = sCenter(2) + rMax * cos(phi);
yIris = sCenter(1) + rMax * sin(phi);


res = [200 200];

uA = unwrap( A, rMin, rMax, pCenter, sCenter, res );

subplot(1,2,1)
imshow(uA)

% subplot(1,2,2)
% imshow(A)
% hold on
% plot(sCenter(2),sCenter(1),'rx')
% plot(pCenter(2),pCenter(1),'rx')
% plot(xPupil,yPupil,'b')
% plot(xIris,yIris,'g')
% hold off

drawnow
%pause()
end


subplot(1,2,2)
imshow(A)
