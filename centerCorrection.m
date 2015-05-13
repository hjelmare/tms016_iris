function [ x, y ] = centerCorrection(pCenter, sCenter, pRadius, sRadius, r, theta )
%This function corrects the displacement of the centers when taking polar
%coordinates.

%   P - pupil, S - Sclera, R - the radius of the two boundaries
%   pCenter & sCenter are vectors containing center coordinates (x,y).

xP = pCenter(1) + pRadius*cos(theta);
yP = pCenter(2) + pRadius*sin(theta);

xS = sCenter(1) + sRadius*cos(theta);
yS = sCenter(2) + sRadius*sin(theta);

x = round((1 - r)*xP + r*xS);
y = round((1 - r)*yP + r*yS);
end

