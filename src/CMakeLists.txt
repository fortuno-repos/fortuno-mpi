# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

# Folder for generated mod-files
set(moduledir "${CMAKE_CURRENT_BINARY_DIR}/mods")

add_library(fortuno_mpi)
set_target_properties(
  fortuno_mpi PROPERTIES
  VERSION ${PROJECT_VERSION}
  # TODO: change to ${PROJECT_VERSION_MAJOR} once project version reaches 1.0
  SOVERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  EXPORT_NAME fortuno_mpi
  OUTPUT_NAME fortuno-mpi
  Fortran_MODULE_DIRECTORY "${moduledir}"
)
target_link_libraries(Fortuno_MPI PRIVATE MPI::MPI_Fortran)
target_link_libraries(Fortuno_MPI PUBLIC Fortuno::Fortuno)
target_include_directories(
  Fortuno_MPI PUBLIC
  $<BUILD_INTERFACE:${moduledir}>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}/${FORTUNO_MPI_INSTALL_MODULEDIR}>
)
target_sources(fortuno_mpi PRIVATE fortuno_mpi.f90)
add_subdirectory(fortuno_mpi)

add_library(Fortuno::fortuno_mpi ALIAS fortuno_mpi)

if (FORTUNO_MPI_INSTALL)
  install(
    TARGETS fortuno_mpi
    EXPORT FortunoMpiTargets
    LIBRARY
      DESTINATION "${CMAKE_INSTALL_LIBDIR}"
      COMPONENT FortunoMpi_runtime
      NAMELINK_COMPONENT FortunoMpi_development
    PUBLIC_HEADER
      DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
      COMPONENT FortunoMpi_development
  )
  install(
    DIRECTORY "${moduledir}/"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/${FORTUNO_MPI_INSTALL_MODULEDIR}"
    COMPONENT FortunoMpi_development
  )
endif ()
