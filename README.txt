
               The Quncuncial Adaptive Closed Kohonen map
               ******************************************
                             Bjoern Grieger
                             ==============
  
   Abstract:  This project provides tools to facilitate the application
   of the Quncuncial Adaptive Closed Kohonen (QuACK) map of Rosetta's
   target comet 67P/Churyumov-Gerasimenko. Standard global map
   projections cannot display the complete surface of this comet. Here,
   we create the QuACK map by combining two square grids into an
   inherently closed structure. The QuACK map is fitted to the shape
   like a common rectangular Kohonen map. The adaptive map "learns" the
   shape from randomly presented sample points. The QUACK map can be
   unfolded similarly to the Peirce quincuncial projection of the world.
   This enables us to define unique generalized latitudinal coordinates
   by associating the two maps. 
  


1  Fortran subroutines
*=*=*=*=*=*=*=*=*=*=*=

  
  Fortran subroutine are provided in the `for' directory.


1.1  rplquack.f
===============
  
  This subroutine converts 3D rectangular coordinates of a surface point
and known plate index to 2D coordinates on the QuACK map. A detailed
description of input and output parameters is provided at the beginning
of the source code.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked. It needs in particular DSK functionality, thus a recent
version of the SPICE toolkit. Before calling the subroutine, the QuACK
Digital Shape Kernel (DSK) has to be loaded by the following calls to
SPICE DSK subroutines: 
    call dasopr( 'chury_quack_shp.bds', handle )
    call dlabfs( handle, dladsc, found ) 
   The subroutine `rplquack' needs as input the plate index of the plate
on which the surface point resides. If the surface point is obtained by
projecting a 3D position with a 3D direction vector onto the surface of
the shape model, this can be achieved by the following call to a SPCIE
DSK subroutne: 
    call dskx02( handle, dladsc, pos, dir, plid, point, found ) 
   This call does also return the plate index `plid', which can be used
as input for the call to `rplquack'.
  It may be desirable to be able to project an arbitrary point (which
does not necessarily reside on the surface) onto the QuACK map without
providing a plate index. However, this would be much more complicated
and would probably suffer from performance issues.


1.2  quincquad.f
================
  
  This subroutine converts from the hemispheres side-by-side layout to
the square quincuncial layout also used in Peirce quincuncial projection
of the world. A detailed description of input and output parameters is
provided at the beginning of the source code.
  The generic layout of the QuACK map is rectangular with two quadrats
side-by-side and in each of them approximately one hemisphere. The poles
are more or less centered in each of the squares because the rotation
axis coincides with the principal axis of largest moment of inertia.
  This subroutine does not need the SPICE libraries `spicelib.a' and
`support.a' to be linked.


1.3  quinclat.f
===============
  
  This subroutine assigns to a point on the QuACK map (given in
hemispheres side-by-side layout) "generalized longitude and latitude"
which are obtained by associating the point with the respective point on
Peirce quincuncial projection. These generalized latitudinal coordinates
can be used for any standard global map projection, e. g., cylindrical
equidistant. A detailed description of input and output parameters is
provided at the beginning of the source code.
  This subroutine needs the SPICE libraries `spicelib.a' and `support.a'
to be linked. This subroutine includes the file `reverse_quinc_data.f',
so that file needs to be present for compilation.


2  Digital Shape kernels
*=*=*=*=*=*=*=*=*=*=*=*=

  
  A SPICE Digital Shape Kernel (DSK) of the special QuACK shape model is
provided in the `dsk' directory. It is based on the triplat version of
the shape model, cf. section 3.


3  Shape models in ASCII VER format
*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

   


3.1  chury_quack_shp.ver
========================
   
  This is the rectangular QuACK map of 401 x 201 grid points fitted to
the surface of the comet. The 80,000 plates are quadrangles. The
sequence of vertices follows the grid line by line. The first point is
in the lower left corner. The positions of the grid points on the map
are explicitly provided by the shape model described in section 3.2.
  As some software only works with triplate shape models (while the VER
format allows an arbitrary number of corner points for each plate), a
triplate version is also provided, described in section 3.3.


3.2  chury_quack_map.ver
========================
   
  This is not really a 3D shape model. It gives the pixel indices of the
QuACK map grid points on the 2D map. So, x is running from left to
right, from 0 to 400, y is running from bottom to top, from 0 to 200,
and z is always zero. The plate description (which just refers to the
indices of the vertices forming the corner points of the plat) is the
same as that of the shape model described in section 3.1.


3.3  chury_quack_tri.ver
========================
   
  This is a triplate version of the quadrangle plate shape model
described in section 3.1. It is provided as some software only works
with triplate shape models. Each quadrangle has bee cut into two
triangle. From the two possibilities to cut the quadrangle, the one that
yields the smaller kink between the two triangles.


4  Miscellaneous files
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
  
   This document was translated from LaTeX by HeVeA (1).
-----------------------------------
  
  
 (1) http://hevea.inria.fr/index.html
