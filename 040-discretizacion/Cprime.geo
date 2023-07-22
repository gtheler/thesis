/*
0.141347        1.8917  0.39241
0.826048        3.553   3.5069
0.218324        0.218324        0.218324

*/
Point (0) = {0.141347, 0.826048, 0.218324};
Point (1) = {1.8917, 3.553, 0.218324};
Point (2) = {0.39241, 3.5069, 0.218324};

Line (1) = {0, 1};
Line (2) = {1, 2};
Line (3) = {2, 0};

Curve loop (1) = {1, 2, 3};
Plane Surface(1) = {1};

Point(3) = {0,0,0};
Point(4) = {4,0,0};
Point(5) = {0,4,0};
Point(6) = {0,0,4};

Line (4) = {3, 4};
Line (5) = {3, 5};
Line (6) = {3, 6};


Geometry.PointLabels = 1;
Geometry.LabelType = 1;
Geometry.PointSize = 20;
Geometry.CurveWidth = 5;
Geometry.Points = 1;
Geometry.Surfaces = 0;
Geometry.Volumes = 0;
Geometry.Color.Points = {0,0,0};
Geometry.Color.Curves = {0,0,0};

General.TrackballQuaternion0 = 0.2564790824281484;
General.TrackballQuaternion1 = 0.6046292679959999;
General.TrackballQuaternion2 = 0.7003204496350517;
General.TrackballQuaternion3 = 0.2983329327911051;
General.ScaleX = 0.6206058692136839;
General.ScaleY = 0.6206058692136839;
General.ScaleZ = 0.6206058692136839;
