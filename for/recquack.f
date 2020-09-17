      subroutine recquack( point, psrfc, plid, elev, quality  )
      implicit none

CCC_ Declarations

CCC_. Formal parameters

      double precision   point(3)
!     INPUT: Point to be projected onto the QuACK shape model, given in
!     the body fixed frame.

      double precision   psrfc(3)
!     OUTPUT: The input point projected onto the surface of the QuACK
!     shape model.

      integer            plid
!     OUTPUT: The index of the plate on which the projected psrfc
!     resides.

      double precision   elev
!     OUTPUT: The elevation of the original point above the QuACK shape
!     model surface, negative for a subsurface point.

      integer            quality
!     OUTPUT: An indication of the quality of the iteratively obtained
!     result; 100 is perfect, above 10 is OK.

CCC_. Array dimension parameters
      include 'quack_dim.inc'

CCC_. Variables
      double precision   cdist
      double precision   center(3,ncon)
      double precision   dir(3)
      double precision   dirsep
      integer            dladsc(dladsz)
      double precision   dold(3)
      double precision   dpr
      logical            found
      integer            handle
      double precision   gamma
      double precision   gamma0
      double precision   halfpi
      integer            icon
      integer            idim
      integer            irand
      integer            it
      integer            ix
      integer            iy
      double precision   mindist
      integer            nit
      double precision   normal(3)
      double precision   pc(3)
      double precision   phelp(3)
      integer            plid
      integer            plod
      double precision   pold(3)
      logical            subsrfc
      double precision   v1(3)
      double precision   vdist
      double precision   vdot
      double precision   vnorm
      double precision   vsep

CCC_. Common blocks
      common / dsk_handle / handle, dladsc
      common / plate_centers / center

CCC_ Settings

CCC_. Number of iterations
      nit = 1000
!  Reducing the iterations from 1000 to 100 made it about 50% faster.
!  For the grid test, this yielded some ``low'' quality results.

CCC_. Damping
      gamma0 = 1d0

CCC_ Find nearest plate center
      mindist = 1d36
      do icon = 1, ncon
!      do irand = 1, 1000
!         icon = 1 + int( rand() * ncon )
!  Searching only 1000 random plates instead of 160,000 makes it only about
!  25% faster, so this is not the bottle neck.
         do idim = 1, 3
            pc(idim) = center(idim,icon)
         end do
         cdist = vdist( pc, point )
         if ( cdist .lt. mindist ) then
            mindist = cdist
            plid = icon
         end if
      end do
      do idim = 1, 3
         pc(idim) = center(idim,plid)
      end do
!      print*, 'Point position:     ',
!     &              ( real( point(idim) ), idim = 1, 3 )
!      print*, 'Nearest plate:', plid
!      print*, 'Triplate center:    ',
!     &              ( real( center(idim,plid) ), idim = 1, 3 )

CCC_ Direction from point to plate center
      call vsub( pc, point, v1 )
      call vequ( v1, dir )
      call vscl( 2d0, v1, v1 )
!      print*, 'Distance:', vnorm( v1 ) / 2d0
      call vhat( dir, dir )

CCC_ Iterate surface point
      call vequ( pc, psrfc )
!      subsrfc = .false.
!  Obsolete now, it's set more appropriate below.
      plod = plid
      do it = 1, nit

CCC_. Variable damping
         gamma = gamma0 * ( 1d0 + nit - it ) / nit

CCC_. Normal at surface point
         call rplnorm2( psrfc, plid, normal )
!         print*, 'plid =', plid
!         print*, 'normal =', ( real( normal(idim) ), idim = 1, 3 )

CCC_. Reproject point

CCC_ , Remember old values
         call vequ( dir, dold )  
         call vequ( psrfc, pold )

CCC_ , New projection direction
         call vminus( normal, dir )
         dirsep = vsep( dold, dir )
!         print*, it, dirsep

CCC_ , Initial detection of subsurface condition
!  If a point is subsurface and that's not known, the first ray may find
!  overhung terrain. Then it can happen that we converge to a point there.
!  Therefore, we make an (approximate) check before firering the first
!  ray.
         if ( it .eq. 1 ) then
            if ( vdot( dold, dir ) .lt. 0d0 ) then ! halfpi() ) then
               subsrfc = .true.
            else
               subsrfc = .false.
            end if
         end if

CCC_ , Damping (direction)
         call vscl( 1d0 - gamma, dold, dold )
         call vscl( gamma, dir, dir )
         call vadd( dold, dir, dir )
         call vhat( dir, dir )

CCC_ , Create help point above surface
         if ( subsrfc ) then
            call vminus( dir, v1 )
            call vscl ( 2d0 * vdist( psrfc, point ), v1, v1 )
            call vadd( point, v1, phelp )
         else
            call vequ( point, phelp )
         end if

CCC_ , Get new surface intersection
!         print*, 'Trying subsrfc =', subsrfc
         call dskx02( handle, dladsc, phelp, dir,
     &                plid, psrfc, found )
         if ( .not. found ) then
            subsrfc = .not. subsrfc
!            print*, 'Not found, now trying subsrfc =', subsrfc
            if ( subsrfc ) then
               call vminus( dir, v1 )
               call vscl ( 2d0 * vdist( psrfc, point ), v1, v1 )
               call vadd( point, v1, phelp )
            else
               call vequ( point, phelp )
            end if
            call dskx02( handle, dladsc, phelp, dir,
     &                   plid, psrfc, found )
            if ( .not. found ) then
!               print*, 'NO INTERSECTION FOUND !!!'
!               print*, 'it =', it
!!               print*, 'subsrc =', subsrfc
!               print*, 'Restarting with plate center ...'
               call vequ( pc, psrfc )
               plid = plod
            end if
         end if
!         print*, 'Surface point:', ( real( psrfc(idim) ), idim = 1, 3 )

CCC_ , Check if distance gets large to restart
         elev = vdist( psrfc, point )
         if ( .false. .and. elev .gt. 10d0 * mindist ) then
            print*, 'Projection range got large:', real( elev )
            print*, 'it =', it
            print*, 'Restarting with plate center ...'
            call vequ( pc, psrfc )
            plid = plod
         else

!         print*, it, dirsep, vdist( pold, psrfc )
!         if ( vdist( pold, psrfc ) .le. 1d-9 ) exit
            if ( found .and. vdist( pold, psrfc ) .eq. 0d0 ) exit

         end if

      end do
!      print*, 'Final plate:  ', plid
!      print*, 'Final surface point:',
!     &              ( real( psrfc(idim) ), idim = 1, 3 )

CCC_ Correct sign of elevation
      if ( subsrfc ) elev = -1d0 * elev

CCC_ Quality assessment

CCC_. Set quality flag
      if ( dirsep .eq. 0 ) then
         quality = 100
      else
         quality = nint( -log10( dirsep ) )
      end if
!      print*, 'Iterations/Quality:      ', it, quality
      if ( quality .eq. 0 ) then
         print*, 'dirsep =', dirsep, log10( dirsep ), quality
      end if

CCC_. Print low quality warning
!      if ( it .gt. nit .or.
      if ( quality .lt. 10 ) then
         print*, 'WARNING: LOW QUALITY !!!'
         print*, 'Iterations:   ', it
         print*, 'Undamped dir step [rad]: ', dirsep
      end if

      end
