Merge "vars.geo";

SetFactory("OpenCASCADE");
Disk(1) = {0, 0, 0, A};

Physical Curve("external") = {1};
Physical Surface("fuel") = {1};

Color Cyan      { Surface{1}; }

Mesh.Algorithm = 9;
Mesh.MeshSizeMax = A/30;
Mesh.MeshSizeFromCurvature = 16;
Mesh.Optimize = 1;

