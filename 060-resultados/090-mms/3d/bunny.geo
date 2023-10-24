// https://upload.wikimedia.org/wikipedia/commons/4/43/Stanford_Bunny.stl
Merge "Stanford_Bunny.stl";
angle = 40;
includeBoundary = 1;
forceParametrizablePatches = 0;
curveAngle = 180;

ClassifySurfaces{angle * Pi/180, includeBoundary, forceParametrizablePatches, curveAngle * Pi / 180};
CreateGeometry;

// Create a volume as usual
Surface Loop(1) = Surface{:};
Volume(1) = {1};

Physical Volume("bunny") = {1};
Physical Surface("external") = {2,3};

Mesh.Algorithm = 6;
Mesh.Algorithm3D = 10;
Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
// Mesh.MeshSizeMin = 100;
Mesh.MeshSizeMax = 80;
Mesh.MeshSizeExtendFromBoundary = 0;
