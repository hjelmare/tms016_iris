function [edge_coord] = lidedgefinder(pX0,ymin,ymax,rIris,Im)

%Declaration of variables
nbr_points = 150;         %Number of points in circle
dPhi = pi/(4*nbr_points);
phipnts = pi*11/8:dPhi:pi*13/8;

%Size of image
[colsize,~] = size(Im);

%Elipseconstants
elipse_const = 1.8;


%Angles
maxangle = pi/8;
minangle = -pi/8;
anglestep = pi/48;
nbr_angle_steps = fix((maxangle-minangle)/anglestep) + 1;

%Allocating space cicle/elipse masks
circle = zeros(nbr_angle_steps,nbr_points,2);


%Image sweep parameters
summa = zeros(ymax-ymin,1);

%Create ellipse mask with different angels
for iPhi = 1:nbr_points
        %Creating original ellipse arc
        phi = phipnts(iPhi);
        circle(1,iPhi,2) = fix(elipse_const*rIris*cos(phi));
        circle(1,iPhi,1) = fix(rIris*sin(phi));
        for iAngle = 2:nbr_angle_steps
            %Doing alla angles
            angle = minangle + anglestep * (iAngle - 1);
            circle(iAngle,iPhi,2) = round(cos(angle)*circle(1,iPhi,2) - sin(angle)*circle(1,iPhi,1));
            circle(iAngle,iPhi,1) = round(sin(angle)*circle(1,iPhi,2) + cos(angle)*circle(1,iPhi,1));
        end
end


y_ang = [];
%Sweeping over image inside search interval
for iAngle = 1:nbr_angle_steps
    index = 1;
    for iy = ymin:ymax
              
            %Calculating coordinates for ellipse arc
            circ2 = pX0 + circle(iAngle,:,2);
            circ1 = iy + circle(iAngle,:,1);
            
            %Reshaping to 2D matrix    
            circ2 = reshape(circ2,[1 nbr_points]);
            circ1 = reshape(circ1,[1 nbr_points]);
                
            %Remake coordinates and sum up pixel values
            circle2 = (circ2 - 1) * colsize + circ1;
            summa(index) = sum(Im(circle2));
            index = index +1;
    end
    
    
    %Calculating derivative ddr
    ddr = abs(summa(3:end) - summa(2:end-1));

    %Finding highest ddr
    [~,ynum] = max(ddr);

    %Saving point if it is highest and not within 5pixels from pupil
    if ynum < (ymax-ymin - 5) 
        angle = minangle + anglestep*(iAngle-1);
        y_ang(end+1,:) = [ymin+ynum-1,angle];
    end 
end


%Recreating the best arc from every angle
ry = rIris;
rx = elipse_const*ry;
[strl,~] = size(y_ang);
philength = length(phipnts);
c2 = zeros(philength,2,strl);
for iy = 1:strl
    for iPhi = 1:philength
        phi = phipnts(iPhi);
        c2(iPhi,2,iy) = pX0 + round(cos(y_ang(iy,2))*rx*cos(phi) - sin(y_ang(iy,2))*ry*sin(phi));
        c2(iPhi,1,iy) = y_ang(iy,1) + round(sin(y_ang(iy,2))*rx*cos(phi) + cos(y_ang(iy,2))*ry*sin(phi));
    end
    %plot(c2(:,2,iy),c2(:,1,iy),'b.')
end

%Finding the points in the combined arcs with highest y-value
xmin = min(min(c2(:,2,:)));
xmax = max(max(c2(:,2,:)));
strl = xmax-xmin;
lidx = zeros(strl,1);
lidy = zeros(strl,1);
for i = 1:strl
   lidx(i) = xmin + i - 1;
   place = find(c2(:,2,:) == lidx(i));
   tmp = c2(:,1,:);
   tmp = tmp(place);
   if isempty(tmp)
       lidy(i) = lidy(i-1);
      else
        lidy(i) = max(tmp);
   end
end

for i = 2:xmax-xmin
    if(abs(lidy(i)-lidy(i-1)) > 2)
        lidy(i) = lidy(i-1);
    end
end

edge_coord = [lidx,lidy];



