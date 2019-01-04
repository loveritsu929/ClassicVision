function [darkImg] = getDark(im, windowSize)
% Dark Channel Prior: J_dark(x) = minFilter(min J_c(y)) = 0
% windowSize = 3~15;
darkImg = min(im,[],3); darkImg = ordfilt2(darkImg,1,ones(windowSize,windowSize));
end

