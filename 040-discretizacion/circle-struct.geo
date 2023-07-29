lc = 0.1;
a = 1;
Ntheta = 5;
Nr = 5;

Point(1) = {0, 0, 0, lc}; 
Point(2) = {a, 0, 0, lc};
Point(3) = {0, a, 0, lc};
Point(4) = {-a, 0, 0, lc};
Point(5) = {0, -a, 0, lc};


Line(1) = {1, 2};
Line(2) = {1, 3};
Line(3) = {1, 4};
Line(4) = {1, 5};

 
Circle(11) = {2, 1, 3};
Circle(12) = {3, 1, 4};
Circle(13) = {4, 1, 5};
Circle(14) = {5, 1, 2};


Line Loop(15) = {1, 11, -2};
Plane Surface(16) = {15};
Line Loop(17) = {2, 12, -3};
Plane Surface(18) = {17};
Line Loop(19) = {3, 13, -4};
Plane Surface(20) = {19};
Line Loop(21) = {4, 14, -1};
Plane Surface(22) = {21};

Transfinite Line {1,2,3,4} = Nr;
Transfinite Line {11,12,13,14} = Ntheta;
Transfinite Surface {16, 18, 20, 22};

Mesh.RecombineAll = 1;
Mesh.Light = 0;
