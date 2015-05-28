function lid = eyelid(Im,pupilX,pupilY,rPupil,rIris)

%Finding width of image
[height,width] = size(Im);

add = 50; %Number of pixels added in top and bottom

%Adding pixels in top and bottom to enable search outside image
Im = imAdd(Im,add);

%Defining search area top and finding edge
ymin = pupilY + add;
ymax = pupilY + (rIris - rPupil) + add;
[top_edge] = toplidedgefinder(pupilX,ymin,ymax,rIris,Im);

%Defining search area bottom and finding edge
ymin = pupilY - (rIris-rPupil) + add +5;
ymax = pupilY + add;
[bot_edge] = botlidedgefinder(pupilX,ymin,ymax,rIris,Im);

%Removing added y-coordinates
top_edge(:,2) = top_edge(:,2) - add;
bot_edge(:,2) = bot_edge(:,2) - add;

%Taking away dubbel indexed (x) coordinates
[~,index,~] = unique(bot_edge(:,1));
bot_edge = bot_edge(index,:);

%Creating lid exclusion zone
lid = ones(width,2);
lid(:,2) = lid(:,2) * height;
min_x_top = max(top_edge(1,1),1);
max_x_top = min(top_edge(end,1),width);
min_x_bot = max(bot_edge(1,1),1);
max_x_bot = min(bot_edge(end,1),width);

%Saving toplid into lid
lid(min_x_top:max_x_top,1) = top_edge((top_edge(:,1) >= min_x_top & ...
                                    top_edge(:,1) <= max_x_top),2);
%Saving bottomlid into lid                                
lid(min_x_bot:max_x_bot,2) = bot_edge((bot_edge(:,1) >= min_x_bot & ...
                                    bot_edge(:,1) <= max_x_bot),2);
                               
%Fixing numbers out of bounds
lid(lid<1) = 1;
lid(lid>height) = height;
