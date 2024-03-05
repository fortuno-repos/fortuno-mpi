# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

### Project definition ###

project(
  'fortuno-mpi',
  'fortran',
  version: '0.1.0',
)

### Getting dependencies ###

fortuno_mpi_deps = []

mpi_fortran_dep = dependency('mpi', language: 'fortran', required: true)
fortuno_mpi_deps += mpi_fortran_dep

fortuno_dep = dependency('fortuno', fallback: ['fortuno', 'fortuno_dep'])
fortuno_mpi_deps += fortuno_dep

### Building the library ###

fortuno_mpi_srcs = []
subdir('src')

fortuno_mpi_lib = library(
  meson.project_name(),
  version: meson.project_version(),
  sources: fortuno_mpi_srcs,
  dependencies: fortuno_mpi_deps,
)

### Exporting the library ###

fortuno_mpi_dep = declare_dependency(
  link_with: fortuno_mpi_lib,
  dependencies: fortuno_mpi_deps,
)

### Building optional components ###

build_examples = get_option('build_examples')
if build_examples
  subdir('example')
endif
