// Merge "octant.geo";

// S6 - n = 0
x = 2.666355e-01;
y = 2.666355e-01;
z = 9.261809e-01;

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


// S6 - n = 1
x = 2.666355e-01;
y = 6.815077e-01;
z = 6.815077e-01;

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


// S6 - n = 2
x = 6.815077e-01;
y = 2.666355e-01;
z = 6.815077e-01;

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


// S6 - n = 3
x = 6.815077e-01;
y = 6.815077e-01;
z = 2.666355e-01;

Point(401) = {x, y, z, lc};

Point(402) = {x, 0, 0, lc};
Point(403) = {x, Sqrt(1-x^2), 0, lc};
Point(404) = {x, 0, Sqrt(1-x^2), lc};
Circle(401) = {404, 402, 403};

Point(405) = {0, y, 0, lc};
Point(406) = {0, y, Sqrt(1-y^2), lc};
Point(407) = {Sqrt(1-y^2), y, 0, lc};
Circle(402) = {406, 405, 407};

Point(408) = {0, 0, z, lc};
Point(409) = {0, Sqrt(1-z^2), z, lc};
Point(410) = {Sqrt(1-z^2), 0, z, lc};
Circle(403) = {410, 408, 409};

Line(404) = {1, 401};


// S6 - n = 4
x = 9.261809e-01;
y = 2.666355e-01;
z = 2.666355e-01;

Point(501) = {x, y, z, lc};

Point(502) = {x, 0, 0, lc};
Point(503) = {x, Sqrt(1-x^2), 0, lc};
Point(504) = {x, 0, Sqrt(1-x^2), lc};
Circle(501) = {504, 502, 503};

Point(505) = {0, y, 0, lc};
Point(506) = {0, y, Sqrt(1-y^2), lc};
Point(507) = {Sqrt(1-y^2), y, 0, lc};
Circle(502) = {506, 505, 507};

Point(508) = {0, 0, z, lc};
Point(509) = {0, Sqrt(1-z^2), z, lc};
Point(510) = {Sqrt(1-z^2), 0, z, lc};
Circle(503) = {510, 508, 509};

Line(504) = {1, 501};


// S6 - n = 5
x = 2.666355e-01;
y = 9.261809e-01;
z = 2.666355e-01;

Point(601) = {x, y, z, lc};

Point(602) = {x, 0, 0, lc};
Point(603) = {x, Sqrt(1-x^2), 0, lc};
Point(604) = {x, 0, Sqrt(1-x^2), lc};
Circle(601) = {604, 602, 603};

Point(605) = {0, y, 0, lc};
Point(606) = {0, y, Sqrt(1-y^2), lc};
Point(607) = {Sqrt(1-y^2), y, 0, lc};
Circle(602) = {606, 605, 607};

Point(608) = {0, 0, z, lc};
Point(609) = {0, Sqrt(1-z^2), z, lc};
Point(610) = {Sqrt(1-z^2), 0, z, lc};
Circle(603) = {610, 608, 609};

Line(604) = {1, 601};


