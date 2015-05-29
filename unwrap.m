function [imUnwrapped, mask] = unwrap( im, rMin, rMax, pCenter, sCenter, res , lid )
%UNWRAP Makes rectangular iris image
%   center is a row vector [y, x].
%   res is a rowvector containing the resolution in radius and theta step
    %[r, theta]
%   Lid is a image-height by 2 vector containing lid boundary
%   imUnwrapped is a 2D matrix with the unwrapped iris [radius, phi]


rRes = res(1);
phiRes = res(2);

imUnwrapped = zeros(rRes, phiRes);
mask = ones(rRes, phiRes);


%Extends the image and corrects the y-values
nPad = 50;
im = imAdd(im, nPad);
lid = lid + 50;
pCenter(2) = pCenter(2) + nPad;
sCenter(2) = sCenter(2) + nPad;


%rStep = (rMax-rMin)/rRes;
rStep = 1/rRes;
phiConstant = 2*pi/phiRes;
for iRadius = 1:rRes
    for iPhi = 1:phiRes
        phi = iPhi * phiConstant;
        r = iRadius * rStep;

        [x, y] = centerCorrection(pCenter, sCenter, rMin, rMax, r, phi);
        mask(iRadius, iPhi) = (lid(x,2) > y & lid(x,1) < y);
        imUnwrapped(iRadius, iPhi) = im(y,x);
    end
end

end

