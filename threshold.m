function [ imOut ] = threshold( imIn, dir, col )
%THRESHOLD Sets brightest/darkest part of image to white/black
%   imIn is an image
%   dir is positive to search from above, otherwise negative
%   col is the color to set the pixels to (likely 0 or 1)

hist = imhist(imIn);
hist = diff(hist);

if(dir > 0)
    i = length(hist);
    while (hist(i) >= 0)
        i = i - 1;
    end
else
    i = 1;
    while(hist(i) <= 0)
        i = i + 1;
    end
end

imIn(imIn>=i) = col;

imOut = imIn;

end

