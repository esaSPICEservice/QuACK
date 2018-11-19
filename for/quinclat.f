      subroutine quinclat( x, y, lon, lat )
      implicit none

CCC_ Parameter descriptions

      double precision   x
      double precision   y
!     INPUT: Coordinates of the point on the quincuncial map in side by side
!     layout, Northern hemishpere left, Southern hemisphere right. Map width
!     is 2, map height is 1. (0,0) is in the lower left corner, x is to the
!     right, y is up.

      double precision   lon
      double precision   lat
!     OUTPUT: Latitudinal coordinats in radians. If the input is a point on
!     the QuACK map, the output can be understood as generalized latitudinal
!     coordinates, which are unique for all points on the comet survace. These
!     coordinates can be used to display the complete comet surface in a
!     generalized version of any map projection. The QuACK map in particular
!     can be understood as a generalized version of the quincuncial projection.

CCC_ Variables
      double precision   colat
      double precision   dpr
      double precision   dx
      double precision   dy
!      double precision   f
      double precision   halfpi
      integer            i
!      integer            idim
      integer            ix
      integer            iy
      integer            j
!      double precision   ll(2)
!      double precision   lonlat(2,0:nx,0:ny)
      double precision   ns
      double precision   r1
      double precision   r2
      double precision   rpd
      double precision   s1
      double precision   s2
      double precision   xn
      double precision   yn

CCC_ Mapping data
      include 'reverse_quinc_data.f'

CCC_ Get cell index and offset
      xn = x * ny
      yn = y * ny
      ix = int( xn )
      if ( ix .lt. 0 )  ix = 0
      if ( ix .ge. nx ) ix = nx - 1
      ns = sign( 1, nx/2 - ( 1 + ix ) ) ! N (1) or S (-1) hemisphere
      iy = int( yn )
      if ( iy .lt. 0 )  iy = 0
      if ( iy .ge. ny ) iy = ny - 1
      dx = xn - ix
      dy = yn - iy
!      print*, 'ix / iy :', ix, iy
!      print*, 'dx / dy :', dx, dy

CCC_ Interpolate latitudinal coordinates
      s1 = 0d0
      s2 = 0d0
      do j = 0, 1
!         print*, 'j =', j
         do i = 0, 1
!            print*, '   i =', i
            colat = halfpi() - abs( lonlat(2,ix+i,iy+j) * rpd() )
!            print*, '      colat [deg] =', colat * dpr()
            r1 = colat * cos( lonlat(1,ix+i,iy+j) * rpd() )
!            print*, '      r1 =', r1
            r2 = colat * sin( lonlat(1,ix+i,iy+j) * rpd() )
!            print*, '      r2 =', r2
            s1 = s1 + r1 * ( (2*i-1) * dx + 1 - i ) *
     &                     ( (2*j-1) * dy + 1 - j )
            s2 = s2 + r2 * ( (2*i-1) * dx + 1 - i ) *
     &                     ( (2*j-1) * dy + 1 - j )
         end do
      end do
!      print*, '      s1 =', s1
!      print*, '      s2 =', s2
      lon = atan2( s2, s1 )
      lat = ns * ( halfpi() - sqrt( s1**2 + s2**2 ) )

      end

