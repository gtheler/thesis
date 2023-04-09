Geometry.LineWidth = 3;

Geometry.Points = 1;
Geometry.PointType = 0;
Geometry.PointSize = 10;

Geometry.Color.Lines = DarkCyan;
Geometry.Color.Surfaces = {128,53,16};
Geometry.Color.Points = Black;


General.SmallAxes = 0;
General.Trackball = 1;
General.TrackballQuaternion0 = -0.05229374055332137;
General.TrackballQuaternion1 = 0.6000500186735757;
General.TrackballQuaternion2 = 0.03126269362443166;
General.TrackballQuaternion3 = 0.7976390059269445;


lc = 1;
r = 0.25;

nx = 4;
ny = 3;
nz = 3;

thetax = 0.3;
thetay = 0.17;
thetaz = 0.05;


Point(1001) = {nx/2, ny/6, 1.5*nz, lc};
Point(1002) = {nx/2, ny/6, 1.1*nz, lc};
Line(1003) = {1001, 1002};
Hide {Point {1002};}


For ix In {0:nx-1}
For iy In {0:ny-1}
For iz In {0:nz-1}

 i = ix + nx * iy + nx*ny * iz;

 x = ix;
 y = iy;
 z = iz;

 y =  Cos(thetax) * y - Sin(thetax) * z;
 z =  Sin(thetax) * y + Cos(thetax) * z;

 x =  Cos(thetay) * x + Sin(thetay) * z;
 z = -Sin(thetay) * x + Cos(thetay) * z;

 x =  Cos(thetaz) * x - Sin(thetaz) * y;
 y = -Sin(thetaz) * x + Cos(thetaz) * y;


 Point(10*i+1) = {x, y, z, lc};
 Point(10*i+2) = {x+r, y, z, lc};
 Point(10*i+3) = {x, y+r, z, lc};
 Point(10*i+4) = {x-r, y, z, lc};
 Point(10*i+5) = {x, y-r, z, lc};
 Circle(10*i+1) = {10*i+2, 10*i+1, 10*i+3};
 Circle(10*i+2) = {10*i+3, 10*i+1, 10*i+4};
 Circle(10*i+3) = {10*i+4, 10*i+1, 10*i+5};
 Circle(10*i+4) = {10*i+5, 10*i+1, 10*i+2};

 Line Loop(10*i+5) = {10*i+1, 10*i+2, 10*i+3, 10*i+4};
 Plane Surface(10*i+6) = {10*i+5};

 Color Green {Surface {10*i+6}; }
 Hide {Point {10*i+2, 10*i+3, 10*i+4, 10*i+5}; }

EndFor
EndFor
EndFor
