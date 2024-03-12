# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

target_sources(
  Fortuno_MPI
  PRIVATE
  mpi.f90
)
add_subdirectory(mpi)
