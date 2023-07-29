General.SmallAxes = 0;

lc = 0.1;
Point(1) = {0, 0, 0, lc};

Point(2) = {1.2, 0, 0, lc};
Point(3) = {0, 1.2, 0, lc};
Point(4) = {0, 0, 0.8, lc};

Point(5) = {-1.2, 0, 0, lc};
Point(6) = {0, -1.2, 0, lc};
Point(7) = {0, 0, -0.8, lc};

View "comments" {
  T3(1.25, 0,  0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "x+" };
  T3(0, 1.2, 0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "y+" };
  T3(0, 0,  0.85, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "z+" };

  T3(-1.25, 0,  0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "x-" };
  T3(0, -1.2, 0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "y-" };
  T3(0, 0,  -0.85, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "z-" };
};

Line(1) = {1, 2};
Line(2) = {1, 5};
Line(3) = {1, 3};
Line(4) = {1, 6};
Line(5) = {1, 4};
Line(6) = {1, 7};

Point(12) = {1, 1, 0, lc};
Point(13) = {1, -1, 0, lc};
Point(14) = {-1, 1, 0, lc};
Point(15) = {-1, -1, 0, lc};

Line(11) = {12, 13};
Line(12) = {13, 15};
Line(13) = {15, 14};
Line(14) = {14, 12};

theta = Pi/3;
phi = Pi/5;
x = Cos(theta)*Cos(phi);
y = Cos(theta)*Sin(phi);
z = Sin(phi);
d = 0.03;
Point(100) = {x, y, z, 1.0};
Point(101) = {x, y, -z, 1.0};
Point(102) = {x, y, 0, 1.0};
Point(103) = {x, 0, 0, 1.0};
Point(104) = {0, y, 0, 1.0};

Line(100) = {1, 100};
Line(101) = {1, 101};
Line(102) = {100, 101};
Line(103) = {1, 102};
Line(104) = {103, 102};
Line(105) = {104, 102};


General.RotationX = 290;
General.RotationY = 0;
General.RotationZ = 300;
General.Trackball = 0;

