      subroutine rplnorm2( point, plid, norm )
      implicit none
!  This differs from rplnorm in that vertices, plates, and vertex normals
!  are not passed, but the former two are taken from the dsk and the latter
!  from a common block.

CCC_ Parameter descriptions

CCC_. Input
      double precision   point(3)
      integer            plid

CCC_. Output
      double precision   norm(3)
      
CCC_ Declarations

CCC_. Array dimension parameters
      include 'quack_dim.inc'

CCC_. Variables
      double precision   base(3)
      integer            con1(3)
      double precision   d(3)
      integer            dladsc(dladsz)
      double precision   h(3)
      integer            handle
      integer            i
      integer            idim
      integer            ivrt
      double precision   normal(3,npos)
      integer            np
      integer            nv
      double precision   quack(2,3)
      double precision   vnorm
      double precision   vrt(3,5)
      double precision   vrt1(3)
      double precision   w(3)

CCC_. Common blocks
      common / dsk_handle / handle, dladsc
      common / vertex_normals / normal

CCC_ Get plate vertices

CCC_. Get vertex indices
      call dskp02( handle, dladsc, plid, 1, np, con1 )

CCC_. Get vertex coordinates
      do ivrt = 1, 3
         call dskv02( handle, dladsc, con1(ivrt), 1, nv, vrt1 )
         do idim = 1, 3
            vrt(idim,ivrt) = vrt1(idim)
         end do
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
         
      end do

CCC_ Compute normal coordinates of point
      do idim = 1, 3
         norm(idim) = 0d0
         do ivrt = 1, 3
            norm(idim) = norm(idim) +
     &           w(ivrt) * normal( idim, con1(ivrt) )
         end do
      end do
      call vhat( norm, norm )

      end
