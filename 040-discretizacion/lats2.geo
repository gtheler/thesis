// Merge "octant.geo";

// S2 - n = 0
x = 5.773503e-01;
y = 5.773503e-01;
z = 5.773503e-01;

Point(101) = {x, y, z, lc};

Point(102) = {x, 0, 0, lc};
Point(103) = {x, Sqrt(1-x^2), 0, lc};
Point(104) = {x, 0, Sqrt(1-x^2), lc};
Circle(101) = {104, 102, 103};

Point(105) = {0, y, 0, lc};
Point(106) = {0, y, Sqrt(1-y^2), lc};
Point(107) = {Sqrt(1-y^2), y, 0, lc};
Circle(102) = {106, 105, 107};

Point(108) = {0, 0, z, lc};
Point(109) = {0, Sqrt(1-z^2), z, lc};
Point(110) = {Sqrt(1-z^2), 0, z, lc};
Circle(103) = {110, 108, 109};

Line(104) = {1, 101};


