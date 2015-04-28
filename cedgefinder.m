function centermax = cedgefinder(x,y,rmin,rmax,dr,nbr_circles,Im)

%Declaration of variables
nbr_points = 25; %Number of points in circle
dPhi = 2*pi/nbr_points;
[colsize,~] = size(Im);
circle = zeros(nbr_points,2);
summa = zeros(nbr_circles,1);

for ir = 1:nbr_circles
    r = rmin + (ir-1)*dr;
    for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = x + ceil(r*cos(phi));
        circle(iPhi,1) = y + ceil(r*sin(phi));
    end
    %Remake coordinates and sum
    circle2 = (circle(:,2) - 1) * colsize + circle(:,1);
    summa(ir) = sum(Im(circle2));
end

%Calculating derivative ddr
ddr = abs(summa(2:end) - summa(1:end-1));

%Finding highest ddr
[ddrmax,r] = max(ddr);
r = rmin + r*dr;

centermax = [ddrmax,x,y,r];

