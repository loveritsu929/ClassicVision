function [ang] = getRot(x,y,pts)

h = length(x);
A = zeros(2*h,12);
for i = 1:2:2*h
    A(i,:) = [pts{(i+1)/2}(1) pts{(i+1)/2}(2) pts{(i+1)/2}(3) 1 0 0 0 0 -1*x((i+1)/2)*pts{(i+1)/2}(1) -1*x((i+1)/2)*pts{(i+1)/2}(2) -1*x((i+1)/2)*pts{(i+1)/2}(3) -1*x((i+1)/2)];
    A(i+1,:) = [0 0 0 0 pts{(i+1)/2}(1) pts{(i+1)/2}(2) pts{(i+1)/2}(3) 1 -1*y((i+1)/2)*pts{(i+1)/2}(1) -1*y((i+1)/2)*pts{(i+1)/2}(2) -1*y((i+1)/2)*pts{(i+1)/2}(3) -1*y((i+1)/2)];
end

[U,S,V] = svd(A);
P = V(:,12); 
P = reshape(P,4,3); P = P'; % P = reshape(P, 3, 4); P

A2 = P(:,1:3);
[Q1, R1] = qr(flipud(A2)');
Q1 = flipud(Q1');
R1 = flipud(fliplr(R1'));

if det(Q1) < 0
    Q1 = -1 * Q1;
end

axang = rotm2axang(Q1);
ang = radtodeg(axang(4));

end

