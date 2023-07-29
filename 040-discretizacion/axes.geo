General.SmallAxes = 0;

lc = 0.1;
Point(1) = {0, 0, 0, lc};

Point(2) = {1.2, 0, 0, lc};
Point(3) = {0, 1.2, 0, lc};
Point(4) = {0, 0, 1.2, lc};

Point(5) = {-1.2, 0, 0, lc};
Point(6) = {0, -1.2, 0, lc};
Point(7) = {0, 0, -1.2, lc};

View "comments" {
  T3(1.25, 0,  0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "x+" };
  T3(0, 1.2, 0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "y+" };
  T3(0, 0,  1.25, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "z+" };

  T3(-1.25, 0,  0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "x-" };
  T3(0, -1.2, 0, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "y-" };
  T3(0, 0,  -1.25, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "z-" };
};

Line(1) = {1, 2};
Line(2) = {1, 5};
Line(3) = {1, 3};
Line(4) = {1, 6};
Line(5) = {1, 4};
Line(6) = {1, 7};
