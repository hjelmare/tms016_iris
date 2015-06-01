function [ xBoundary, yBoundary ] = GetPupilLocation( Image )
%------------------------------------------------------------------------
% 
% GetPupilLocation narrows down the part of the image where the pupil is so
% that the function "pupil" does not have to search over the whole image.
% Input:
%   Image is the image (Assumed to be the original without "raiseContrast".
% Output:
%   xBoundary contains the start and end x-value for the function "pupil".
%   yBoundary contains the start and end y-value for the function "pupil".

% OBS Hårdkodade gränser (rad41, 42) samt hårdkodad kubstorlek(rad 22)
%------------------------------------------------------------------------

I = im2double(Image);
[nbrOfRow, nbrOfCol] = size(I);

I_mod = I;
I_mod(I_mod < 0.25) = 0;

%imshow(I_mod);
boxLength = 70;
rowStart = boxLength;
colStart = boxLength;
maxZerosInSquare = 0;
%We start a boxLength number of pixeln in from all edges
for iRow = boxLength:boxLength/2:nbrOfRow-boxLength
    for iCol = boxLength:boxLength/2:nbrOfCol-boxLength
        nbrOfZeros = length(find(I_mod(iRow:iRow+boxLength, iCol:iCol+boxLength) == 0));
        if( nbrOfZeros > maxZerosInSquare)
            maxZerosInSquare = nbrOfZeros;
            rowStart = iRow;
            colStart = iCol;
        end
        
    end
end


I_mod(I_mod > 0.97) = 0;
I_mod(I_mod > 0.4) = 1;

rowStop = min(rowStart + boxLength, nbrOfRow - boxLength);
colStop = min(colStart + boxLength, nbrOfCol - boxLength);

minSum = inf;
for iRow = rowStart:5:rowStop
    for iCol = colStart:5:colStop
        summa = sum(sum(I_mod(iRow-boxLength/2:iRow+boxLength/2, iCol-boxLength/2:iCol+boxLength/2)));
        
        if summa < minSum
            minSum = summa;
            rowCenter = iRow;
            colCenter = iCol;
        end
    end
end

indrag = 10;
xBoundary = [colCenter-boxLength/2+indrag, colCenter+boxLength/2-indrag];
yBoundary = [rowCenter-boxLength/2+indrag, rowCenter+boxLength/2-indrag];


end

