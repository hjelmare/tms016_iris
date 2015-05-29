function [ maxMatch ] = Matching( file1, file2)
% Matching compares two binary templates from two different images and
% returns the maximum match in procent of the total number of pixels.

%file1 and file 2 are two different binary templates from different iris
%images. file1 & file2 is a struct={template, mask}.

%OBS!!! kvar att göra: ta med i beräkningen de pixlar som inte ska användas
%(t.ex. pga ögonlock).

%Extract data
template1 = file1{1};
template2 = file2{1};

%Join masks
mask1 = file1{2};
mask2 = file2{2};
mask = mask1 + mask2;
mask = (mask == 2);
mask = [mask; mask]; %to match re and im part

%Check that the two images is saved in the same format:
if size(mask1) ~= size(mask2)
    error('The two images have been saved in different fomrats.')
end

%Calculate nbr of points that are compared
[nbrMaskRows, ~] = size(mask1);
[nbrTemplateRows, nbrTemplateCols] = size(template1);
scale = nbrTemplateRows/(nbrMaskRows*2); %*2 since im and real part
nbrOfPoints = sum(sum(mask))*scale;

%Set the useless pixels (according to the mask) to different values in the
%two templates so that they can't match.
tempMask = mask;
for i = 1:scale-1
    mask = [mask; tempMask];
end
template1(mask == 0) = 1; %If a=positive & b=0: xor(a,b) = 1
template2(mask == 0) = 0;



if (size(template1) ~= size(template2))
    error('The templates of the two images are not of the same size!!');
end



nbrMatches = zeros(nbrTemplateCols, 1);

for i = 1:nbrTemplateCols
    compared = xor([template1(:,i:end), template1(:,1:i-1)], [template2(:,i:end), template2(:,1:i-1)]);
    nbrMatches(i) = sum(sum(compared == 0));
end

maxMatch = max(nbrMatches)/nbrOfPoints; %OBS rätta till denna beroende på hur många pixlar som är tillåtna
end


