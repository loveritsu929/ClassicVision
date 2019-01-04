clear
im = imread('./LSB.jpg');
figure(1);imshow(im);

% buiding dimension
% lsb_length = 78403.4; lsb_width = 40109.1; lsb_height = 18829.0; % unit: mm
lsb_length = 78.4034; lsb_width = 40.1091; lsb_height = 18.8290; % unit: m

% 6 points in world frame, top-left to right-bottom
pt1 = [0, lsb_length, lsb_height]; pt2 = [0, 0, lsb_height]; pt3 = [lsb_width, 0, lsb_height];
pt4 = [0, lsb_length, 0]; pt5 = [0, 0, 0]; pt6 = [lsb_width, 0, 0];
pts = {pt1 pt2 pt3 pt4 pt5 pt6};

% select 6 points
[x,y] = getpts;
hold on; scatter(x,y,150,'r','filled');

% intrinsic parameters
focalLen = 15.688 / 0.0047827; % unit: pixels
K = [focalLen, 0, 2459.0; 0, focalLen, 1629.6; 0, 0, 1];

%P = str2sym('[p00 p01 p02 p03 p10 p11 p12 p13 p20 p21 p22 p23]');
A = zeros(12,12);
for i = 1:2:12
    A(i,:) = [pts{(i+1)/2}(1) pts{(i+1)/2}(2) pts{(i+1)/2}(3) 1 0 0 0 0 -1*x((i+1)/2)*pts{(i+1)/2}(1) -1*x((i+1)/2)*pts{(i+1)/2}(2) -1*x((i+1)/2)*pts{(i+1)/2}(3) -1*x((i+1)/2)];
    A(i+1,:) = [0 0 0 0 pts{(i+1)/2}(1) pts{(i+1)/2}(2) pts{(i+1)/2}(3) 1 -1*y((i+1)/2)*pts{(i+1)/2}(1) -1*y((i+1)/2)*pts{(i+1)/2}(2) -1*y((i+1)/2)*pts{(i+1)/2}(3) -1*y((i+1)/2)];
end

[U,S,V] = svd(A);
P = V(:,12); 
P = reshape(P,4,3); P = P'; % P = reshape(P, 3, 4); P

% Q1 is the Rotation Matrix
A2 = P(:,1:3);
[Q1, R1] = qr(flipud(A2)');
Q1 = flipud(Q1');
R1 = flipud(fliplr(R1'));

if det(Q1) < 0
    Q1 = -1 * Q1;
end

% Scale the Translation Matrix
T = Q1 / P(:,1:3) * P(:,4);
P2 = [Q1 T];

% Reprojection
ptshomo = zeros(4,6);
for i = 1:6
    ptshomo(:,i) = [pts{i} 1];
end
reproj = P*ptshomo;
for i = 1:6
    reproj(:,i) = reproj(:,i) ./ reproj(3, i);
end
scatter(reproj(1,:), reproj(2,:), 150,'*g', 'LineWidth', 2);

axang = rotm2axang(Q1);
% Rotation Angle in degree
ang = radtodeg(axang(4));


% q3
i = 1;
bttimes = 50;
angs = zeros(bttimes,1);
while i < bttimes + 1
     btind = randi([1,6],6,1);
     %btind = [1 2 3 4 5 ];
     %btind = btind(randperm(length(btind)));
     %btind = [1 2 3 2 3 1 ];
    while length(unique(btind)) < 3
        btind = randi([1,6],6,1);
    end
    
    x_bt = zeros(length(btind),1);
    y_bt = zeros(length(btind),1);
    wpts = cell(1,length(btind));
    j = 1;
    while j < length(btind) + 1
        x_bt(j) = x(btind(j));
        y_bt(j) = y(btind(j));
        wpts{j} = pts{btind(j)};
        
        j=j+1;
    end
    
    angs(i) = getRot(x_bt, y_bt, wpts);
    i = i + 1;
end

uct = rms(angs-ang);


