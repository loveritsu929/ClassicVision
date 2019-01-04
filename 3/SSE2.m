function [ kp ] = SSE2( DoGPyr )
% Find keypoints (scalespace extrema) in DoG
% DoGPyr: the Difference of Gaussian pyramid

noct = length(DoGPyr);
ns = size(DoGPyr{1},3) - 2;

kp = cell(noct,1); % kp is a cell array of length noctaves containg kps
for m = 1:noct
    kp{m} = cell(ns,1); % element in kp is a cell array over the ns subbands
end


% find kps
for m = 1:noct
    [h, w] = size(DoGPyr{m}(:,:,1));
    for n = 2:ns+1
        subband = DoGPyr{m}(:,:,n);
        above = DoGPyr{m}(:,:,n+1);
        below = DoGPyr{m}(:,:,n-1);     
        
        numMax = 0;
        numMin = 0;
        stack = zeros(3,3,3);
        % discard pixels at borders: do not have 8 neighbours
        for row = 2:h-1
            for col = 2:w-1
                stack(:,:,1) = above(row-1:row+1,col-1:col+1);
                stack(:,:,2) = subband(row-1:row+1,col-1:col+1);
                stack(:,:,3) = below(row-1:row+1,col-1:col+1);
                
                % if pixel subband(row,col) is extrema => keypoint
                if subband(row,col) == max(stack(:),[],'includenan')
                   numMax = numMax + 1;
                   kp{m}{n-1}.max(numMax,:) = [row col subband(row,col)];
                   
                elseif subband(row,col) == min(stack(:),[],'includenan')
                   numMin = numMin + 1;
                   kp{m}{n-1}.min(numMin,:) = [row col subband(row,col)];
                   
                end
            end
        end
    end
end



end

