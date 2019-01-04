% 4422 Computer Vision Project
clear

%Y=ordfilt2(X,1,ones(3,3)) => minFilter
%im = imread('./haze images/canon3.bmp');
%resim = imread('./haze images/canon3_res.png');
im1 = imread('canon3.bmp');
im1 = im2double(im1);
im2 = imread('forest.jpg');
im2 = im2double(im2);
% Dark Channel Prior: J_dark(x) = minFilter(min J_c(y)) = 0
darkImg1 = getDark(im1,3);
darkImg2 = getDark(im2,3);

J1 = dehaze(im1,darkImg1);
J2 = dehaze(im2,darkImg2);

%SUBPLOT('position',[left bottom width height])

subplot('position', [0,0, 0.475, 1]);imshow(im1);title("(a1)");
subplot('position', [0.5,0, 0.475, 1]);imshow(J1);title("(a2)");
subplot('position', [0,0, 0.475, 1]);imshow(im2);title("(b1)");
subplot('position', [0.5,0, 0.475, 1]);imshow(J2);title("(b2)");
%subplot(1,3,3);imshow(J);title("de-haze image")