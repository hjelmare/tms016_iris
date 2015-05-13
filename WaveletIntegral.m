function [ ReH, ImH ] = WaveletIntegral( waveletParams, position, im )
%WAVELETINTEGRAL Summary of this function goes here
%   Detailed explanation goes here

[nRho, nPhi] = size(im);

r0 = position(2);
theta0 = position(1);

alpha = waveletParams(1,:);
beta = waveletParams(2,:);
omega = waveletParams(3,:);

% simple form
%wavelet = @(rho,phi,r0,theta0,alpha,beta,omega) exp(- 1i * omega * (theta0 - phi))*...
%    exp(-(r0-rho)^2 / alpha^2) * (exp(-(theta0 - phi)^2) / beta^2) ;

% matrix-vector form...
wavelet = @(rho,phi,r0,theta0,alpha,beta,omega) ...
    (exp(-(theta0 - phi).^2 ./ beta.^2))' *...
    (exp(-(r0-rho).^2 ./ alpha.^2)) *...
    exp(- 1i * omega * (theta0 - phi))';

h = zeros(8,1);

for y = 1:nRho
    for x = 1:nPhi
        h = h + im(y,x)*wavelet(y/nRho,x/nPhi,r0,theta0,alpha,beta,omega);
    end
end

ReH = real(h);
ImH = imag(h);

ReH(ReH == 0) = -1;
ImH(ImH == 0) = -1;

ReH = (sign(ReH)+1)/2;
ImH = (sign(ImH)+1)/2;
%ReH = real(h);
%ImH = imag(h);

end

