rc = 3.006375;
n = 80;

SetFactory("OpenCASCADE");
Point(1) = {0, 0, 0};
Point(2) = {rc, 0, 0};
Line(1) = {1, 2};

Physical Curve("fuel") = {1};
Physical Point("mirror") = {1};
Physical Point("vacuum") = {2};

Mesh.MeshSizeMax = rc/n;
Mesh.MeshSizeMin = rc/n;
Mesh.ElementOrder = 2;
