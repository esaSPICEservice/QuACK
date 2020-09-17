      subroutine setup_quack( dsk )
      implicit none

CCC_ Declarations

CCC_. Formal parameters
      character*(*)      dsk

CCC_. Array dimension parameters
      include 'quack_dim.inc'

CCC_. Variables
      double precision   center(3,ncon)
      integer            con(3)
      double precision   dirx(3)
      double precision   diry(3)
      integer            dladsc(dladsz)
      logical            found
      integer            handle
      integer            icon
      integer            idim
      integer            ipos
      integer            iposb
      integer            iposl
      integer            iposr
      integer            ipost
      integer            ivrt
      integer            ix
      integer            iy
      integer            jx
      integer            jy
      double precision   normal(3,npos)
      double precision   normal1(3)
      integer            np
      integer            nv
      double precision   posb(3)
      double precision   posl(3)
      double precision   posr(3)
      double precision   post(3)
      double precision   vnorm
      double precision   vrt1(3)

CCC_. Common blocks
      common / dsk_handle / handle, dladsc
      common / plate_centers / center
      common / vertex_normals / normal

CCC_ Get shape model ready
      call dasopr( dsk, handle )
      call dlabfs( handle, dladsc, found )
      if ( .not. found ) stop 'DLA descriptor not found.'

CCC_ Loop through plates 
      do icon = 1, ncon

CCC_. Get vertex indices
         call dskp02( handle, dladsc, icon, 1, np, con )

CCC_. Compute plate center
         do idim = 1, 3
            center(idim,icon) = 0d0
         end do
         do ivrt = 1, 3
            call dskv02( handle, dladsc, con(ivrt), 1, nv, vrt1 )
            do idim = 1, 3
               center(idim,icon) = center(idim,icon) + vrt1(idim)
            end do
         end do
         do idim = 1, 3
            center(idim,icon) = center(idim,icon) / 3
         end do

      end do

CCC_ Loop through vertices
      ipos = 0
      do iy = 1, ny
         do ix = 1, nx
            ipos = ipos + 1

CCC_. Get nearest neighbours

CCC_ , Left
            if ( ix .eq. 1 ) then
               if ( iy .eq. 1 ) then
                  jx = 1
                  jy = 2
               else if ( iy .eq. ny ) then
                  jx = 1
                  jy = ny - 1
               else
                  jx = nx - 1
                  jy = iy
               end if
            else if ( ix .eq. nx ) then
               if ( iy .eq. 1 ) then
                  jx = nx
                  jy = 2
               else if ( iy .eq. ny ) then
                  jx = nx
                  jy = ny - 1
               else
                  jx = ix - 1
                  jy = iy
               end if
            else
               jx = ix - 1
               jy = iy
            end if
            call ixiy2ipos( jx, iy, iposl )
            call dskv02( handle, dladsc, iposl, 1, nv, posl )

CCC_ , Right
            if ( ix .eq. 1 ) then
               if ( iy .eq. 1 ) then
                  jx = 2
                  jy = 1
               else if ( iy .eq. ny ) then
                  jx = 2
                  jy = ny
               else
                  jx = ix + 1
                  jy = iy
               end if
            else if ( ix .eq. ny ) then
               if ( iy .eq. 1 ) then
                  jx = ny
                  jy = 2
               else if ( iy .eq. ny ) then
                  jx = ny
                  jy = ny - 1
               else
                  jx = ix + 1
                  jy = iy
               end if
            else if ( ix .eq. nx ) then
               if ( iy .eq. 1 ) then
                  jx = nx - 1
                  jy = 1
               else if ( iy .eq. ny ) then
                  jx = nx - 1
                  jy = ny
               else
                  jx = 2
                  jy = iy
               end if
            else
               jx = ix + 1
               jy = iy
            end if
            call ixiy2ipos( jx, iy, iposr )
            call dskv02( handle, dladsc, iposr, 1, nv, posr )

CCC_ , Bottom
            if ( iy .eq. 1 ) then
               if ( ix .eq. 1 .or. ix .eq. nx ) then
                  jx = nx - 1
                  jy = 2
               else if ( ix .eq. ny ) then
                  jx = ny + 1
                  jy = 2
               else
                  jx = 2 * ny - ix
                  jy = 2
               end if
            else if ( iy .eq. ny ) then
               if ( ix .eq. 1 .or. ix .eq. nx ) then
                  jx = 2
                  jy = ny - 1
               else if ( ix .eq. ny ) then
                  jx = ny - 1
                  jy = ny - 1
               else
                  jx = ix
                  jy = iy - 1
               end if
            else
               jx = ix
               jy = iy - 1
            end if
            call ixiy2ipos( jx, jy, iposb )
            call dskv02( handle, dladsc, iposb, 1, nv, posb )

CCC_ , Top
            if ( iy .eq. 1 ) then
               if ( ix .eq. 1 .or. ix .eq. nx ) then
                  jx = 2
                  jy = 2
               else if ( ix .eq. ny ) then
                  jx = ny - 1
                  jy = 2
               else
                  jx = ix
                  jy = iy + 1
               end if
            else if ( iy .eq. ny ) then
               if ( ix .eq. 1 .or. ix .eq. nx ) then
                  jx = nx - 1
                  jy = ny - 1
               else if ( ix .eq. ny ) then
                  jx = ny + 1
                  jy = ny - 1
               else
                  jx = 2 * ny - ix
                  jy = ny - 1
               end if
            else
               jx = ix
               jy = iy + 1
            end if
            call ixiy2ipos( jx, jy, ipost )
            call dskv02( handle, dladsc, ipost, 1, nv, post )

CCC_. Cross vectors
            call vsub( posr, posl, dirx )
            call vsub( post, posb, diry )
            if ( vnorm( dirx ) .le. 1d-6 .or.
     &           vnorm( diry ) .le. 1d-6      ) then
               print*, ix, iy, ipos, iposl, iposr, iposb, ipost
            end if

CCC_. Normals
            call vcrss( dirx, diry, normal1 )
            if ( vnorm( normal1 ) .lt. 1d-6 ) print*, ix, iy
            call vhat( normal1, normal1 )

CCC_. Copy to output array
            do idim = 1, 3
               normal(idim,ipos) = normal1(idim)
            end do
            
         end do
      end do

      end
