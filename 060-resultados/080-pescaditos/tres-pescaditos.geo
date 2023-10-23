Merge "vars.geo";

x1 = -10;    // centro del pescado 1
y1 = 5;

x2 = 25;     // centro del pescado 2
y2 = -15;

Merge "x3.geo";

SetFactory("OpenCASCADE");
Disk(1) = {0, 0, 0, A};
Disk(2) = {x1, y1, 0, a};
Disk(3) = {x2, y2, 0, a};
Disk(4) = {x3, y3, 0, a};
Coherence;

Physical Curve("external") = {1};
Physical Surface("fuel") = {5};
Physical Surface("pescadito") = {2,3,4};

Color Cyan      { Surface{5}; }
Color Maroon    { Surface{2,3,4}; }

Mesh.Algorithm = 9;
Mesh.MeshSizeMax = A/25;
Mesh.MeshSizeFromCurvature = 16;
Mesh.Optimize = 1;
