A = $1;     // radio del reactor
a = $2;     // radio del pescadito
r = $3;     // posicion radial del pescadito
lc = $4;    // longitud caracteristica de la malla

Mesh.Algorithm = 8;              // algoritmo de mallado delaunay

Point(1) = { 0, 0, 0, lc};       // el circulo grande de radio A
Point(2) = { A, 0, 0, lc};
Point(3) = {-A, 0, 0, lc};
Point(4) = { 0, A, 0, lc};
Point(5) = { 0,-A, 0, lc};
Circle(1) = {5, 1, 2};
Circle(2) = {2, 1, 4};
Circle(3) = {4, 1, 3};
Circle(4) = {3, 1, 5};
Line Loop(13) = {2, 3, 4, 1};

Point(8) = {r, 0, 0, 0.5*lc};    // el pescadito de radio a
Point(10) = {r+a, 0, 0, 0.5*lc}; // y malla refinada
Point(11) = {r, a, 0, 0.5*lc};
Point(12) = {r-a, 0, 0, 0.5*lc};
Point(13) = {r, -a, 0, 0.5*lc};
Circle(5) = {13, 8, 10};
Circle(6) = {10, 8, 11};
Circle(7) = {11, 8, 12};
Circle(8) = {12, 8, 13};
Line Loop(14) = {6, 7, 8, 5};

Plane Surface(16) = {13, 14};    // las superficies (con los huecos)
Recombine Surface (16);
Plane Surface(17) = {14};
Recombine Surface (17);

Physical Line(1) = {2, 1, 4, 3};      // superficie externa
Physical Surface("fuel") = {16};      // fuel
Physical Surface("pescadito") = {17}; // pescadito

Color SeaGreen  { Surface{16}; }
Color Maroon    { Surface{17}; }
