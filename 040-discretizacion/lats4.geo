// Merge "octant.geo";

// S4 - n = 0
x = 3.500212e-01;
y = 3.500212e-01;
z = 8.688903e-01;

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


// S4 - n = 1
x = 3.500212e-01;
y = 8.688903e-01;
z = 3.500212e-01;

Point(201) = {x, y, z, lc};

Point(202) = {x, 0, 0, lc};
Point(203) = {x, Sqrt(1-x^2), 0, lc};
Point(204) = {x, 0, Sqrt(1-x^2), lc};
Circle(201) = {204, 202, 203};

Point(205) = {0, y, 0, lc};
Point(206) = {0, y, Sqrt(1-y^2), lc};
Point(207) = {Sqrt(1-y^2), y, 0, lc};
Circle(202) = {206, 205, 207};

Point(208) = {0, 0, z, lc};
Point(209) = {0, Sqrt(1-z^2), z, lc};
Point(210) = {Sqrt(1-z^2), 0, z, lc};
Circle(203) = {210, 208, 209};

Line(204) = {1, 201};


// S4 - n = 2
x = 8.688903e-01;
y = 3.500212e-01;
z = 3.500212e-01;

Point(301) = {x, y, z, lc};

Point(302) = {x, 0, 0, lc};
Point(303) = {x, Sqrt(1-x^2), 0, lc};
Point(304) = {x, 0, Sqrt(1-x^2), lc};
Circle(301) = {304, 302, 303};

Point(305) = {0, y, 0, lc};
Point(306) = {0, y, Sqrt(1-y^2), lc};
Point(307) = {Sqrt(1-y^2), y, 0, lc};
Circle(302) = {306, 305, 307};

Point(308) = {0, 0, z, lc};
Point(309) = {0, Sqrt(1-z^2), z, lc};
Point(310) = {Sqrt(1-z^2), 0, z, lc};
Circle(303) = {310, 308, 309};

Line(304) = {1, 301};


