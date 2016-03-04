###############################
#  This file is part of PyLaDa.
#
#  Copyright (C) 2013 National Renewable Energy Lab
#
#  PyLaDa is a high throughput computational platform for Physics. It aims to make it easier to submit
#  large numbers of jobs on supercomputers. It provides a python interface to physical input, such as
#  crystal structures, as well as to a number of DFT (VASP, CRYSTAL) and atomic potential programs. It
#  is able to organise and launch computational jobs on PBS and SLURM.
#
#  PyLaDa is free software: you can redistribute it and/or modify it under the terms of the GNU General
#  Public License as published by the Free Software Foundation, either version 3 of the License, or (at
#  your option) any later version.
#
#  PyLaDa is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
#  Public License for more details.
#
#  You should have received a copy of the GNU General Public License along with PyLaDa.  If not, see
#  <http://www.gnu.org/licenses/>.
###############################

__docformat__ = "restructuredtext en"
from libcpp cimport bool
cimport cython


cdef extern from "cmath" namespace "std":
    float floor(float)
    double floor(double)


cpdef bool _is_integer(cython.floating[:, ::1] vector, cython.floating tolerance):
    cdef:
        int ni = vector.shape[0]
        int nj = vector.shape[1]
        int i, j

    for i in range(ni):
        for j in range(nj):
            if abs(floor(vector[i, j] + 1e-3) - vector[i, j]) > tolerance:
                return False

    return True


cpdef int _lexcompare(cython.integral[::1] a, cython.integral[::1] b):
    """ Lexicographic compare of two numpy arrays

        Compares two arrays, returning 1 or -1 depending on the first element that is not equal, or
        zero if the arrays are identical.

        :returns:
            - a > b: 1
            - a == b: 0
            - a < b: -1

    """
    from .. import error
    if len(a) != len(b):
        raise error.ValueError("Input arrays have different length")

    cdef:
        int na = len(a)
        int i

    for i in range(na):
        if a[i] < b[i]:
            return -1
        elif a[i] > b[i]:
            return 1

    return 0
