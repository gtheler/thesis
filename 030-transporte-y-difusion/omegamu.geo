Point(1) = {-1.5, 0, 0, 1.0};
Point(2) = {+1.5, 0, 0, 1.0};
Line(1) = {1, 2};

Point(3) = {-1, 0, 0, 1.0};
Point(4) = { 0, 0, 0, 1.0};
Line(2) = {3, 4};

theta = Pi/3;
//phi = Pi/5;
Point(5) = {0, 0, 0, 1.0};
//Point(6) = {Cos(theta)*Cos(phi), Sin(theta)*Cos(phi), Sin(phi), 1.0};
x = Cos(theta);
y = Sin(theta);
d = 0.03;
Point(6) = {x, y, 0, 1.0};

Line(3) = {5, 6};

Point(7) = {x+d*Sin(theta), y-d*Sin(theta), 0, 1.0};
Point(8) = {x-d*Sin(theta), y+d*Sin(theta), 0, 1.0};

Point(9) = {(x+d*Sin(theta)), -(y-d*Sin(theta)), 0, 1.0};
Point(10) = {(x-d*Sin(theta)), -(y+d*Sin(theta)), 0, 1.0};

Point(11) = {(x+d*Sin(theta)), 0, 0, 1.0};
Point(12) = {(x-d*Sin(theta)), 0, 0, 1.0};

Point(13) = {(x+d*Sin(theta)), 0, -(y-d*Sin(theta)), 1.0};
Point(14) = {(x-d*Sin(theta)), 0, -(y+d*Sin(theta)), 1.0};

Point(15) = {(x+d*Sin(theta)), 0, +(y-d*Sin(theta)), 1.0};
Point(16) = {(x-d*Sin(theta)), 0, +(y+d*Sin(theta)), 1.0};
Circle(4) = {8, 12, 16};
Circle(5) = {16, 12, 10};

Circle(6) = {10, 12, 14};
Circle(7) = {14, 12, 8};
Circle(8) = {7, 11, 15};
Circle(9) = {15, 11, 9};
Circle(10) = {9, 11, 13};
Circle(11) = {13, 11, 7};
Line(12) = {7, 8};
Line(13) = {15, 16};
Line(14) = {9, 10};
Line(15) = {13, 14};
Line Loop(16) = {12, 4, -13, -8};
Line Loop(17) = {9, 14, -5, -13};
Ruled Surface(18) = {17};
Ruled Surface(19) = {16};
Line Loop(20) = {11, 12, -7, -15};
Ruled Surface(21) = {20};
Line Loop(22) = {6, -15, -10, 14};
Ruled Surface(23) = {22};

Point(101) = {x+d*Sin(theta), y-d*Sin(theta), -d, 1.0};
Point(102) = {x-d*Sin(theta), y+d*Sin(theta), -d, 1.0};
Point(103) = {x+d*Sin(theta), y-d*Sin(theta), +d, 1.0};
Point(104) = {x-d*Sin(theta), y+d*Sin(theta), +d, 1.0};


Line(24) = {103, 101};
Line(25) = {101, 102};
Line(26) = {102, 104};
Line(27) = {104, 103};
Line Loop(28) = {25, 26, 27, 24};
Plane Surface(29) = {28};


General.TrackballQuaternion0 = 0.1433946210161054; // First trackball quaternion component (used if General.Trackball=1)
General.TrackballQuaternion1 = -0.2652401388998151; // Second trackball quaternion component (used if General.Trackball=1)
General.TrackballQuaternion2 = -0.01605938347120752; // Third trackball quaternion component (used if General.Trackball=1)
General.TrackballQuaternion3 = -0.9533245761977227; // Fourth trackball quaternion component (used if General.Trackball=1)
