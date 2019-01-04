img = im2double(imread('./on.jpg'));
gray = rgb2gray(img);
mean2(gray);%0.6086
istd=std2(gray);%0.2508
%figure(2);imagesc(gray);colormap gray;

noise = imnoise(gray,'gaussian',0,istd);
%figure(3);imagesc(noise);colormap gray;title('Noisy Image');

beta =0.1;
fprintf('beta is %f\n',beta);

[f1,f2] = freqspace(size(img),'meshgrid'); % omega1,omega2
osquare = f1.^2 + f2.^2;
wfilter = (1./(1 + osquare./beta^2)); 
wfilter_s = fftshift(ifft2(ifftshift(wfilter)));

maxh = max(wfilter_s(:));
idx = find(abs(wfilter_s)<maxh*0.001);
wfilter_s(idx) = 0;

wfilter_s = wfilter_s / sum(wfilter_s(:));
sum(wfilter_s(:)); % =1

%shrink
wfilter_s(find(sum(abs(wfilter_s),2)==0),:)=[];
wfilter_s(:,find(sum(abs(wfilter_s),1)==0))=[];

tic
img_f = conv2(noise,wfilter_s,'same');
toc

mse = immse(img_f,gray);
fprintf('MSE = %.4f\n',mse);
figure(3); imagesc(img_f); colormap gray; axis image;title('filtered image when beta = 0.1');