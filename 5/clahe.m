function [augImg] = clahe(dehazeImg)
%built in CLAHE alg. 

cform2lab = makecform('srgb2lab');
LAB = applycform(dehazeImg, cform2lab);
L = LAB(:,:,1);
LAB(:,:,1) = adapthisteq(L);
cform2srgb = makecform('lab2srgb');
augImg = applycform(LAB, cform2srgb);
end

