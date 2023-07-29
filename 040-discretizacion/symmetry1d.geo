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

theta = Pi/5;
phi = Pi/5;
x = Cos(theta);
y = 0;
z = Sin(theta);
d = 0.03;
Point(100) = {x, 0, z, 1.0};
Point(101) = {x, 0, 0, 1.0};
Point(102) = {x, 0, -z, 1.0};
Point(103) = {x, -z, 0, 1.0};
Point(104) = {x, +z, 0, 1.0};

Line(15) = {1, 100};
Line(16) = {100, 101};


// circulo
Circle(17) = {100, 101, 103};
Circle(18) = {103, 101, 102};
Circle(19) = {102, 101, 104};
Circle(20) = {104, 101, 100};
Line(21) = {1, 103};
Line(22) = {1, 102};
Line(23) = {1, 104};

General.RotationX = 290;
General.RotationY = 0;
General.RotationZ = 300;
General.Trackball = 0;
