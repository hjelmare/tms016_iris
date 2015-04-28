function [ A ] = raiseContrast( A, margin)
%RAISECONTRAST Summary of this function goes here
%   Detailed explanation goes here

A = im2double(A);
hist = imhist(A);
maxCount = numel(A);
count = 0;
iBin = 1+1;
while count < margin*maxCount
    count = count + hist(iBin);
    iBin = iBin + 1;
end
A(A<iBin/256) = iBin/256;


count = 0;
iBin = 256-1;
while count < margin*maxCount
    count = count + hist(iBin);
    iBin = iBin - 1;
end
A(A>iBin/256) = iBin/256;

A = (A - min(min(A)));
A = A./max(max(A));



end

