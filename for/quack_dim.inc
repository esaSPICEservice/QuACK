      integer    nx
      parameter( nx   = 401 )

      integer    ny
      parameter( ny   = 201 )

      integer    npos
      parameter( npos = nx * ny )

      integer    ncon
      parameter( ncon = ( nx - 1 ) * ( ny - 1 ) * 2 )

      integer    dladsz
      parameter( dladsz = 8 )
!  This one must match the SPICE value defined in
!  toolkit/src/spicelib/dsk02.inc.
