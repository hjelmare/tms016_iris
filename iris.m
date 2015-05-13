function [x0,y0,r] = iris(Im,pupilX,pupilY,pupilr)

search = 15; %radius of search cube around pupil center
add = 50; %Number of pixels added in top and bottom
[ylength,~] = size(Im); 

%Adding pixels in top and bottom to enable search outside image
Im = imAdd(Im,add);
%B = gaussfilt(B,5,10);

%Defining search parameters
searchx = [pupilX-search,pupilX+search];
searchy = [pupilY+add-search,pupilY+add+search];
rmin = pupilr + 2 * search;
%rmax = ylength - pupilY + add - search*2 - 10;
rmax = 110;

%Finding circular edge
centermax = cedgefinder(searchx,searchy,rmin,rmax,Im);
x0 = centermax(1);
y0 = centermax(2) - add;
r = centermax(3);
end


