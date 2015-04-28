clear;
clc;
clf;

iris_path = '../Iris/';
files = dir(iris_path);
iFile = 7;
fFile = [iris_path files(iFile).name];

A = imread(fFile);

center = [184,124];

rMax = 80;
rMin = 40;

rRes = 200;
phiRes = 720;
res = [rRes, phiRes];

imUnwrapped = unwrap(A,rMin, rMax, center, res);
imUnwrapped = imUnwrapped .* (1/255);

subplot(2,1,1)
hold on
imshow(A)
plot(center(2),center(1),'rx')
hold off
subplot(2,1,2)
imshow(imUnwrapped)