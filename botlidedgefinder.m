function [edge_coord] = lidedgefinder2(pX0,ymin,ymax,rIris,Im)

%Declaration of variables
nbr_points = 150;         %Number of points in circle
dPhi = pi/(4*nbr_points);
phipnts = pi*3/8:dPhi:pi*5/8;

%Size of image
[colsize,~] = size(Im);

%Elipseconstants
elipse_const = 1.6:0.2:2;
nbr_elipse_const = length(elipse_const);

%Angles
maxangle = pi/8;
minangle = -pi/8;
anglestep = pi/48;
nbr_angle_steps = fix((maxangle-minangle)/anglestep) + 1;

%Allocating space cicle/elipse masks
circle = zeros(nbr_elipse_const,nbr_angle_steps,nbr_points,2);


%Image sweep parameters
summa = zeros(nbr_angle_steps,1);
ddrmax = 0;

%Create ellipse mask
for iElipse = 1:nbr_elipse_const
    for iPhi = 1:nbr_points
            phi = phipnts(iPhi);
            circle(iElipse,1,iPhi,2) = fix(elipse_const(iElipse)*rIris*cos(phi));
            circle(iElipse,1,iPhi,1) = fix(rIris*sin(phi));
            for iAngle = 2:nbr_angle_steps
                angle = minangle + anglestep * (iAngle - 1);
                circle(iElipse,iAngle,iPhi,2) = round(cos(angle)*circle(iElipse,1,iPhi,2) - sin(angle)*circle(iElipse,1,iPhi,1));
                circle(iElipse,iAngle,iPhi,1) = round(sin(angle)*circle(iElipse,1,iPhi,2) + cos(angle)*circle(iElipse,1,iPhi,1));
            end
    end
end


%Sweeping over image inside search interval
for iElipse = 1:nbr_elipse_const
    for iy = ymin:ymax
        for ix = pX0-10:5:pX0+10
        for iAngle = 1:nbr_angle_steps
            %Calculating coordinates for circle
            circ2 = ix + circle(iElipse,iAngle,:,2);
            circ1 = iy + circle(iElipse,iAngle,:,1);
            
                
            circ2 = reshape(circ2,[1 nbr_points]);
            circ1 = reshape(circ1,[1 nbr_points]);
                

            %Remake coordinates and sum up pixel values
            circle2 = (circ2 - 1) * colsize + circ1;
            summa(iAngle) = sum(Im(circle2));
        end

            %Calculating derivative ddr
            ddr = abs(summa(3:end) - summa(2:end-1));

            %Finding highest ddr
            [tmp,angle] = max(ddr);

            %Saving point if it is highest
            if tmp > ddrmax 
                ddrmax = tmp;
                angle = minangle + anglestep*(angle);
                econst = elipse_const(iElipse);
                centermax = [iy,ix,angle,econst];
            end
        end
    end
end

y0 = centermax(1);
x0 = centermax(2);
angle = centermax(3);
econst = centermax(4);
phipnts = pi*2/8:dPhi/2:pi*6/8;
ry = rIris;
rx = econst*ry;
for iPhi = 1:length(phipnts)
        phi = phipnts(iPhi);
        
        edge_coord(iPhi,1) = x0 + round(cos(angle)*rx*cos(phi) - sin(angle)*ry*sin(phi));
        edge_coord(iPhi,2) = y0 + round(sin(angle)*rx*cos(phi) + cos(angle)*ry*sin(phi));
end

