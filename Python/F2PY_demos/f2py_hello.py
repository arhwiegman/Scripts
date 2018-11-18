from numpy import f2py
source = '''
      subroutine foo
      print*, "Hello world!"
      end 
'''
f2py.compile(source, modulename='hello')

import hello
hello.foo()