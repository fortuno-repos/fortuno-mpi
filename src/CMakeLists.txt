# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

add_library(Fortuno_MPI)
set_target_properties(
  Fortuno_MPI PROPERTIES
  VERSION ${PROJECT_VERSION}
  # SOVERSION ${PROJECT_VERSION_MAJOR}
  SOVERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  EXPORT_NAME Fortuno_MPI
  OUTPUT_NAME fortuno-mpi
)
add_library(Fortuno::Fortuno_MPI ALIAS Fortuno_MPI)

add_subdirectory(fortuno)

target_link_libraries(Fortuno_MPI PRIVATE MPI::MPI_Fortran)
target_link_libraries(Fortuno_MPI PUBLIC Fortuno::Fortuno)

# Store generated mod-files in a separate folder
set(moduledir "${CMAKE_CURRENT_BINARY_DIR}/mods")
set_target_properties(
  Fortuno_MPI PROPERTIES
  Fortran_MODULE_DIRECTORY "${moduledir}"
)

# Add mod-file directory to include search path for targets depending on the library
target_include_directories(
  Fortuno_MPI PUBLIC
  $<BUILD_INTERFACE:${moduledir}>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_LIBDIR}/${FORTUNO_MPI_INSTALL_MODULEDIR}>
)

if (FORTUNO_MPI_INSTALL)
  install(
    TARGETS Fortuno_MPI
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
