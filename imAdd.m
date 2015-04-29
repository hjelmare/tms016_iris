function Im = imAdd(inIm,add)
%--------------------------------------------------------------------------
% Function that adds extra space at top and bottom of image and fills it up
% with averages from the border of the original image.
% 
% Input variables:    inIm - image matrix that you want to modify
%                     add - number of pixels you want to add at top and bot
%                     
% Output variables:   Im - Resulting image with add in top and bottom
%--------------------------------------------------------------------------

%Getting size of image
[col,row] = size(inIm);

%Creating new image with add in top and bottom
Im = zeros(col + 2*add,row);
Im(add+1:col+add,:) = inIm;

%Filling add top
for iy = add+10:-1:1
    for ix = row-1:-1:2
        Im(iy,ix) = sum(Im(iy+1,ix-1:ix+1))/3;
    end
end

%Filling add bottom
for iy = add+col-9:col+2*add
    for ix = 2:row-1
        Im(iy,ix) = sum(Im(iy-1,ix-1:ix+1))/3;
    end
end

