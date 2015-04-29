function [ vals ] = gabor( rC,phiC,w,n )
%GABOR Gabor 2D wavelet values
%   Centered at xC, yC, with regularly spaced grid n over interval w

vals = zeros(n);

for i = 1:n
    for j = 1:n
        r = rC - w/2 + w*i/n
        phi = phiC - w/2
        
        % not done, obviously




end

