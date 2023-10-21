SetFactory("OpenCASCADE");
Merge "iaea-3dpwr-eighth-circular.step";
Coherence;

Physical Volume("fuel1", 1) = {9};
Physical Volume("fuel2", 2) = {1};
Physical Volume("fuel2rod", 3) = {7, 2, 8, 3};
Physical Volume("reflector", 4) = {11};
Physical Volume("reflrod", 5) = {4, 5, 6, 10};

Physical Surface("mirror", 6) = {7, 14, 23, 51, 19, 61, 27, 63, 31, 62, 36, 40, 60, 3, 50, 41, 49, 39, 34, 58, 56};
Physical Surface("vacuum", 7) = {59, 24, 28, 35, 55, 57, 64};

Merge "iaea-colors.geo";

// meshing options
// (1: MeshAdapt, 2: Automatic, 3: Initial mesh only, 5: Delaunay, 6: Frontal-Delaunay, 7: BAMG, 8: Frontal-Delaunay for Quads, 9: Packing of Parallelograms, 11: Quasi-structured Quad)
// Mesh.Algorithm = 6;

Mesh.Algorithm = 8;
MeshAlgorithm Surface {64} = 6; // MeshAdapt on surfaces 31 and 35

// 3D mesh algorithm (1: Delaunay, 3: Initial mesh only, 4: Frontal, 7: MMG3D, 9: R-tree, 10: HXT)
Mesh.Algorithm3D = 10; 

Mesh.RecombineAll = 0;
Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
Mesh.ElementOrder = 2;

Mesh.MeshSizeMin = 10/Mesh.ElementOrder;
Mesh.MeshSizeMax = 20/Mesh.ElementOrder;

