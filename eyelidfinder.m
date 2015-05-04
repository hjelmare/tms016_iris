function mask = eyelidfinder(xCenter,yCenter,rPupil,rIris, allowedDeviation, angularBuffer,Im)

% Calculate reference intensity
minPhi = -pi/8;     % Perhaps there's a better choice...
refPhi = pi/8;
maxPhi = minPhi+2*pi;
dPhi = 0.001;        % This is a bit of a problem... can't be bigger.
phiSweep = minPhi:dPhi:maxPhi;
phiRefSweep = minPhi:dPhi:refPhi;

dR = 0.1;
rSweep = (rPupil + (rIris - rPupil)/2): dR : rIris;


nPad = 50;
ImPadded = imAdd(Im,nPad);

intensity = zeros(1,length(phiSweep));
badPhi = intensity; % Just to get the same size and all zeros

% -- For each radial line, find avg pixel intensity of outer half of iris
for i = 1:length(phiSweep)
    for j = 1:length(rSweep)
        x = xCenter + rSweep(j)*cos(phiSweep(i));
        y = yCenter + rSweep(j)*sin(phiSweep(i));
        
        x = round(x);
        y = round(y);
        
        intensity(i) = intensity(i) + ImPadded(y+nPad,x);
    end
    
    intensity(i) = intensity(i) / j;
end

% Use the right-hand side for reference
meanIntensity = mean(intensity(1:length(phiRefSweep)));
stdIntensity = std(intensity(1:length(phiRefSweep)));
% Anything that deviates a lot is probably bad
badPhi(intensity > meanIntensity + allowedDeviation*stdIntensity) = 1;
% and anything near that should also be disregarded
padding = round(angularBuffer / dPhi);
paddedBadPhi = padarray(badPhi,[0 padding]);
for i = 1:length(badPhi)
    if sum(paddedBadPhi(i:i+padding*2))~=0
        badPhi(i) = 1;
    end
end

rSweep = rPupil : rIris;

mask = zeros(size(ImPadded));
for i = 1:length(phiSweep)
    for j = 1:length(rSweep)
        x = xCenter + rSweep(j)*cos(phiSweep(i));
        y = yCenter + rSweep(j)*sin(phiSweep(i)) + nPad;
        
        x = round(x);
        y = round(y);
        
        if ~badPhi(i)
            mask(y,x) = 1;
        end
        
    end
end

mask = mask(nPad+1:end-nPad,:);

end


