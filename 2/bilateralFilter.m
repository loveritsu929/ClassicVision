%bilateral
img = im2double(imread('./on.jpg'));
gray = rgb2gray(img);
istd=std2(gray);
noise = imnoise(gray,'gaussian',0,istd);

DoS = 2;
spatial_sigma = 3;

tic
img_f = imbilatfilt(noise,DoS,spatial_sigma);
toc

mse = immse(img_f,gray);
fprintf('DoS = %.f, s_sigma = %.4f, bilateral MSE = %.4f\n',DoS,spatial_sigma,mse);


figure(1)
%subplot(1,2,1);imshow(noise);title('noise');
imagesc(img_f);colormap gray;title('bilateral filtered image');