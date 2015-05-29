function lashmask = eyelash(uIm,mask)

%Function that takes unwrapped image of iris and find eyelashes
%
% Input:     uIm - Unwrapped Iris image
%            mask - Previously calculated mask   
%
% Output:    lashmask - binary mask of same size uIm where eyelashes 
%                       are zeros, combined with input mask
%

%Storing image in lshmask
lashmask = uIm;

%Thresholding image to binary so eyelashes becomes zeros
threshold = 0.35;
lashmask(lashmask > threshold) = 1;
lashmask(lashmask <= threshold) = 0;

%Inverting the binary image
lashmask = abs(lashmask - 1);

%Dilating eyelash traces
lashmask = imdilate(lashmask,ones(5));

%Inverting binary image back
lashmask = abs(lashmask - 1);

mask(lashmask == 0) = 0;

lashmask = imerode(mask,ones(3));