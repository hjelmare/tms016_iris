function I = gaussfilt(inIm,p,sigmasq)

%Creation of filter mask
w = zeros(2*p + 1);
k = -p;
for i = 1:(2*p + 1)
    l = -p;
    for j = 1:(2*p + 1)
       w(i,j) = exp(-(k^2 + l^2)/(2*sigmasq));
       l = l + 1;
    end
    k = k + 1;
end

w = w/sum(sum(w));

I = imfilter(inIm,w);
end
