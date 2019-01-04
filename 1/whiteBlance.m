function im = whiteBlance(im,top,bottom,left,right)
src = imread(im);
im = imread(im);
im = im2double(im);
%Aera of the standard white
crop = im(top:bottom,left:right,:);

R = crop(:,:,1); 
G = crop(:,:,2); 
B = crop(:,:,3);

avgR = mean(mean(R));
avgG = mean(mean(G));
avgB = mean(mean(B));

K = (avgR + avgG +avgB) / 3;

Kr = K/avgR;
Kg = K/avgG;
Kb = K/avgB;

%update, scale the whole image
im(:,:,1) = im(:,:,1)*Kr;
im(:,:,2) = im(:,:,2)*Kg;
im(:,:,3) = im(:,:,3)*Kb;

figure;
subplot(1,2,1);imagesc(src);
%axis equal;
title('before');
subplot(1,2,2);imagesc(im);
%axis equal;
title('after');

end

