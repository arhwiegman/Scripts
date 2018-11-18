def compile_fortran(source, module_name, extra_args=''):
    import os
    import tempfile
    import sys
    import numpy.f2py  # just to check it presents
    from numpy.distutils.exec_command import exec_command

    folder = os.path.dirname(os.path.realpath(__file__))
    with tempfile.NamedTemporaryFile(suffix='.f90') as f:
        f.write(source)
        f.flush()

        args = ' -c -m {} {} {}'.format(module_name, f.name, extra_args)
        command = 'cd "{}" && "{}" -c "import numpy.f2py as f2py;f2py.main()" {}'.format(folder, sys.executable, args)
        status, output = exec_command(command)
        return status, output, command
		
fortran_source = '''
  subroutine my_function(x, y, z)
      real, intent(in) :: x(:), y(:)
      real, intent(out) :: z(size(x))
      ! using vector operations
      z(:) = sin(x(:) + y(:))
  end subroutine
'''
status, output, command = compile_fortran(fortran_source, module_name='mymodule',
                                          extra_args="--f90flags='-fopenmp' -lgomp")
def empty2darray (foo,i = 10,j = 10):
	#x = [[foo for i in range(10)] for j in range(10)] #nested list comprehension
	[x[:] for x in [[foo] * i] * j]
	return(x)									  
from mymodule import my_function
z = None
x = "bar"
z = "foobar"
my_function(x,y,z)
