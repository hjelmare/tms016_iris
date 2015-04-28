function [ imUnwrapped ] = unwrap( im, rMin, rMax, center, res )
%UNWRAP Makes rectangular iris image
%   center and res are row vectors, y first

rRes = res(1);
phiRes = res(2);

imUnwrapped = zeros(rRes, phiRes);

for iRadius = 1:rRes
    for iPhi = 1:phiRes
        phi = 2*pi*iPhi / phiRes;
        r = (rMin + (rMax-rMin)*(iRadius/rRes));
        x = center(2) + r * cos(phi);
        y = center(1) + r * sin(phi);
        
        x = round(x);
        y = round(y);

        imUnwrapped(iRadius, iPhi) = im(y,x);
    end
end

end

