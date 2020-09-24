      subroutine ixiy2ipos( ix, iy, ipos )
      implicit none
!  This differs from ixiy2ipos in that nx is not passed as an arc but
!  included from a file.
      

      integer   ipos
      integer   ix
      integer   iy

      include 'quack_dim.inc'

      ipos = nx * ( iy - 1 ) + ix

      end
