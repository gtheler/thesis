Merge "vars.geo";

SetFactory("OpenCASCADE");
Disk(1) = {0, 0, 0, A};
Disk(2) = {r, 0, 0, a};
Coherence;

Physical Curve("external") = {1};
Physical Surface("fuel") = {3};
Physical Surface("pescadito") = {2};

Color Cyan      { Surface{3}; }
Color Maroon    { Surface{2}; }

Mesh.Algorithm = 9;
Mesh.MeshSizeMax = A/15;
Mesh.MeshSizeFromCurvature = 16;
Mesh.Optimize = 1;

