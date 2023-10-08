A = 50;     // radio del reactor
a = 2;     // radio del pescadito
lc = 2;    // longitud caracteristica de la mallado

x1 = 10;    // centro del pescado 1
y1 = -5;

x2 = 0;    // centro del pescado 2
y2 = -7.5;

x3 = -6.12532;    // centro del pescado 3
y3 = 8.587;

Mesh.Algorithm = 8;

Point(1) = { 0, 0, 0, lc};             // el circulo grande
Point(2) = { A, 0, 0, lc};
Point(3) = {-A, 0, 0, lc};
Point(4) = { 0, A, 0, lc};
Point(5) = { 0,-A, 0, lc};
Circle(1) = {5, 1, 2};
Circle(2) = {2, 1, 4};
Circle(3) = {4, 1, 3};
Circle(4) = {3, 1, 5};
Line Loop(13) = {2, 3, 4, 1};

Point(8) =  {x1,   y1,   0, 0.5*lc}; // el primer pescado
Point(10) = {x1+a, y1,   0, 0.5*lc};
Point(11) = {x1,   y1+a, 0, 0.5*lc};
Point(12) = {x1-a, y1,   0, 0.5*lc};
Point(13) = {x1,   y1-a, 0, 0.5*lc};
Circle(5) = {13, 8, 10};
Circle(6) = {10, 8, 11};
Circle(7) = {11, 8, 12};
Circle(8) = {12, 8, 13};
Line Loop(14) = {6, 7, 8, 5};

Point(18) = {x2,   y2,   0, 0.5*lc}; // el segundo pescado
Point(20) = {x2+a, y2,   0, 0.5*lc};
Point(21) = {x2,   y2+a, 0, 0.5*lc};
Point(22) = {x2-a, y2,   0, 0.5*lc};
Point(23) = {x2,   y2-a, 0, 0.5*lc};
Circle(9) = {23, 18, 22};
Circle(10) = {22, 18, 21};
Circle(11) = {21, 18, 20};
Circle(12) = {20, 18, 23};
Line Loop(15) = {10, 11, 12, 9};

Point(28) = {x3,   y3,   0, 0.5*lc}; // el tercer pescado
Point(30) = {x3+a, y3,   0, 0.5*lc};
Point(31) = {x3,   y3+a, 0, 0.5*lc};
Point(32) = {x3-a, y3,   0, 0.5*lc};
Point(33) = {x3,   y3-a, 0, 0.5*lc};
Circle(19) = {33, 28, 32};
Circle(20) = {32, 28, 31};
Circle(21) = {31, 28, 30};
Circle(22) = {30, 28, 33};
Line Loop(16) = {20, 21, 22, 19};

Plane Surface(17) = {13, 14, 15, 16};
Recombine Surface (17);

Plane Surface(18) = {14};
Recombine Surface (18);

Plane Surface(19) = {15};
Recombine Surface (19);

Plane Surface(20) = {16};
Recombine Surface (20);

Physical Line(1) = {2, 1, 4, 3};              // condicion de contorno
Physical Surface("fuel") = {17};              // fuel
Physical Surface("pescadito") = {18, 19, 20}; // pescaditos

