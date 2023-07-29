General.SmallAxes = 0;

lc = 0.1;
Point(1) = {0, 0, 0, lc};

Point(2) = {1, 0, 0, lc};
Point(3) = {0, 1, 0, lc};
Point(4) = {0, 0, 1, lc};

Point(5) = {-1, 0, 0, lc};
Point(6) = {0, -1, 0, lc};
Point(7) = {0, 0, -1, lc};

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

View "comments" {
  T3( 0.5, 0.5,  0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "0" };
  T3(-0.5, 0.5,  0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "1" };
  T3( 0.5,-0.5,  0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "2" };
  T3(-0.5,-0.5,  0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "3" };
  T3( 0.5, 0.5, -0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "4" };
  T3(-0.5, 0.5, -0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "5" };
  T3( 0.5,-0.5, -0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "6" };
  T3(-0.5,-0.5, -0.5, TextAttributes("Align", "Center", "Font", "Times-Italic")){ "7" };
};

General.RotationX = 285; // First Euler angle (used if Trackball=0)
General.RotationY = 0; // Second Euler angle (used if Trackball=0)
General.RotationZ = 330; // Third Euler angle (used if Trackball=0)
General.Trackball = 0; // Use trackball rotation mode
