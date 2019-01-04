function x = LSPointLines(Lines)
%Lines is a 3 x n matrix
c = Lines(3,:);

%k = sqrt(a^2 + b^2)
k = sqrt(sum(Lines(1:2,:).^2));

%d = | c / sqrt(a^2 + b^2)|
d = abs(c ./ k);

%normalization
n = Lines(1:2,:) ./ k;% do we need to normalize this? ./ k; % 2 * n

%calculation
%part1
part1 = n * n';
part2 = zeros(2,1);
for i = 1:size(n,2)
    %prdt1 = n(:,i) * n(:,i)';
    %part1= part1 + prdt1;
    
    prdt2 = d(i) * n(:,i);
    part2 = part2 + prdt2;
end
%size(part1)
%size(part2)

x= inv(part1) * part2;

end

