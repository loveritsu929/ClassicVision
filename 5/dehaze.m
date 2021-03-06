function [J] = dehaze(im,scale)

if ~exist('scale', 'var')
    scale = 1;
end

[h,w,c]=size(im);
ds = imresize(im, scale);
darkImg = getDark(ds, 5);
% haze model: I(x) = J(x)t(x) + A(1-t(x))......(1)
% I(x): observed indensity i.e. the input haze image
% J(x): the scene radiance i.e. the haze-free image we want to restore
% A: global atmospheric light
% t(x): medium transmission i.e. the portion of the light that is not scattered and reaches the camera.

% Estimating A:
% Find the top 0.1% brightest pixels, take the average, set a threshold
% uint8 220 == double 0.8627

A_threshold = 0.8627;
grayImg = rgb2gray(ds);
num = round(numel(grayImg)*0.001);
[sorted ind] = sort(grayImg(:), 'descend');
[rowInd colInd] = ind2sub(size(grayImg), ind(1:num));

A = 0;
for i = 1:num
   A = A + grayImg(rowInd(i), colInd(i));
end
A = A / num;

if A > A_threshold
    A = A_threshold;
end


% Given I(x), want to get J(x) ==> There are infinite solutions ==> need some prior knowledge
% normalize: I(x)/A = t(x)J(x)/A + 1 - t(x)
% minFilter: minFilter(min(I(y)/A)) = t(x) minFilter(min(J(y)/A)) + 1 - t(x)
% Allpying dark channel prior: minFilter(min(I(y)/A)) = 1 - t(x)
% t(x) = 1 - w * minFilter(min(I(y)/A))
% Assume t(x) is constant for every local region

omega = 0.95;
%t_threshold = 0.1;
t = 1 - omega * (darkImg);
t = imresize(t,1/scale);
t = t(1:h,1:w);
% Problem: in sky region: darkI(x) / A > 1 ==> t < 0  
%t = t.*(t>t_threshold); t = t + (t==0).*0.1; % t = max(t, to)

% From (1): J(x) = (I(x) - A(1-t(x))) / t
J = (im - A*(1-t)) ./ t;
end

