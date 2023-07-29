General.SmallAxes = 0;

lc = 0.1;
Point(1) = {0, 0, 0, lc};
Point(2) = {1, 0, 0, lc};
Point(3) = {0, 1, 0, lc};
Point(4) = {0, 0, 1, lc};

View "comments" {
  T3(1.1, 0,  0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "x" };
  T3(0, 1.05, 0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "y" };
  T3(0, 0,  1.02, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "z" };
};

Line(1) = {1, 4};
Line(2) = {1, 2};
Line(3) = {1, 3};
Circle(4) = {2, 1, 3};
Circle(5) = {3, 1, 4};
Circle(6) = {4, 1, 2};

Line Loop(7) = {1, -5, -3};
Plane Surface(8) = {7};

Line Loop(9) = {2, -6, -1};
Plane Surface(10) = {9};

Line Loop(11) = {3, -4, -2};
Plane Surface(12) = {11};

Line Loop(13) = {5, 6, 4};
Ruled Surface(14) = {13};

