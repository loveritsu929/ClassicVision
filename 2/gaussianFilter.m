%gaussian
img = im2double(imread('./on.jpg'));
gray = rgb2gray(img);

noise = imnoise(gray,'gaussian',0,istd);

sigma = 4;

gFilter = fspecial('gaussian',[35,35],sigma);

tic
img_f = imfilter(noise,gFilter,'same');
toc

mse = immse(img_f,gray);
fprintf('sigma = %.4f, MSE = %.4f\n',sigma,mse);

figure(1)
%subplot(1,2,1);imshow(noise);title('noise');
imagesc(img_f);colormap gray;title('filtered image when sigma = 3');