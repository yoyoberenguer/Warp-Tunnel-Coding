from distutils.core import setup
from Cython.Build import cythonize

# encoding: utf-8
# USE :
# python setup.py build_ext --inplace

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)
warnings.filterwarnings("ignore", category=FutureWarning)

# /O2 sets a combination of optimizations that optimizes code for maximum speed.
# /Ot (a default setting) tells the compiler to favor optimizations for speed over optimizations for size.
# /Oy suppresses the creation of frame pointers on the call stack for quicker function calls.
setup(
    name='TUNNEL',
    ext_modules=cythonize(Extension(
            "*", ['*.pyx'], extra_compile_args=["/openmp", "/Qpar", "/fp:fast", "/O2", "/Oy", "/Ot"], language="c",
             
        )
    ),
    include_dirs=[numpy.get_include()],
   



