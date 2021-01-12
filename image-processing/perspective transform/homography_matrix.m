% Estimates a homography matrix, given set of four point pairs
% Uses the estimated homography matrix to achieve perspective transform

prompt_pp1 = {'Enter x1:','Enter y1:','Enter x1*:','Enter y1*'};
prompt_pp2 = {'Enter x2:','Enter y2:','Enter x2*:','Enter y2*'};
prompt_pp3 = {'Enter x3:','Enter y3:','Enter x3*:','Enter y3*'};
prompt_pp4 = {'Enter x4:','Enter y4:','Enter x4*:','Enter y4*'};
dlgtitle = 'Enter point pair: (x, y) -> (x*, y*)';
dims = [1 100];

pp1 = inputdlg(prompt_pp1,dlgtitle,dims);
pp2 = inputdlg(prompt_pp2,dlgtitle,dims);
pp3 = inputdlg(prompt_pp3,dlgtitle,dims);
pp4 = inputdlg(prompt_pp4,dlgtitle,dims);

% extract point pair 1
x1 = str2double(pp1{1});
y1 = str2double(pp1{2});
x1d = str2double(pp1{3});
y1d = str2double(pp1{4});

% extract point pair 2
x2 = str2double(pp2{1});
y2 = str2double(pp2{2});
x2d = str2double(pp2{3});
y2d = str2double(pp2{4});

% extract point pair 3
x3 = str2double(pp3{1});
y3 = str2double(pp3{2});
x3d = str2double(pp3{3});
y3d = str2double(pp3{4});

% extract point pair 4
x4 = str2double(pp4{1});
y4 = str2double(pp4{2});
x4d = str2double(pp4{3});
y4d = str2double(pp4{4});

A = [x1 y1 1 0 0 0 -x1*x1d -y1*x1d ;
    0 0 0 x1 y1 1 -x1*y1d -y1*y1d ;
    x2 y2 1 0 0 0 -x2*x2d -y2*x2d ;
    0 0 0 x2 y2 1 -x2*y2d -y2*y2d ;
    x3 y3 1 0 0 0 -x3*x3d -y3*x3d ;
    0 0 0 x3 y3 1 -x3*y3d -y3*y3d ;
    x4 y4 1 0 0 0 -x4*x4d -y4*x4d ;
    0 0 0 x4 y4 1 -x4*y4d -y4*y4d ];

b = [x1d ; y1d ; x2d ; y2d ; x3d ; y3d ; x4d ; y4d ];

h = A\b;
h(9) = 1;

H = reshape(h,[3,3]);
H = H';

disp('Homography matrix:')
disp(H)

H_inv = inv(H);

disp('Inverse homography matrix:')
disp(H_inv)