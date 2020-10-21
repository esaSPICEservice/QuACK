      subroutine latquinc( lon, lat, x, y )
      implicit none

!****************************************************************************!
!- Table of contents
!#TOC
!****************************************************************************!
!- 1 Declarations
!-   1.1 Formal parameters
!-   1.2 Local variables
!-   1.3 Mapping data
!- 2 Ensure valid intervals for angles
!- 3 Get cell index and offset
!- 4 Interpolate map coordinates

!****************************************************************************!
!- 1
!# Declarations
!****************************************************************************!

!============================================================================!
!- 1.1
!## Formal parameters
!============================================================================!
      double precision   lon
      double precision   lat
!     INPUT: Generalized (unambiguous) latitudinal coordinates in radians as
!     defined by the QuACK map.

      double precision   x
      double precision   y
!     OUTPUT: Coordinates of the point on the quincuncial map in side by side
!     layout, Northern hemishpere left, Southern hemisphere right. Map width
!     is 2, map height is 1. (0,0) is in the lower left corner, x is to the
!     right, y is up.

!============================================================================!
!- 1.2
!## Local variables
!============================================================================!
      double precision   dlat
      double precision   dlon
      double precision   dpr
      double precision   halfpi
      integer            i
      integer            ilat
      integer            ilon
      integer            j
      double precision   pi
      double precision   r1
      double precision   r2
      double precision   s1
      double precision   s2
      double precision   twopi
      double precision   x1

!============================================================================!
!- 1.3
!## Mapping data
!============================================================================!
      include 'forward_quinc_data.f'

!****************************************************************************!
!- 2
!# Ensure valid intervals for angles
!****************************************************************************!
      do
         if ( lon .lt. -pi() ) then
            lon = lon + twopi()
         else
            exit
         end if
      end do
      do
         if ( lon .gt. pi() ) then
            lon = lon - twopi()
         else
            exit
         end if
      end do
      if ( lat .lt. -halfpi() ) lat = -halfpi()
      if ( lat .gt.  halfpi() ) lat =  halfpi()

!****************************************************************************!
!- 3
!# Get cell index and offset
!****************************************************************************!
      ilon = min( nlon/2-1, max( -nlon/2, nint ( lon*dpr() - 0.5d0 ) ) )
      ilat = min( nlat/2-1, max( -nlat/2, nint ( lat*dpr() - 0.5d0 ) ) )
      dlon = lon * dpr() - ilon
      dlat = lat * dpr() - ilat
!      print*, real( lon * dpr() ), ilon, dlon
!      print*, real( lat * dpr() ), ilat, dlat

!****************************************************************************!
!- 4
!# Interpolate map coordinates
!****************************************************************************!
      s1 = 0d0
      s2 = 0d0
      do j = 0, 1
!         print*, 'j =', j
         do i = 0, 1
!            print*, '   i =', i
!            colat = halfpi() - abs( lonlat(2,ix+i,iy+j) * rpd() )
!            print*, '      colat [deg] =', colat * dpr()
            r1 = xy(1,ilon+i,ilat+j)
            if ( ilat .eq. 0 .and. j .eq. 0 ) then
               r1 = 2d0 - r1
            end if
!            print*, '      r1 =', r1
            r2 = xy(2,ilon+i,ilat+j)
!            print*, '      r2 =', r2
            s1 = s1 + r1 * ( (2*i-1) * dlon + 1 - i ) *
     &                     ( (2*j-1) * dlat + 1 - j )
            s2 = s2 + r2 * ( (2*i-1) * dlon + 1 - i ) *
     &                     ( (2*j-1) * dlat + 1 - j )
            if ( ilon .eq. 50 .and. ilat .eq. 0 ) then
               print*, i, j, real( r1 ), real( r2 ),
     &                       real( s1 ), real( s2 )
            end if
         end do
      end do
!      print*, '      s1 =', s1
!      print*, '      s2 =', s2
      x = s1
      y = s2

      end
