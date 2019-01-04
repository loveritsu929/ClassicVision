function [ kp ] = SSExtrema( DoGPyr )
% Find keypoints (scalespace extrema) in DoG
% DoGPyr: the Difference of Gaussian pyramid

noct = length(DoGPyr);
ns = size(DoGPyr{1},3) - 2;

kp = cell(noct,1); % kp is a cell array of length noctaves containg kps
for m = 1:noct
    kp{m} = cell(ns,1); % element in kp is a cell array over the ns subbands
end


% find kps
% Notice:
% I have developed another SSE2 function to find the local extrema
% simply constructing a 3*3*3 cube then comparing the value with the extrema 
% within the cube.
% For example:
%  stack(:,:,1) = above(row-1:row+1,col-1:col+1);
%  stack(:,:,2) = subband(row-1:row+1,col-1:col+1);
%  stack(:,:,3) = below(row-1:row+1,col-1:col+1);
% That SSE2 took 33.66s to run on the test image
% while this SSExtrema using 27 channels took only 18.83s.
% So this method is more efficient.
for m = 1:noct
    [h, w] = size(DoGPyr{m}(:,:,1));
    for n = 2:ns+1
        subband = DoGPyr{m}(:,:,n);
        above = DoGPyr{m}(:,:,n+1);
        below = DoGPyr{m}(:,:,n-1);
        
        % construct the stack of shifted subbands
        stack = zeros(h, w, 27);
        rightBot = circshift(subband,[-1,-1]); 
        rightBot_above = circshift(above,[-1,-1]); 
        rightBot_below = circshift(below,[-1,-1]); 
        %stack(:,:,1) = rightBot;
        channel = 1;
        
        % channel5 is the original subband img 
        bands = cell(3,1);
        bands{1} = rightBot;
        bands{2} = rightBot_above;
        bands{3} = rightBot_below;
        
        for i = 1:3
            for v_shift = 0:2
                for h_shift = 0:2
                     stack(:,:,channel) = circshift(bands{i},[v_shift,h_shift]);
                     channel = channel +1;
                end
            end
        end        
        
        numMax = 0;
        numMin = 0;
        % discard pixels at borders: do not have 8 neighbours
        for row = 2:h-1
            for col = 2:w-1
                % if pixel subband(row,col) is extrema => keypoint
                if subband(row,col) == max(stack(row,col,:),[],'includenan')
                   numMax = numMax + 1;
                   kp{m}{n-1}.max(numMax,:) = [row col subband(row,col)];
                   
                elseif subband(row,col) == min(stack(row,col,:),[],'includenan')
                   numMin = numMin + 1;
                   kp{m}{n-1}.min(numMin,:) = [row col subband(row,col)];
                   
                end
            end
        end
    end
end



end

