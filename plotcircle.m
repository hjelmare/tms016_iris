function plotcircle(x0,y0,r)

%Plotting circle
nbr_points = 360;
dPhi = 2*pi/nbr_points;
circle = zeros(nbr_points,2);
for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = y0 + round(r*cos(phi));
        circle(iPhi,1) = x0 + round(r*sin(phi));
end

hold on
plot(circle(:,1),circle(:,2))
plot(x0,y0,'rx')
