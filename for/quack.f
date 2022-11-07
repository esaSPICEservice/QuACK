      program quack

!****************************************************************************!
!- Table of contents
!#TOC
!****************************************************************************!
!- 1 Declarations
!- 2 Initializations
!- 3 Get number of command line arguments
!-   3.1 Print help message
!- 4 Loop through options
!-   4.1 Case option parameter(s) expected
!-       4.1.1 Remember which args are options
!-       4.1.2 Parameter for option 3
!-       4.1.3 Parameter for option 2
!-       4.1.4 Parameter for option 5
!-       4.1.5 Parameter for option 1
!-       4.1.6 Parameter for option s
!-       4.1.7 Parameter for option c
!-   4.2 Case option
!-       4.2.1 Long option
!-             4.2.1.1 Print help message
!-             4.2.1.2 Invalid long option
!-       4.2.2 Remember which args are options
!-       4.2.3 Options without parmeter
!-             4.2.3.1 Option to read data formally written with option 3
!-             4.2.3.2 Option to read generalized longitudes and latitudes
!-             4.2.3.3 Other option
!-       4.2.4 Option to write 3D positions on QuACK shape model
!-       4.2.5 Option to write QuACK map coordinates in side by side layout
!-       4.2.6 Option to write QuACK map coordinates in quincuncial layout
!-       4.2.7 Option to write generalized longitudes and latitudes
!-       4.2.8 Option to write coordinates in South centered quincuncial layout
!-       4.2.9 Option to write to console
!-       4.2.10 Invalid option
!-       4.2.11 Check output type specified for console
!-       4.2.12 Open output files
!- 5 Loop through file arguments
!-   5.1 Check that it is not an option
!-   5.2 Case first argument
!-   5.3 Case more arguments
!-       5.3.1 Open input file
!-       5.3.2 Loop through file records
!-             5.3.2.1 Get 3D position on QuACK shape model
!-             5.3.2.2 Convert generalized longitude and latitude to quack map
!-             5.3.2.3 Write 3D position to output file
!-             5.3.2.4 Get QuACK map coordinates for side-by-side layout
!-             5.3.2.5 Write map coordinates to output file
!-             5.3.2.6 Get and write map coordinates for quincuncial layout
!-             5.3.2.7 Get and write generalized longitudes and latitudes
!-             5.3.2.8 Get and write map coordinates for South centered layout
!-       5.3.3 Close input file
!-       5.3.4 Print statistics
!- 6 Check if any input was processed
!- 7 Subroutine to print help message

!****************************************************************************!
!- 1
!# Declarations
!****************************************************************************!
      implicit none
      character*(1000)   arg
      character*(1000)   chelp
      logical            console
      double precision   dpr
      character*(1000)   dsk
      double precision   elev
      character*(1000)   file1
      character*(1000)   file2
      character*(1000)   file3
      character*(1000)   file5
      character*(1000)   file_s
      integer            iarg
      integer            idim
      integer            inop
      integer            inot4
      integer            iopt
!      character*(1000)   isarg
      double precision   lat
      double precision   lon
      logical            lonlat
      logical            lonlatin
      integer            narg
      integer            ncpos
      integer            nopt
      integer            npar
      integer            npoint
      integer            nptot
      character*(1000)   off
      logical            onshape
      character*(1)      option
      integer            optlist(1000)
      logical            out
      character*(1000)   outtype
      double precision   p
      integer            plid
      double precision   point(3)
      double precision   psrfc(3)
      double precision   q
!      double precision   quality ! WRONG in 1.9 !!!
      integer            quality
      logical            quincuncial
      double precision   rpd
      logical            sidebyside
      logical            stdin
      logical            south
      logical            trans05
      logical            withplid
      double precision   x
      double precision   y

!****************************************************************************!
!- 2
!# Initializations
!****************************************************************************!
      dsk         = ' '
      onshape     = .false.
      sidebyside  = .false.
      quincuncial = .false.
      lonlat      = .false.
      withplid    = .false.
      console     = .false.
      lonlatin    = .false.
      south       = .false.
      trans05     = .false.
      nptot       = 0

!****************************************************************************!
!- 3
!# Get number of command line arguments
!****************************************************************************!
      narg = command_argument_count()

!============================================================================!
!- 3.1
!## Print help message
!============================================================================!
      if ( narg .eq. 0 ) then
         call print_help()
         stop
      end if

!****************************************************************************!
!- 4
!# Loop through options
!****************************************************************************!
      npar = 0
      nopt = 0
      do iarg = 1, narg
         call get_command_argument( iarg, arg )

!============================================================================!
!- 4.1
!## Case option parameter(s) expected
!============================================================================!
         if ( npar .ge. 1 ) then

!----------------------------------------------------------------------------!
!- 4.1.1
!### Remember which args are options
!----------------------------------------------------------------------------!
            nopt = nopt + 1
            optlist(nopt) = iarg

!----------------------------------------------------------------------------!
!- 4.1.2
!### Parameter for option 3
!----------------------------------------------------------------------------!
            if ( option .eq. '3' ) then
               file3 = arg
               npar = npar - 1

!----------------------------------------------------------------------------!
!- 4.1.3
!### Parameter for option 2
!----------------------------------------------------------------------------!
            else if ( option .eq. '2' ) then
               file2 = arg
               npar = npar - 1

!----------------------------------------------------------------------------!
!- 4.1.4
!### Parameter for option 5
!----------------------------------------------------------------------------!
            else if ( option .eq. '5' ) then
               file5 = arg
               npar = npar - 1

!----------------------------------------------------------------------------!
!- 4.1.5
!### Parameter for option 1
!----------------------------------------------------------------------------!
            else if ( option .eq. '1' ) then
               file1 = arg
               npar = npar - 1

!----------------------------------------------------------------------------!
!- 4.1.6
!### Parameter for option s
!----------------------------------------------------------------------------!
            else if ( option .eq. 's' .or. option .eq. 't' ) then
               file_s = arg
               npar = npar - 1

!----------------------------------------------------------------------------!
!- 4.1.7
!### Parameter for option c
!----------------------------------------------------------------------------!
            else if ( option .eq. 'c' ) then
               outtype = arg
               npar = npar - 1

            end if

!============================================================================!
!- 4.2
!## Case option
!============================================================================!
         else if ( arg(1:1) .eq. '-' .and. len_trim( arg ) .ge. 2 ) then
            option = arg(2:2)

!----------------------------------------------------------------------------!
!- 4.2.1
!### Long option
!----------------------------------------------------------------------------!
            if ( arg(2:2) .eq. '-' ) then

!............................................................................!
!- 4.2.1.1
!#### Print help message
!............................................................................!
               if ( arg .eq. '--help' ) then
                  call print_help()
                  stop

!............................................................................!
!- 4.2.1.2
!#### Invalid long option
!............................................................................!
               else
                  print '(a)', 'quack: invalid option -- '//
     &                         "'"//trim( arg )//"'"
                  stop 1

               end if

            end if

!----------------------------------------------------------------------------!
!- 4.2.2
!### Remember which args are options
!----------------------------------------------------------------------------!
            nopt = nopt + 1
            optlist(nopt) = iarg

!----------------------------------------------------------------------------!
!- 4.2.3
!### Options without parmeter
!----------------------------------------------------------------------------!
            if ( option .eq. '4' .or. option .eq. 'l' ) then
               do inop = 2, len_trim( arg )

!............................................................................!
!- 4.2.3.1
!#### Option to read data formally written with option 3
!............................................................................!
                  if ( arg(inop:inop) .eq. '4' ) then
                     withplid = .true.
                     lonlatin = .false.
                     option = ' '

!............................................................................!
!- 4.2.3.2
!#### Option to read generalized longitudes and latitudes
!............................................................................!
                  else if ( arg(inop:inop) .eq. 'l' ) then
                     lonlatin = .true.
                     withplid = .false.
                     option = ' '

!............................................................................!
!- 4.2.3.3
!#### Other option
!............................................................................!
                  else
                     option = arg(inop:inop)
                     chelp = arg
                     arg = '-'//chelp(inop:)
                     exit

                  end if
               end do
            end if

!----------------------------------------------------------------------------!
!- 4.2.4
!### Option to write 3D positions on QuACK shape model
!----------------------------------------------------------------------------!
            if ( option .eq. '3' ) then
               onshape = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) file3
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if

!----------------------------------------------------------------------------!
!- 4.2.5
!### Option to write QuACK map coordinates in side by side layout
!----------------------------------------------------------------------------!
            else if ( option .eq. '2' ) then
               sidebyside = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) file2
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if

!----------------------------------------------------------------------------!
!- 4.2.6
!### Option to write QuACK map coordinates in quincuncial layout
!----------------------------------------------------------------------------!
            else if ( option .eq. '5' ) then
               quincuncial = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) file5
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if

!----------------------------------------------------------------------------!
!- 4.2.7
!### Option to write generalized longitudes and latitudes
!----------------------------------------------------------------------------!
            else if ( option .eq. '1' ) then
               lonlat = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) file1
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if

!----------------------------------------------------------------------------!
!- 4.2.8
!### Option to write coordinates in South centered quincuncial layout
!----------------------------------------------------------------------------!
            else if ( option .eq. 's' .or. option .eq. 't' ) then
               south = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) file_s
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if
               if ( option .eq. 't' ) then
                  trans05 = .true.
               end if

!----------------------------------------------------------------------------!
!- 4.2.9
!### Option to write to console
!----------------------------------------------------------------------------!
            else if ( option .eq. 'c' ) then
               console = .true.
               if ( len_trim( arg ) .gt. 2 ) then
                  read( arg(3:), '(a)' ) outtype
               else
                  if ( iarg .eq. narg ) then
                     print '(a)', 'quack: option requires an '//
     &                            "argument -- '"//option//"'"
                     stop 1
                  else
                     npar = 1
                  end if
               end if

!----------------------------------------------------------------------------!
!- 4.2.10
!### Invalid option
!----------------------------------------------------------------------------!
            else if ( option .ne. ' ' ) then
               print '(a)', 'quack: invalid option -- '//
     &                      "'"//option//"'"
               stop 1

            end if

         end if

      end do

!      do iopt = 1, nopt
!         print*, iopt, optlist(iopt)
!      end do

!----------------------------------------------------------------------------!
!- 4.2.11
!### Check output type specified for console
!----------------------------------------------------------------------------!
      if ( console ) then
         if ( outtype .eq. '3' ) then
            print*, 'Will write positions on shape to console.'
         else if ( outtype .eq. '2' ) then
            print*, 'Will write side-by-side map coordinates  '//
     &              'to console.'
         else if ( outtype .eq. '5' ) then
            print*, 'Will write quincuncial map coordinates '//
     &              'to console.'
         else if ( outtype .eq. '1' ) then
            print*, 'Will write generalized longitudes and latitudes '//
     &              'to console.'
         else if ( outtype .eq. 's' ) then
            print*, 'Will write South centered '//
     &              'quincuncial map coordinates '//
     &              '[0.0,1.0] to console.'
         else if ( outtype .eq. 't' ) then
            print*, 'Will write South centered '//
     &              'quincuncial map coordinates '//
     &              '[-0.5,0.5] to console.'
         else
            print '(a)', 'quack: invalid output type: '//
     &                   "'"//trim(outtype)//"'"
            stop 1
         end if
      else
         outtype = ' '
      end if

!----------------------------------------------------------------------------!
!- 4.2.12
!### Open output files
!----------------------------------------------------------------------------!
      out = .false.
      if ( onshape ) then
         print*, 'Will write positions on shape to file ',
     &        trim( file3 ), '.'
         open( 23, file = trim( file3 ) )
         out = .true.
      end if
      if ( sidebyside ) then
         print*, 'Will write side-by-side map coordinates '//
     &        'to file ',
     &        trim( file2 ), '.'
         open( 22, file = trim( file2 ) )
         out = .true.
      end if
      if ( quincuncial ) then
         print*, 'Will write quincuncial map coordinates '//
     &        'to file ',
     &        trim( file5 ), '.'
         open( 25, file = trim( file5 ) )
         out = .true.
      end if
      if ( lonlat ) then
         print*, 'Will write generalized longitudes and latitudes '//
     &        'to file ',
     &        trim( file1 ), '.'
         open( 21, file = trim( file1 ) )
         out = .true.
      end if
      if ( south ) then
         if ( .not. trans05 ) then
            print*, 'Will write South centered '//
     &              'quincuncial map coordinates '//
     &              '[0.0,1.0] to file ',
     &              trim( file_s ), '.'
         else
            print*, 'Will write South centered '//
     &              'quincuncial map coordinates '//
     &              '[-0.5,0.5] to file ',
     &              trim( file_s ), '.'
         end if
         open( 26, file = trim( file_s ) )
         out = .true.
      end if
      if ( outtype .eq. ' ' .and. .not. out ) then
         print*, 'Warning: no output option given.'
      end if

!****************************************************************************!
!- 5
!# Loop through file arguments
!****************************************************************************!
      iopt = 1
      do iarg = 1, narg
!         if ( isarg(iarg:iarg) .eq. '1' ) then

!============================================================================!
!- 5.1
!## Check that it is not an option
!============================================================================!
         if ( iarg .eq. optlist(iopt) ) then
            if ( iopt .lt. nopt ) then
               iopt = iopt + 1
            end if

         else

            call get_command_argument( iarg, arg )

!============================================================================!
!- 5.2
!## Case first argument
!============================================================================!
            if ( len_trim( dsk ) .eq. 0 ) then
               dsk = trim( arg )
               print*, 'Loading DSK file ', trim( dsk ), '.'
               call setup_quack( dsk )

!============================================================================!
!- 5.3
!## Case more arguments
!============================================================================!
            else

!----------------------------------------------------------------------------!
!- 5.3.1
!### Open input file
!----------------------------------------------------------------------------!
               if ( arg .eq. '-' ) then
                  stdin = .true.
                  print*, 'Reading from standard input ...'
               else
                  stdin = .false.
                  print*, 'Processing file ', trim( arg ), ' ...'
                  open( 11, file = trim( arg ), status = 'OLD' )
               end if

!----------------------------------------------------------------------------!
!- 5.3.2
!### Loop through file records
!----------------------------------------------------------------------------!
               npoint = 0
               do
                  if ( withplid ) then
                     if ( stdin ) then
                        read(  5, *, end = 4000 ) psrfc, plid, elev
                     else
                        read( 11, *, end = 4000 ) psrfc, plid, elev
                     end if
                  else if ( lonlatin ) then
                     if ( stdin ) then
                        read(  5, *, end = 4000 ) lon, lat, elev
                     else
                        read( 11, *, end = 4000 ) lon, lat, elev
                     end if
                     lon = lon * rpd()
                     lat = lat * rpd()
!                     elev = 0d0
                  else
                     if ( stdin ) then
                        read(  5, *, end = 4000 ) point
                     else
                        read( 11, *, end = 4000 ) point
                     end if
                  end if
                  npoint = npoint + 1
                  nptot = nptot + 1

!............................................................................!
!- 5.3.2.1
!#### Get 3D position on QuACK shape model
!............................................................................!
                  if ( ( onshape .or. sidebyside .or. quincuncial .or.
     &                   lonlat .or. south .or. outtype .ne. ' '       )
     &                 .and. .not. withplid
     &                 .and. .not. lonlatin ) then
                     call recquack( point, psrfc, plid, elev, quality  )
                  end if

!............................................................................!
!- 5.3.2.2
!#### Convert generalized longitude and latitude to quack map
!............................................................................!
                  if ( lonlatin ) then
                     call latquinc( lon, lat, x, y )
                     if ( onshape .or. outtype .eq. '3' ) then
                        print*, 'Output option/type 3 not supported ' //
     &                          'for input option l.'
                     end if
                  else

!............................................................................!
!- 5.3.2.3
!#### Write 3D position to output file
!............................................................................!
                     if ( onshape ) then
                        write( 23, * )
     &                     ( real( psrfc(idim) ), idim = 1, 3 ), plid,
     &                     real( elev )
                     end if
                     if ( outtype .eq. '3' ) then
                        print*,
     &                     ( real( psrfc(idim) ), idim = 1, 3 ), plid,
     &                     real( elev )
                     end if

!............................................................................!
!- 5.3.2.4
!#### Get QuACK map coordinates for side-by-side layout
!............................................................................!
                     if ( sidebyside .or. quincuncial .or. lonlat .or.
     &                    south .or.
     &                    outtype .eq. '2' .or. outtype .eq. '5' .or.
     &                    outtype .eq. '1' .or. outtype .eq. 's' .or.
     &                    outtype .eq. 't' ) then
                        call recplquack( psrfc, plid, x, y  )
                     end if

                  end if

!............................................................................!
!- 5.3.2.5
!#### Write map coordinates to output file
!............................................................................!
                  if ( sidebyside ) then
                     write( 22, * ) real( x ), real( y ), real( elev )
                  end if
                  if ( outtype .eq. '2' ) then
                     print*, real( x ), real( y ), real( elev )
                  end if

!............................................................................!
!- 5.3.2.6
!#### Get and write map coordinates for quincuncial layout
!............................................................................!
                  if ( quincuncial .or. outtype .eq. '5' ) then
                     call quincquad( x, y, p, q  )
                     if ( quincuncial ) then
                        write( 25, * ) real( p ), real( q ),
     &                                 real( elev )
                     end if
                     if ( outtype .eq. '5' ) then
                        print*, real( p ), real( q ),
     &                          real( elev )
                     end if
                  end if

!............................................................................!
!- 5.3.2.7
!#### Get and write generalized longitudes and latitudes
!............................................................................!
                  if ( lonlat .or. outtype .eq. '1' ) then
                     call quinclat( x, y, lon, lat  )
                     if ( lonlat ) then
                        write( 21, * ) real( lon * dpr() ),
     &                                 real( lat * dpr() ), real( elev )
                     end if
                     if ( outtype .eq. '1' ) then
                        print*, real( lon * dpr() ),
     &                          real( lat * dpr() ), real( elev )
                     end if
                  end if

!............................................................................!
!- 5.3.2.8
!#### Get and write map coordinates for South centered layout
!............................................................................!
                  if ( south .or. outtype .eq. 's' .or.
     &                            outtype .eq. 't'      ) then
                     x = 2d0 - x
                     y = 1d0 - y
                     call quincquad( x, y, p, q  )
                     if ( trans05 .or. outtype .eq. 't' ) then
                        p = p - 0.5d0
                        q = q - 0.5d0
                     end if
                     if ( south ) then
                        write( 26, * ) real( p ), real( q ),
     &                                 real( elev )
                     end if
                     if ( outtype .eq. 's' .or. outtype .eq. 't' ) then
                        print*, real( p ), real( q ),
     &                          real( elev )
                     end if
                  end if

               end do
 4000          continue

!----------------------------------------------------------------------------!
!- 5.3.3
!### Close input file
!----------------------------------------------------------------------------!
               close( 11 )

!----------------------------------------------------------------------------!
!- 5.3.4
!### Print statistics
!----------------------------------------------------------------------------!
               if ( outtype .eq. ' ' ) then
                  print*, npoint, 'points processed.'
               end if

            end if

         end if

      end do

      if ( outtype .ne. ' ' ) then
         print*, nptot, 'points total processed.'
      end if

!****************************************************************************!
!- 6
!# Check if any input was processed
!****************************************************************************!
      if ( nptot .eq. 0 ) then
         print*, 'Warning: no input data given.'
      end if

      end

!****************************************************************************!
!- 7
!# Subroutine to print help message
!****************************************************************************!
      subroutine print_help()
      implicit none
      include 'help_data.f'
      integer   irec
      do irec = 1, nrec
         print '(a)', halfrec(2*irec-1)//halfrec(2*irec)
      end do
      end
