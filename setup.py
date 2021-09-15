from distutils.core import setup
from Cython.Build import cythonize
import Cython

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

setup(
    name='TUNNEL',
    ext_modules=cythonize(Extension(
            "*", ['*.pyx'], language="c")),
    include_dirs=[numpy.get_include()])

