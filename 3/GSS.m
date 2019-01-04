function [ GPyr ] = GSS( im, s1, ns, noctaves )
% Create gaussian pyramid
% im: input grey scale img
% s1: space constant of the gaussian kernel applied to the base level
% ns: # of suboctaves
% noctaves: # of octaves

k = 2^(1/ns);
% sigma = zeros(noctaves, ns+3);
% sigma(1,1) = s1;
% for m = 2:noctaves
%     for n = 1:ns+3
%         sigma(m,n) = s1*2^(m-1)*k^(n-1);
%     end
% end

% !!! sigma stride is constant in all octave
sigma = zeros(1, ns+3);
sigma(1) = s1;
for n = 2:ns+3
    sigma(n) = sigma(n-1) * k;
end

% gaussian conv
function [ gaussianImg ] = gaussian( im, sigma )
% im: double greyscale image

% kernel size = 3*sigma; make it odd
ksize = round(3*sigma);
if mod(ksize,2) == 0
    ksize = ksize + 1;
end    
kernel = fspecial('gaussian',[ksize,ksize], sigma);
gaussianImg = conv2(im, kernel, 'valid');

psize = (ksize-1)/2;
gaussianImg = padarray(gaussianImg, [psize psize], NaN);

end
    

% first level, double the image size
im = imresize(im,2);
% original img has blur of sigma = 0.5, doubled img has sigma = 1.0
im = gaussian(im, sqrt(s1^2 - (1.0)^2));

% the gaussian pyramid
GPyr = cell(noctaves,1);
oct_size = zeros(noctaves, 2);
[im_height, im_width] = size(im);
oct_size(1,:) = [im_height, im_width];
GPyr{1} = zeros(oct_size(1,1), oct_size(1,2), ns+3);
for i = 2:noctaves
    %oct_size(i,:) = [round(size(oct_size(i-1,1))/2),round(size(oct_size(i-1,2))/2)];
    oct_size(i,:) = [round(size(GPyr{i-1},1)/2),round(size(GPyr{i-1},2)/2)];
    GPyr{i} = zeros(oct_size(i,1), oct_size(i,2), ns+3);
end

% Construction
for m = 1:noctaves
    for n = 1:ns+3
        if (m==1 && n==1)
            GPyr{m}(:,:,n) = im;
        elseif (n==1)
            % the last but 3 img from the previous ovtave ==> downsampling
            GPyr{m}(:,:,n) = imresize(GPyr{m-1}(:,:,ns+1),0.5);
        else
            GPyr{m}(:,:,n) = gaussian(GPyr{m}(:,:,n-1), sigma(n));
        end
    end
end

end

