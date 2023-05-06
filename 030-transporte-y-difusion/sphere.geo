SetFactory("OpenCASCADE");
Sphere(1) = {0, 0, 0, 1};
Mesh.MeshSizeMax = 5e-2;
Mesh.Algorithm = 6;
Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
Mesh.ElementOrder = 2;


