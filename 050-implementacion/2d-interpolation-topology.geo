//+
SetFactory("OpenCASCADE");
Point(1) = { -1, -1, 0};
Point(2) = { -1,  0, 0};
Point(3) = { -1, +2, 0};
Point(4) = {  0, -1, 0}; 
Point(5) = {  0.5,  0.5, 0};
Point(6) = {  0, +2, 0};
Point(7) = { +3, -1, 0}; 
Point(8) = { +3,  0, 0};
Point(9) = { +3, +2, 0}; 

Line(1) = {1, 4};
Line(2) = {4, 7};
Line(3) = {7, 8};
Line(4) = {8, 9};
Line(5) = {9, 6};
Line(6) = {6, 3};
Line(7) = {3, 2};
Line(8) = {2, 1};
Line(9) = {2, 5};
Line(10) = {5, 4};
Line(11) = {5, 6};
Line(12) = {5, 8};

Curve Loop(1) = {1, -10, -9, 8};
Plane Surface(1) = {1};
Curve Loop(2) = {2, 3, -12, 10};
Plane Surface(2) = {2};
Curve Loop(3) = {12, 4, 5, -11};
Plane Surface(3) = {3};
Curve Loop(4) = {6, 7, 9, 11};
Plane Surface(4) = {4};

Mesh.RecombineAll = 1;
Transfinite Line {1:12} = 1+1;
