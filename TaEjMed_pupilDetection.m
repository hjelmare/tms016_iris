% test find pupil:
clear all
clc
close all

I = imread('eye.jpg');
I = double(I)/255;
[rowSize, colSize] = size(I);

I(I>0.92)=0;
hsize = 10;
sigma = 1.7;
h = fspecial('gaussian', hsize, sigma);
I = filter2(h,I);
I(I>0.92)=0;
I(I<0.5)=0;


%startIndex = [154 198];
%row = startIndex(2);
%col = startIndex(1);
%I(row, col) = 1;
imshow(I)

nbrOfPoints = 150;
dtheta = 2*pi/nbrOfPoints;
rMin = 25;
rMax = 60;
rIncrease = 2;

%dessa stämmer enbart till min specifika bild
startRow = 80;
endRow = 250;
startCol = 66;
endCol = 240;
circle = zeros(nbrOfPoints, 2);
newCircle = zeros(nbrOfPoints,1);
bestSum = 0;
finalCenter = 0;
for rowSweep = startRow:2:endRow
   for colSweep = startCol:2:endCol
       hold on
       plot(colSweep, rowSweep, 'r')
        
        dSum = 0;
        summa1 = 0;
        summa2 = 0;
        for r = rMin:rIncrease:rMax
            for i = 1:nbrOfPoints
                theta = i*dtheta;
                circle(i,1) = round(rowSweep + r*cos(theta));
                circle(i,2) = round(colSweep + r*sin(theta));
%                 circle(i,1) = round(row + r*cos(theta));
%                 circle(i,2) = round(col + r*sin(theta));
            end
            
            %calculate indexes of circle:
            newCircle(:) = (circle(:,2)-1)*rowSize + circle(:,1);
            
            summa2 = sum(I(newCircle));
            if abs(summa2-summa1) > dSum
                dSum = abs(summa2-summa1);
                rCenter = r;
            end
            summa1 = summa2;
        end

        if dSum > bestSum
            bestSum = dSum
            finalCenter = rCenter;
            rowCenter = rowSweep;
            colCenter = colSweep;
            
            
%             %---------------------------------------------
%             for i = 1:nbrOfPoints
%                 theta = i*dtheta;
%                 circle(i,1) = round(rowCenter + finalCenter*cos(theta));
%                 circle(i,2) = round(colCenter + finalCenter*sin(theta));
%             end
%             
%             hold on
%             plot(circle(:,2), circle(:,1), 'r')
% %            plot(colSweep, rowSweep, 'b')
% %            pause
%             %-------------------------------------
        end
        
    end
end
%%
% Debugging
    for i = 1:nbrOfPoints
        theta = i*dtheta;
        circle(i,1) = round(rowCenter + finalCenter*cos(theta));
        circle(i,2) = round(colCenter + finalCenter*sin(theta));
    end

hold on
plot(circle(:,2), circle(:,1), 'b')
