function noise = noiseAnalDiff(im1,im2)
%im1 = 'light_on_3.jpg';
%im2 = 'light_on_2.jpg';

img1 = imread(im1);
img1 = im2double(img1);

img2 = imread(im2);
img2 = im2double(img2);

lu_img1 = mean(img1,3);
lu_img2 = mean(img2,3);

lu_diff_img = lu_img1 - lu_img2;

figure(1);
%imshow(lu_diff_img,[]);
histogram(lu_diff_img,60);
title('Histogram of luminance diff: light off');
xlabel('luminance difference');
ylabel('# of pixels');

lu_diff_mean = mean2(lu_diff_img);
lu_diff_std = std2(lu_diff_img);


noise = lu_diff_std / lu_diff_mean;

end

