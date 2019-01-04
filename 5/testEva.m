clear
hazelist = dir('C:\Users\lover\Desktop\EECS 4422\proj\compare\haze\*.bmp');
freelist = dir('C:\Users\lover\Desktop\EECS 4422\proj\compare\haze-free\*.bmp');

% name -- filename
% date -- modification date
% bytes -- number of bytes allocated to the file
% isdir -- 1 if name is a directory and 0 if not

len = length(hazelist);

MSE = zeros(len,1);
Entropy =zeros(len,1);

J = cell(len,1);
imgs = cell(len,1);
freeimgs = cell(len,1);
for i = 1:len
    im = imread(strcat('C:\Users\lover\Desktop\EECS 4422\proj\compare\haze\',hazelist(i).name));
    freeim = imread(strcat('C:\Users\lover\Desktop\EECS 4422\proj\compare\haze-free\',freelist(i).name));
    im = im2double(im);
    freeim = im2double(freeim);
    imgs{i} = im;
    freeimgs{i} = freeim;
end

tic
for i = 1:len
    J{i} = dehaze(imgs{i},0.05);
end
toc

for i = 1:len
    MSE(i) = immse(freeimgs{i},J{i});
    Entropy(i) = (entropy(J{i}(:,:,1)) + entropy(J{i}(:,:,2)) + entropy(J{i}(:,:,3)))/3;
end

avgMSE = sum(MSE(:))/len;
avgEntropy = sum(Entropy(:))/len;

