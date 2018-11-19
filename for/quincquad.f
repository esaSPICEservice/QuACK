      subroutine quincquad( x, y, p, q )
      implicit none

CCC_ Parameter descriptions

      double precision   x
      double precision   y
!     INPUT: Coordinates of the point on the quincuncial map in side by side
!     layout, Northern hemishpere left, Southern hemisphere right. Map width
!     is 2, map height is 1. (0,0) is in the lower left corner, x is to the
!     right, y is up.

      double precision   p
      double precision   q
!     OUTPUT: Coordinates of the point in quincuncial layout, with the Northern
!     hemisphere rotated 45 deg clockwise and the Southern hemisphere
!     diagonally cut into four pieces and these attached with the long edges
!     appropriately to the Northern hemisphere. Width and height of the map are
!     1. (0,0) is in the lower left corner, p is to the right, q is up.

CCC_ Variables
      double precision   sr2
      double precision   tol
      logical            valid
      double precision   x1
      double precision   y1

      sr2 = sqrt( 2d0 )
      tol = 1d-9

CCC_ Round edge values
      if ( abs( x - 0d0 ) .le. tol ) x = 0d0
      if ( abs( x - 2d0 ) .le. tol ) x = 2d0
      if ( abs( y - 0d0 ) .le. tol ) y = 0d0
      if ( abs( y - 1d0 ) .le. tol ) y = 1d0
      
CCC_ Northern hemisphere and left triangle of Southern
      valid = .true.
      if ( x .le. 1d0 .or.
     &     abs( x - 1d0 ) + abs( y - 0.5d0 ) .le. 0.5d0 ) then 
         x1 = x
         y1 = y

CCC_ Upper triangle of Southern
      else if ( abs( x - 1.5d0 ) + abs( y - 1d0 ) .le. 0.5d0 ) then
         x1 = 2d0 - x
         y1 = 2d0 - y
         
CCC_ Lower triangle of Southern
      else if ( abs( x - 1.5d0 ) + abs( y ) .le. 0.5d0 ) then
         x1 = 2d0 - x
         y1 =     - y
         
CCC_ Right triangle of Southern
      else if ( abs( x - 2d0 ) + abs( y - 0.5d0 ) .le. 0.5d0 ) then 
         x1 = x - 2d0
         y1 = y

CCC_ Unknown
      else
         valid = .false.
         p = -1d0
         q = -1d0

      end if

      if ( valid ) then
      
CCC_ Transform coordinates
         p =         x1   / sr2 + y1 / sr2
         q = ( 1d0 - x1 ) / sr2 + y1 / sr2

CCC_ Scale square to 1x1
         p = p * sr2 / 2d0
         q = q * sr2 / 2d0

CCC_ Round edge values
         if ( abs( p - 0d0 ) .le. tol ) p = 0d0
         if ( abs( p - 1d0 ) .le. tol ) p = 1d0
         if ( abs( q - 0d0 ) .le. tol ) q = 0d0
         if ( abs( q - 1d0 ) .le. tol ) q = 1d0

      end if
            
      end
      
