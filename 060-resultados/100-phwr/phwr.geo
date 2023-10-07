SetFactory("OpenCASCADE");
h_core = 200;
h_refl_sup = 20;
h_refl_inf = 15;
r_core = 100;
r_fuel = 10;
r_rod = 5;
r_crown = 50;

// insertion of the control rods
upper = 0.2;
g1 = 0.55;
g2 = 0.50;
g3 = 0.45;


// central fuel element
Cylinder(1) = {0, 0, 0, 0, 0, h_core, r_fuel};

// six fuel elements in a crown
Cylinder(2) = {r_crown*Cos(1*2*Pi/6), r_crown*Sin(1*2*Pi/6), 0, 0, 0, h_core, r_fuel};
Cylinder(3) = {r_crown*Cos(2*2*Pi/6), r_crown*Sin(2*2*Pi/6), 0, 0, 0, h_core, r_fuel};
Cylinder(4) = {r_crown*Cos(3*2*Pi/6), r_crown*Sin(3*2*Pi/6), 0, 0, 0, h_core, r_fuel};
Cylinder(5) = {r_crown*Cos(4*2*Pi/6), r_crown*Sin(4*2*Pi/6), 0, 0, 0, h_core, r_fuel};
Cylinder(6) = {r_crown*Cos(5*2*Pi/6), r_crown*Sin(5*2*Pi/6), 0, 0, 0, h_core, r_fuel};
Cylinder(7) = {r_crown*Cos(6*2*Pi/6), r_crown*Sin(6*2*Pi/6), 0, 0, 0, h_core, r_fuel};

// moderator tank (a little bit larger in each side first, then we cut it back)
Cylinder(8) = {0, 0, -h_refl_inf, 0, 0, h_core+h_refl_inf+h_refl_sup, r_core};

// slated rods
x56 = r_crown*0.5*(Cos(5*2*Pi/6)+Cos(6*2*Pi/6));
y56 = r_crown*0.5*(Sin(5*2*Pi/6)+Sin(6*2*Pi/6));

x34 = r_crown*0.5*(Cos(3*2*Pi/6)+Cos(4*2*Pi/6));
y34 = r_crown*0.5*(Sin(3*2*Pi/6)+Sin(4*2*Pi/6));

x12 = r_crown*0.5*(Cos(1*2*Pi/6)+Cos(2*2*Pi/6));
y12 = r_crown*0.5*(Sin(2*2*Pi/6)+Sin(2*2*Pi/6));

// guide tube
Cylinder(9)  = {x56, y56, h_core, x34-x56, y34-y56, -h_core, r_rod};
// control rod
Cylinder(10) = {x56, y56, h_core, g1*(x34-x56), g1*(y34-y56), -g1*h_core, r_rod};
// upper part
Cylinder(11) = {x56, y56, h_core, -upper*(x34-x56), -upper*(y34-y56), upper*h_core, r_rod};

Cylinder(12) = {x34, y34, h_core, x12-x34, y12-y34, -h_core, r_rod};
Cylinder(13) = {x34, y34, h_core, g2*(x12-x34), g2*(y12-y34), -g2*h_core, r_rod};
Cylinder(14) = {x34, y34, h_core, -upper*(x12-x34), -upper*(y12-y34), upper*h_core, r_rod};
 
Cylinder(15) = {x12, y12, h_core, x56-x12, y56-y12, -h_core, r_rod};
Cylinder(16) = {x12, y12, h_core, g3*(x56-x12), g3*(y56-y12), -g3*h_core, r_rod};
Cylinder(17) = {x12, y12, h_core, -upper*(x56-x12), -upper*(y56-y12), upper*h_core, r_rod};

Coherence;

Mesh.Algorithm = 6;
Mesh.Algorithm3D = 10;
Mesh.ElementOrder = 1;
Mesh.HighOrderOptimize = 4;

//Mesh.MeshSizeFromCurvature = 6;
//Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFactor = 1;
Mesh.MeshSizeMin = 0.25*r_rod;
Mesh.MeshSizeMax = 1.0*r_fuel;



Physical Volume("fuel", 1) = {1, 2, 3, 4, 5, 6, 7};
Physical Volume("rod", 2) = {24, 19, 10, 25, 18, 13, 26, 20, 16};
Physical Volume("guide", 3) = {21, 23, 22};
Physical Volume("moderator", 4) = {17};

Physical Surface("vacuum", 5) = {22, 23, 24, 51, 50, 47, 46, 49, 48};
