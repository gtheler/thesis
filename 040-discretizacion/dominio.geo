lc = 0.5;
Point(1) = {0, 0, 0, lc};
Point(2) = {0, -1, -0, lc};
Point(3) = {-1, -0, -0, lc};
Point(4) = {0.6, -1, 0, lc};
Point(5) = {1.3, -0.7, -0, lc};
Point(6) = {1.7, 0.2, -0, lc};
Point(7) = {0.7, 0.9, -0, lc};
Point(8) = {0, 0.6, -0, lc};
Point(9) = {-0.5, 0.7, -0, lc};
Point(10) = {-1, 0.4, -0, lc};
Spline(1) = {2, 4, 5, 6, 7, 8, 9, 10, 3};
Circle(2) = {3, 1, 2};

Line Loop(3) = {1, 2};
Plane Surface(4) = {3};

Physical Curve("neumann", 1) = {1};
Physical Curve("dirichlet", 2) = {2};
Physical Surface("domain", 3) = {4};


RecombineAll = 0;


General.Axes = 0;
General.SmallAxes = 0;

Geometry.Light = 0;
Geometry.LightTwoSide = 0;
Geometry.Points = 0;
Geometry.Color.Curves = {255,74,106};

Color Magenta{ Curve{ 1 }; }
Color DarkCyan{ Curve{ 2 }; }


Mesh.ColorCarousel = 2;
Mesh.Light = 0;

Mesh.NodeSize = 12;
Mesh.Nodes = 1;
Mesh.Lines = 0;
Mesh.SurfaceFaces = 0;
Mesh.VolumeEdges = 0;


Mesh.Color.Zero = {255,0,0};
Mesh.Color.One = {200,80,80};
Mesh.Color.Two = {80,200,200};
Mesh.Color.Three = {90,90,90};

Mesh.MshFileVersion = 2.2;
