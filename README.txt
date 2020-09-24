
            The Quncuncial Adaptive Closed Kohonen QuACK map
            ************************************************
                             Bjoern Grieger
                             ==============
  
   Abstract:  This project provides tools to facilitate the application
   of the Quncuncial Adaptive Closed Kohonen (QuACK) map (1) of
   Rosetta's target comet 67P/Churyumov-Gerasimenko. Standard global map
   projections cannot display the complete surface of this comet. Here,
   we create the QuACK map by combining two square grids into an
   inherently closed structure. The QuACK map is fitted to the shape
   like a common rectangular Kohonen map. The adaptive map "learns" the
   shape from randomly presented sample points. The QUACK map can be
   unfolded similarly to the Peirce quincuncial projection of the world.
   This enables us to define unique generalized latitudinal coordinates
   by associating the two maps. 
  
  

Contents
*=*=*=*=

   
  
   - 1  Command line tool `quack' 
     
      - 1.1  Overview 
      - 1.2  Making the binary 
      - 1.3  Input 
      - 1.4  Output 
        
         - 1.4.1  3D coordinates of points projected onto the QuACK
         shape model surface (option -3) 
         - 1.4.2  2D coordinates of the position on the QuACK map in
         hemispheres side by side layout (option -2) 
         - 1.4.3  2D coordinates of the position on the QuACK map in
         quincuncial layout (option -5) 
         - 1.4.4  Generalized longitues and latitudes (option -1) 
     
      - 1.5  Source code 
  
   - 2  Fortran subroutines 
     
      - 2.1  setup_quack.f 
      - 2.2  recquack.f 
      - 2.3  recplquack.f 
      - 2.4  rplquack.f 
      - 2.5  quincquad.f 
      - 2.6  quinclat.f 
      - 2.7  quack_dim.inc 
      - 2.8  reverse_quinc_data.f 
  
   - 3  Digital Shape kernels 
     
      - 3.1  chury_quack_tri_02_01.bds 
      - 3.2  chury_quack_tri_01_02.bds 
      - 3.3  chury_quack_shp.bds 
  
   - 4  Shape models in ASCII VER format 
     
      - 4.1  Version 02 
        
         - 4.1.1  chury_quack_tri_02.ver 
     
      - 4.2  Version 01 
        
         - 4.2.1  chury_quack_shp.ver 
         - 4.2.2  chury_quack_map.ver 
         - 4.2.3  chury_quack_tri.ver 
     
  
   - 5  Miscellaneous files 
   


1  Command line tool `quack'
*=*=*=*=*=*=*=*=*=*=*=*=*=*=

  


1.1  Overview
=============
  
  A *nix style command line tool named `quack' gives easy access to all
functionalities provided by the Fortran subroutines described in 2.
Arbitrary 3D points can be projected onto the QuACK map in hemispheres
side by side or quincuncial layout. Generalized (unambiguous) longitudes
and latitudes can be computed to use them in any other map projection.
  `quack' has to be called with the Digital Shape Kernel of a 160,000
plates QuACK shape model as first argument. The latest version is 
    dsk/chury_quack_tri_02_01.bds 
  
  When called without any arguments or with the --help option, `quack'
displays a help message.


1.2  Making the binary
======================
  
  There is already a binary for PC, Linux, 64bit in the `bin'
subdirectory called `quack_PC_Linux_64bit'. It also runs in the Linux
subsystem of Windows 10. If that suits you, just copy it to `quack'.
  If you have to make your own binary, you need a Fortran compiler and
the SPICE toolkit suitable for that compiler and your system. Edit the
`Makefile' to specify in the first two lines the path to your SPICE
toolkit and the name of your compiler (with options). If you do not use
the `gfortran' compiler, further changes may be needed.
  If the Makefile is set, just type `make' in the base directory
`QuACK'. This should make the binary `quack' in the `bin' directory.
Call it without any arguments or with the --help option to display a
help message.


1.3  Input
==========
   
  By default, input files are ASCII files and contain coordinates of 3D
points, one vector per line, separated by blanks or commas. Units are
kilometers.
  Depending on the type of output requested, different steps are needed
for the computation. However, the first step, the projection of the
input points onto the surface of the QuACK shape model, is needed for
all types of output, and it is by far the computationally most
expensive. If you have to process a large number of points and are not
yet sure what type of output you will finally use, you can have the
results of this first step written to a file (option -3). This file does
not only contain the 3D coordinates of the projected surface point, but
also the plate ID where the surface point resides and the elevation of
the original point relative to the shape model surface. Later, you can
use this file of intermediate results as input for further computations
(option -4), which will then be much faster.


1.4  Output
===========
  
  Here, we only elaborate on the meaning of the different output types.
For instructions on the usage of the options described below, call
`quack' without any argument or with the --help option.


1.4.1  3D coordinates of points projected onto the QuACK shape model
--------------------------------------------------------------------
surface (option -3)
-------------------
  
  This was already described in 1.3.


1.4.2  2D coordinates of the position on the QuACK map in hemispheres
---------------------------------------------------------------------
side by side layout (option -2)
-------------------------------
  
  Each (approximate) hemisphere is mapped to a square. The Northern
hemisphere is on the left, the Southern one on the right. Map width is
2, map height is 1. (0,0) is in the lower left corner, first coordinate
is to the right, second is up. As third value the elevation of the
original point relative to the QuACK shape model surface is written to
each line.


1.4.3  2D coordinates of the position on the QuACK map in quincuncial
---------------------------------------------------------------------
layout (option -5)
------------------
  
  The square to which the Norther hemisphere is mapped is rotated 45 deg
clockwise and the Southern hemisphere is diagonally cut into four pieces
and these are attached with the long edges appropriately to the Northern
hemisphere. Width and height of the map are 1. (0,0) is in the lower
left corner, first coordinate is to the right, second is up. As third
value the elevation of the original point relative to the QuACK shape
model surface is written to each line.


1.4.4  Generalized longitues and latitudes (option -1)
------------------------------------------------------
  
  These generalized longitudes and latitudes are unambiguous  for all
points on the comet surface. The North pole is near 90 deg N, the South
pole is near 90 deg South, and the equator is near 0 deg latitude.
However, the generalized coordinates differ from the original longitude
and latitude, in particular in the overhung areas, where the latter are
ambiguous. The generalized coordinates can be used to display the
complete comet surface in a generalized version of any map projection.
The QuACK map in particular can be understood as a generalized version
of the Peirce quincuncial projection. Longitude/latitude units are
degrees. As third value the elevation of the original point relative to
the QuACK shape model surface is written to each line.


1.5  Source code
================
  
  The source code of the main program of the `quack' command line tool
is in the file `for/quack.f'. With the exception of the superseded
subroutine `rplquack.f', all files in the `for' directory are linked or
included.


2  Fortran subroutines
*=*=*=*=*=*=*=*=*=*=*=

   
  Fortran subroutines are provided in the `for' directory. Each file
contains exactly one subroutine, the name of which equals the basename
of the file. The two lower level routines in the files `ixiy2ipos.f' and
`rplnorm2.f' are not yet documented.


2.1  setup_quack.f
==================
   
  This subroutine has to be called before the first call to `recquack'
(2.2) or `recplquack' (2.3). As parameter, the file name of the Digital
Shape Kernel (DSK) of the  QuACK shape model to be used has to be
provided, including the full absolute path or the relative path from the
working directory. The latest version of the QuACK shape mode is
`chury_quack_tri_02_01.bds', cf. 3.
  This subroutine includes the file `quack_dim.inc' (2.7), so that file
needs to be present for compilation.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked.


2.2  recquack.f
===============
   
  Before calling this subroutine for the first time, the subroutine
`setup_quack' (2.1) has to be called.
  This subroutine projects an arbitrary 3D point onto the surface of the
QuACK shape model. It returns also the index of the plate where the
projected surface point resides, so the surface point and the plate
index can be used as input for `recplquac' (2.3). A detailed description
of input and output parameters is provided at the beginning of the
source code.
  The direction of the projection is the surface normal at the projected
surface point. Obviously, the solution can only be found iteratively, so
this is computationally expensive. Because of the concave shape of the
comet, there can be more than one possible solution. In such cases, the
solution nearest to the point to be projected should be found.
  The surface normal is computed by bilinear interpolation between the
corners of a quadrangular cell of the QuACK map grid, with the normals
at the corners precomputed as the mean of the adjacent cells. Thus the
surface normal is not assumed to be constant over a plate, but
continuously varying. Therefore, the projection is realized with subgrid
accuracy.
  This subroutine includes the file `quack_dim.inc' (2.7), so that file
needs to be present for compilation.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked.


2.3  recplquack.f
=================
   
  This subroutine supersedes `rplquack.f' (2.4).
  Before calling this subroutine for the first time, the subroutine
`setup_quack' (2.1) has to be called.
  This subroutine converts 3D rectangular coordinates of a surface point
and known plate index to 2D coordinates on the QuACK map. A detailed
description of input and output parameters is provided at the beginning
of the source code.
  If the 3D point has been obtained by getting the intersection of a
viewing ray with the surface of the QuACK shape model, the plate index
of the intersection point, which is needed as input for `recplquack',
should be known. If the 3D point has been obtained by other means and
the plate index is not nown, the subroutine `recquack' (2.2) can be used
to get it.
  This subroutine includes the file `quack_dim.inc' (2.7), so that file
needs to be present for compilation.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked.


2.4  rplquack.f
===============
   
  This subroutine is superseded by `recplquack.f' (2.3), which does not
require any more to open the QuACK Digital Shape Kernel (DSK) manually.
  Before calling this subroutine, the QuACK Digital Shape Kernel (DSK)
has to be loaded by the following calls to SPICE DSK subroutines: 
    call dasopr( 'chury_quack_shp.bds', handle )
    call dlabfs( handle, dladsc, found ) 
   
  This subroutine converts 3D rectangular coordinates of a surface point
and known plate index to 2D coordinates on the QuACK map. A detailed
description of input and output parameters is provided at the beginning
of the source code.
  This subroutine needs as input the plate index of the plate on which
the surface point resides. If the surface point is obtained by
projecting a 3D position with a 3D direction vector onto the surface of
the QuACK shape model, this can be achieved by the following call to a
SPCIE DSK subroutine: 
    call dskx02( handle, dladsc, pos, dir, plid, point, found ) 
   This call does also return the plate index `plid', which can be used
as input for the call to `rplquack'.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked. 


2.5  quincquad.f
================
  
  This subroutine converts from the hemispheres side-by-side layout to
the square quincuncial layout also used in Peirce quincuncial projection
of the world. A detailed description of input and output parameters is
provided at the beginning of the source code.
  The generic layout of the QuACK map is rectangular with two quadrats
side-by-side and in each of them approximately one hemisphere. The poles
are more or less centered in each of the squares because the rotation
axis coincides with the principal axis of largest moment of inertia.
  In the quincuncial layout, the Northern hemisphere is rotated by 45
deg to sit on a corner and the Southern hemisphere is cut long the main
diagonals into four pieces, which are attached to the four edges of the
Northern hemisphere.


2.6  quinclat.f
===============
   
  This subroutine assigns to a point on the QuACK map (given in
hemispheres side-by-side layout) "generalized longitude and latitude"
which are obtained by associating the point with the respective point on
Peirce quincuncial projection (2). These generalized latitudinal
coordinates can be used for any standard global map projection, e. g.,
cylindrical equidistant. A detailed description of input and output
parameters is provided at the beginning of the source code.
  This subroutine includes the file `reverse_quinc_data.f', so that file
needs to be present for compilation.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked.


2.7  quack_dim.inc
==================
   
  This file defines array dimension parameters. It is included by
`setup_quack' (2.1), `recquack' (2.2), and `recplquack' (2.3). It needs
to be updated if the dimensions of the QuACK shape model have changed or
if a new SPICE version has changed a respective parameter value. Details
on the latter are at the end of the source code. 


2.8  reverse_quinc_data.f
=========================
  
  This fils contains numerical values needed for the reverse quincuncial
projection. It is included by 2.6.


3  Digital Shape kernels
*=*=*=*=*=*=*=*=*=*=*=*=

   
  SPICE Digital Shape Kernels (DSKs) of the special QuACK shape model
are provided in the `dsk' directory.


3.1  chury_quack_tri_02_01.bds
==============================
  
  This DSK is based on the triplate shape model `chury_quack_tri_02.ver'
(4.1.1). It has been created with the mkdsk utility of the SPICE toolkit
version N0066 and can be used with this version of the toolkit.


3.2  chury_quack_tri_01_02.bds
==============================
  
  This DSK is like the former one below based on the triplate shape
model `chury_quack_tri.ver', see section 4.2.3. However, it has been
created with the mkdsk utility of the SPICE toolkit version N0066 and
can be used with this version of the toolkit.


3.3  chury_quack_shp.bds
========================
  
  This DSK is based on the triplate shape model `chury_quack_tri.ver',
see section 4.2.3. It had been created with APIs from the alpha DSK
toolkit and cannot be used with recent versions of SPICE.


4  Shape models in ASCII VER format
*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

   


4.1  Version 02
===============
  


4.1.1  chury_quack_tri_02.ver
-----------------------------
   
  This triplate shape model is a slghtly modified version of
`chury_quack_tri.ver', see section 4.2.3.
  At each of the four corners of the two squares sewed together, there
are two quadrangle grid cells which have three points in common. These
three points should form a straight line on the 3D shape. When computing
normals at the vertex positions, it was noticed that the center point is
slightly off the line, which leads to spurious normals at that point and
its neighbors. The reason of this deviation is not completely clear,
most probably it is just residual noise from the random optimization
process. We slightly shift these points to exactly the center of the
line. There are four points affected (the four corner points of the two
squares sewed together), but two of them are replicated in the QuACK map
grid, as the right and the left edge of the side-by-side rectangular
layout are identical, so six vertex points are slightly shifted. All
other vertex points remain exactly the same.
  To create the triplate shape model, each quadrangle of the original
QuACK map grid is cut into two triangles. Of the two options, previously
the one which yielded the smaller bend between the two triangles was
chosen. At the four corners of the two squares sewed together, where two
adjacent quadrangular cells share three points, this could yield a
degenerated (zero area) triangle, which is not recommended for a SPICE
DSK. Therefore, we now chose the option which yields the more similar
area for the two triangles. Thus, for many quadrangular cells, the
diagonal along which they are cut into triangles is swapped.
  Note that this version is so far not available in the quadrangular
version. That would have the vertex positions of
`chury_quack_tri_02.ver' but the plate definitions of
`chury_quack_shp.ver' (4.2.1).
  Note also that `chury_quack_map.ver' (4.2.2) does not contain 3D
vertex positions and no triangular plates, so it is still applicable to
version 02.


4.2  Version 01
===============
  


4.2.1  chury_quack_shp.ver
--------------------------
   
  This is the rectangular QuACK map of 401 x 201 grid points fitted to
the surface of the comet. The 80,000 plates are quadrangles. The
sequence of vertices follows the grid line by line. The first point is
in the lower left corner. The positions of the grid points on the map
are explicitly provided by the shape model described in section 4.2.2.
  As some software only works with triplate shape models (while the VER
format allows an arbitrary number of corner points for each plate), a
triplate version is also provided, described in section 4.2.3.


4.2.2  chury_quack_map.ver
--------------------------
   
  This is not really a 3D shape model. It gives the pixel indices of the
QuACK map grid points on the 2D map. So, x is running from left to
right, from 0 to 400, y is running from bottom to top, from 0 to 200,
and z is always zero. The plate description (which just refers to the
indices of the vertices forming the corner points of the plat) is the
same as that of the shape model described in section 4.2.1.


4.2.3  chury_quack_tri.ver
--------------------------
   
  This is a triplate version of the quadrangle plate shape model
described in section 4.2.1. It is provided as some software only works
with triplate shape models. Each quadrangle has bee cut into two
triangle. From the two possibilities to cut the quadrangle, the one that
yields the smaller kink between the two triangles.


5  Miscellaneous files
*=*=*=*=*=*=*=*=*=*=*=

  
  The files in the `misc' directory provide a direct relationship
between a point on the QuACK map in quincuncial layout and its 3D
position on the surface of the comet. Each file consists of 401 x 401
points, running line by line from left to right and from bottom to top.
In quincuncial layout, the original quack map is rotated by 45 deg
counterclockwise. Therefore, the grid points of even numbered lines are
shifted by half a step width with respect to odd numbered lines.
Additional points are inserted (and interpolated) to obtain again a
regular rectangular grid. Therefore the number of grid points (401 x
401) is larger than that of the orignal QuACK map in hemispheres
side-by-side layout (401 x 201). The tree files provide of each grid
point the x, y, and z coordinate on the comet surface respectively.
-----------------------------------------------------------------------
  
   This document was translated from LaTeX by HeVeA (3).
-----------------------------------
  
  
 (1) Grieger, B. (2019). "Quincuncial adaptive closed Kohonen (QuACK)
   map for the irregularly shaped comet 67P/Churyumov-Gerasimenko". A&A
   630, A1. https://doi.org/10.1051/0004-6361/201834841
 (2) Grieger, B. (2020). "Optimized global map projections for specific
   applications: the triptychial projection and the Spilhaus
   projection". EGU2020-9885.
   https://doi.org/10.5194/egusphere-egu2020-9885
 (3) http://hevea.inria.fr/index.html
