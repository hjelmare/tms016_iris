function [top_edge,bot_edge] = eyelid(Im,pupilX,pupilY,rPupil,rIris)

add = 50; %Number of pixels added in top and bottom

%Adding pixels in top and bottom to enable search outside image
Im = imAdd(Im,add);
%Im = gaussfilt(Im,5,10);

%Defining search area top and finding edge
ymin = pupilY + add;
ymax = pupilY + (rIris - rPupil) + add;
[top_edge] = toplidedgefinder(pupilX,ymin,ymax,rIris,Im);

%Defining search area bottom and finding edge
ymin = pupilY - (rIris-rPupil) + add +5;
ymax = pupilY + add;
[bot_edge] = botlidedgefinder(pupilX,ymin,ymax,rIris,Im);

top_edge(:,2) = top_edge(:,2) - add;
bot_edge(:,2) = bot_edge(:,2) - add;

end


