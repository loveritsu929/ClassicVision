im = rgb2gray(im2double(imread('testimg.jpg')));

pyr = GSS(im,1.6,3,3);

dog = DoGSS(pyr);

tic
kp = SSExtrema(dog);
toc

showKP(dog,3,kp,20);