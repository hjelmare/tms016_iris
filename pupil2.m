close all;
clear;
clc;

iris_path = 'goodEyes/';
files = dir(iris_path);
[nbrOfFiles, ~] = size(files);

%kör hälften av filerna
nbrOfFiles = round(nbrOfFiles/2);

for iFile = 3:nbrOfFiles
    close all
    
    fileName = [iris_path files(iFile).name];
    B = importdata(fileName);
    A = B;
    A = im2double(A);
    
    %Plotting image
    figure
    imshow(B);
    hold on
    
    %Circle parameters
    rmax = 70;
    rmin = 30;
    [x, y] = GetPupilLocation(A);
    
    %Finding pupil
    centermax = cedgefinder(x,y,rmin,rmax,A);
    xCenter_p = centermax(1);
    yCenter_p = centermax(2);
    r_p = centermax(3);
    plotcircle(xCenter_p, yCenter_p, r_p);
    
    %Finding Iris
    [xCenter_s, yCenter_s, r_s] = iris(A, xCenter_p, yCenter_p, r_p);
    plotcircle(xCenter_s, yCenter_s, r_s)
    
    %Checking if valid (more or less concentric)
    center_distance = sqrt((xCenter_p-xCenter_s)^2 + (yCenter_p-yCenter_s)^2);
    
    if center_distance < 10
        lid = eyelid(A,xCenter_p,yCenter_p,r_p,r_s);
        plot(lid(:,1),'b')
        plot(lid(:,2),'r')
    else
        %error('BAD SPECIMEN/TEST')
        disp('BAD SPECIMEN/TEST')
        continue
    end
    
    
    
    %-----------------------unwrapping of iris-------------------------------
    [uImage, mask] = unwrap(A, r_p, r_s, [xCenter_p, yCenter_p], [xCenter_s, yCenter_s], [100 300], lid);
    %figure(2)
    %subplot(2,1,1)
    %imshow(uImage)
    %subplot(2,1,2)
    %imshow(mask)
    
    %alpha = [pi pi/100 pi/20 pi/5];
    %beta = alpha;
    %omega = 3./beta;
    
    
    im = uImage;
    nscale =6;
    minWaveLength = 6;
    mult = 2;
    sigmaOnf = 0.65;
    
    [E0, filtersum] = gaborconvolve(im, nscale, minWaveLength, mult, sigmaOnf);
    
    E = E0{1};
    %Phase quantisation
    H1 = real(E) > 0;
    H2 = imag(E) > 0;
    
    template = [H1;H2];
    for i = 2:nscale
        E = E0{i};
        H1 = real(E) > 0;
        H2 = imag(E) > 0;
        template = [template; H1; H2];
    end
    
    figure(3)
    imshow(template)
    
    
    
    fileName = [fileName(1:end-3) 'mat'];
    save(['irisTemplates/testParameter/' fileName(10:end)], 'template', 'mask')
    
    
end