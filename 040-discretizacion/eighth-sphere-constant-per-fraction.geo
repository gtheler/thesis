SetFactory("OpenCASCADE");
Sphere(1) = {0, 0, 0, 1, 0, Pi/2, Pi/2};
Point(5) = {1/Sqrt(3), 1/Sqrt(3), 1/Sqrt(3)};
Point(6) = {0, 1/Sqrt(2), 1/Sqrt(2)};
Point(7) = {1/Sqrt(2), 0, 1/Sqrt(2)};
Point(8) = {1/Sqrt(2), 1/Sqrt(2), 0};
Circle(8) = {6, 4, 5};
Circle(9) = {5, 4, 8};
Circle(10) = {5, 4, 7};

BooleanFragments{ Curve{10}; Curve{8}; Curve{9}; Delete; }{ Curve{4}; Curve{3}; Curve{2}; Delete; }
BooleanFragments{ Curve{10}; Delete; }{ Curve{9}; Delete; }
Coherence;
Recursive Delete {
  Volume{1}; 
}
Curve Loop(1) = {10, -11, 13, -9};
Surface(1) = {1};
Curve Loop(3) = {8, 9, 14, 15};
Surface(2) = {3};
Curve Loop(5) = {16, -12, -10, -8};
Surface(3) = {5};

n = 12;
Mesh.MeshSizeMax = 1/n;
Mesh.MeshSizeMin = 1/n;
Mesh.ElementOrder = 2;
Mesh.RecombineAll = 0;
Mesh.Optimize = 1;

Physical Surface("one") = {1};
Physical Surface("two") = {2};
Physical Surface("three") = {3};



General.AxesLabelX = "x";
General.AxesLabelY = "y";
General.AxesLabelZ = "z";
General.Axes = 4;
General.AxesAutoPosition = 0;
General.BoundingBoxSize = 2.75;
General.GraphicsHeight = 1000;
General.GraphicsWidth = 1920;
General.RotationX = 20.41951127265298;
General.RotationY = 340.3872739290072;
General.RotationZ = 359.5149933766793;
General.ScaleX = 1.29327725571369;
General.ScaleY = 1.29327725571369;
General.ScaleZ = 1.29327725571369;
General.SmallAxes = 0;
General.TrackballQuaternion0 = -0.1753703697831037;
General.TrackballQuaternion1 = 0.1668812536003668;
General.TrackballQuaternion2 = 0.03429374270766492;
General.TrackballQuaternion3 = 0.9696493282677046;
General.TranslationX = -0.07938101731569652;
General.TranslationY = -0.1324043660885381;
Geometry.Points = 0;
Geometry.Color.Curves = {26,26,26};
Mesh.ColorCarousel = 2;
Mesh.LightLines = 1;
Mesh.LightTwoSide = 0;
Mesh.SmoothNormals = 1;
Mesh.SurfaceEdges = 0;
Mesh.SurfaceFaces = 1;
Mesh.Color.One = {209,70,3};
Mesh.Color.Two = {102,216,165};
Mesh.Color.Three = {237,202,7};

Mesh 2;
Print "eighth-sphere-constant-per-fraction.svg";
Print "eighth-sphere-constant-per-fraction.png";

