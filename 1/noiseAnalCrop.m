function noise = noiseAnalCrop(im,top,bottom,left,right)
img1 = imread(im);
img1 = im2double(img1);
img1 = img1(top:bottom,left:right,:);

%size = size(img1);
lu_img = mean(img1,3);

%imshow(lu_img);
%hist = histogram(lu_img,20)

lu_mean = mean2(lu_img);
lu_std = std2(lu_img);

noise = lu_std / lu_mean;
end

