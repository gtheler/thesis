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
Mesh.Algorithm = 6;

// Mesh.Algorithm = 9;
// MeshAlgorithm Surface {64} = 6; // MeshAdapt on surfaces 31 and 35

// 3D mesh algorithm (1: Delaunay, 3: Initial mesh only, 4: Frontal, 7: MMG3D, 9: R-tree, 10: HXT)
// Mesh.Algorithm3D = 10; 

Mesh.RecombineAll = 0;
Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
Mesh.ElementOrder = 1;


// lc = 10
//   DOFs = 250608
//   keff = 0.99447
//   wall = 1557.4 sec
// average memory = 36.7 Gb
//  global memory = 36.7 Gb


// lc = 15 deberia tomar 
//   DOFs = 110928
//   keff = 0.99648
//   wall = 341.9 sec
// average memory = 13.1 Gb
//  global memory = 13.1 Gb
//  
//  
//   DOFs = 110928
//   keff = 0.99648
//   wall = 208.0 sec
// average memory = 11.7 Gb
//  global memory = 11.7 Gb
//  



lc = 15;
MeshSize {:} = lc;
Mesh.MeshSizeMin = 0.5*lc;
Mesh.MeshSizeMax = 1.0*lc;

//n = 2;

// esto tarda unos 10 mins con 4 ranks
// time mpiexec -n 4 feenox iaea-3dpwr-s4.fee --progress --eps_monitor --st_mat_mumps_icntl_14=200
//   wall = 607.1 sec
// average memory = 12.1 Gb
//  global memory = 48.5 Gb
// n = 1.5;

// este se queda sin memoria (64gb) con mumps incluso con 1 ranks
// n = 1.25;


// Mesh.MeshSizeExtendFromBoundary = 1;

// Field[1] = Extend;
// Field[1].SurfacesList = 64;
// Field[1].DistMax = 50;
// Field[1].SizeMax = 2.5;
// Field[1].Power = 2;
// Background Field = 1;

