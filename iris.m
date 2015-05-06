function [x0,y0,r] = iris(Im,pupilX,pupilY,pupilr)

search = 15; %radius of search cube around pupil center
add = 50; %Number of pixels added in top and bottom
border = 5; %Number of pixels on border not searched
[~,xlength] = size(Im); 

%Adding pixels in top and bottom to enable search outside image
Im = imAdd(Im,add);
Im = gaussfilt(Im,5,10);

%Defining search parameters
searchx = [pupilX-search,pupilX+search];
searchy = [pupilY+add-search,pupilY+add+search];
rmin = pupilr + 2 * search;
rmax = min([searchx(1)-border,xlength-searchx(2)-border]);

%Finding circular edge
[x0,y0,r] = hcedgefinder(searchx,searchy,rmin,rmax,Im);
y0 = y0 - add;
end


