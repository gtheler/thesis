Merge "vars.geo";

SetFactory("OpenCASCADE");
Disk(1) = {0, 0, 0, A};
Disk(2) = {+r, 0, 0, a};
Disk(3) = {-r, 0, 0, a};
Coherence;

Physical Curve("external") = {1};
Physical Surface("fuel") = {4};
Physical Surface("pescadito") = {2,3};

Color Cyan      { Surface{4}; }
Color Maroon    { Surface{2,3}; }

Mesh.Algorithm = 9;
Mesh.MeshSizeMax = A/25;
Mesh.MeshSizeFromCurvature = 16;
Mesh.Optimize = 1;
