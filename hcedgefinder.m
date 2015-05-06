function [x0,y0,r] = hcedgefinder(searchx,searchy,rmin,rmax,Im)

%Declaration of variables
dr=1;
nbr_circles = (rmax - rmin)/dr + 1;     %Number of circles
nbr_points = 30;                        %Number of points in circle
dPhi = pi/(nbr_points);
phipnts = [-pi/4:dPhi:pi/4,pi*3/4:dPhi:pi*5/4];
[colsize,~] = size(Im);
circle = zeros(nbr_circles,nbr_points,2);
summa = zeros(nbr_circles,1);

%Image sweep parameters
xmin = searchx(1);
xmax = searchx(2);
ymin = searchy(1);
ymax = searchy(2);
dpix = 2;
ddrmax = 0;

%Create circle mask
for ir = 1:nbr_circles
    r = rmin + (ir-1)*dr;
    for iPhi = 1:nbr_points
        phi = phipnts(iPhi);
        circle(ir,iPhi,2) = fix(r*cos(phi));
        circle(ir,iPhi,1) = fix(r*sin(phi));
    end
 end

%Sweeping over image inside search interval
for ix = xmin:dpix:xmax
    for iy = ymin:dpix:ymax
        for ir = 1:nbr_circles
            %Calculating coordinates for circle
            circ2 = ix + circle(ir,:,2);
            circ1 = iy + circle(ir,:,1);
            
            %Remake coordinates and sum up pixel values
            circle2 = (circ2 - 1) * colsize + circ1;
            summa(ir) = sum(Im(circle2));
        end

        %Calculating derivative ddr
        ddr = abs(summa(2:end) - summa(1:end-1));

        %Finding highest ddr
        [tmp,r] = max(ddr);
        
        %Saving point if it is highest
        if tmp > ddrmax 
            ddrmax = tmp;
            r = rmin + r*dr;
            centermax = [ix,iy,r];
        end
    end
end

x0 = centermax(1);
y0 = centermax(2);
r = centermax(3);
