function [ DoGPyr ] = DoGSS( GPyr )
% Create a Difference of Gaussian pyramid representation of an image
% GPyr: the Gaussian pyramid created by GSS.m

noct = size(GPyr,1);
ns = size(GPyr{1},3) - 3;

DoGPyr = cell(noct,1);
for m = 1:noct
    for n = 1:ns+2
        DoGPyr{m}(:,:,n) = GPyr{m}(:,:,n+1) - GPyr{m}(:,:,n);
    end
end

end

