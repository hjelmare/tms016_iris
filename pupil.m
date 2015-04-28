clear;
clc;

B = importdata('S1249R02.jpg');
A = B;
A = im2double(A);
A(A>0.75) = 0;
A(A<0.25) = 0;
A = gaussfilt(A,5,10);

%Manual approx center in pupil
center = [156,187];

%Circle parameters
maxr = 70;
minr = 30;
dr=2;
nbr_circles = (maxr - minr)/dr + 1;
nbr_points = 100;
dPhi = 2*pi/nbr_points;

figure
imshow(B);
hold on
%Image sweep
ddrmax = 0;
tmp = zeros(2000,4);
count = 1;
for i = 160:2:200
    for j = 130:2:180
        %Finding circle coordinates and calculating boundary integral
        center = [j,i];
        summa = zeros(nbr_circles,1);
        for ir = 1:nbr_circles
            r = minr + (ir-1)*dr;
            for iPhi = 1:nbr_points
                phi = iPhi * dPhi;
                row = center(2) + round(r*cos(phi));
                col = center(1) + round(r*sin(phi));
                summa(ir) = summa(ir) + A(col,row);
            end
        end

        %Calculating derivative ddr
        ddr = zeros(nbr_circles-1,1);
        for ir = 2:nbr_circles
           ddr(ir-1) = abs(summa(ir) - summa(ir-1));
        end

%         [ddrmax,r] = max(ddr);
%         r=minr + r*dr;
%         tmp(count,:) = [ddrmax,j,i,r];
        %Finding highest derivative
        [tmp,r] = max(ddr);
        r=minr + r*dr;
        if tmp > ddrmax
            ddrmax = tmp;
            centermax = [j,i,r];
        end
        count = count + 1;
    end
end

%Finding highest derivative
% [~,nbr] = max(tmp(:,1));
% centermax = tmp(nbr,2:4);

for iPhi = 1:nbr_points
        phi = iPhi * dPhi;
        circle(iPhi,2) = centermax(2) + round(centermax(3)*cos(phi));
        circle(iPhi,1) = centermax(1) + round(centermax(3)*sin(phi));
end

plot(circle(:,2),circle(:,1),'b')
plot(centermax(2),centermax(1),'rx')

