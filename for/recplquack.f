      subroutine recplquack( point, plid, x, y  )
      implicit none

CCC_ Parameter descriptions

      double precision   point(3)
!     INPUT: Point to be projected, given in the body fixed frame, usually
!     as returned by dskx02.

      integer            plid
!     INPUT: ID of the plate on which the point resides, usually as returned
!     by dskx02.

      double precision   x
      double precision   y
!     OUTPUT: Coordinates of the point on the QuACK map in side by side layout,
!     Northern hemishpere left, Southern hemisphere right. Map width is 2,
!     map height is 1. (0,0) is in the lower left corner, x is to the right,
!     y is up.

CCC_ Array dimension parameters
      include 'quack_dim.inc'

CCC_ Declarations
      double precision   base(3)
      integer            con(3)
      double precision   d(3)
      integer            dladsc(dladsz)
      double precision   h(3)
      integer            handle
      integer            idim
      integer            ivrt
      integer            np
      integer            nv
      double precision   quack(2,3)
      double precision   vnorm
      double precision   vrt(3,5)
      double precision   vrt1(3)
      double precision   w(3)

      common / dsk_handle / handle, dladsc

CCC_ Get plate vertices

CCC_. Get plate vertex indices
      call dskp02( handle, dladsc, plid, 1, np, con )
!      print*, 'Plate', plid, ':', con

CCC_. Loop through plate vertices
      do ivrt = 1, 3

CCC_ , Get plate vertex position
         call dskv02( handle, dladsc, con(ivrt), 1, nv, vrt1 )
!            print*, 'Vertex', con(ivrt), ':',
!     &              ( real( vrt1(idim) ), idim = 1, 3 )
         do idim = 1, 3
            vrt(idim,ivrt) = vrt1(idim)
         end do

CCC_ , Get plate vertex QuACK coordinates
         quack(1,ivrt) = mod( con(ivrt) - 1, nx )
         quack(2,ivrt) = ( con(ivrt) - 1 ) / nx
!         print*, ( real( quack(idim,ivrt) ), idim = 1, 2 )

      end do

CCC_. Copy 1st and 2nd vertex to 4th and 5th
      do idim = 1, 3
         vrt(idim,4) = vrt(idim,1)
         vrt(idim,5) = vrt(idim,2)
      end do

CCC_ Compute weights
      do ivrt = 1, 3

CCC_. Base vector along opposite side
         do idim = 1, 3
            base(idim) = vrt(idim,ivrt+2) - vrt(idim,ivrt+1)
         end do

CCC_. Height vector from base to vertex
         do idim = 1, 3
            h(idim) = vrt(idim,ivrt) - vrt(idim,ivrt+1)
         end do
         call vperp( h, base, h )

CCC_. Vector from base to point
         do idim = 1, 3
            d(idim) = point(idim) - vrt(idim,ivrt+1)
         end do
         call vproj( d, h, d )

CCC_. Get weigth
         w(ivrt) = vnorm( d ) / vnorm( h )
!         print*, 'w(', ivrt, ') =', real( w(ivrt) )

      end do

CCC_ Compute QuACK coordinates of point
      x = 0d0
      y = 0d0
      do ivrt = 1, 3
         x = x + w(ivrt) * quack(1,ivrt)
         y = y + w(ivrt) * quack(2,ivrt)
      end do
      x = x / ( ny - 1 )
      y = y / ( ny - 1 )

      end
