
  subroutine my_function(x, y, z)
      real, intent(in) :: x(:), y(:)
      real, intent(out) :: z(size(x))
      ! using vector operations
      z(:) = sin(x(:) + y(:))
  end subroutine
