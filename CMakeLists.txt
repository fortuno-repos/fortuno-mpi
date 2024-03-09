# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

# The CMake config files were created based on the public template at
# https://github.com/LecrisUT/CMake-Template

#[=================================================================================================[
#                                 Basic project definition                                        #
]=================================================================================================]

cmake_minimum_required(VERSION 3.22...3.28)

list(APPEND CMAKE_MESSAGE_CONTEXT FortunoMpi)
project(
  FortunoMpi
  VERSION 0.1.0
  DESCRIPTION "Extensible unit testing framework for Fortran (MPI dependent part)"
  HOMEPAGE_URL "https://github.com/fortuno-repos/fortuno-mpi"
  LANGUAGES Fortran
)

#[=================================================================================================[
#                                 Options                                                         #
]=================================================================================================]

option(FORTUNO_MPI_BUILD_SHARED_LIBS "Fortuno: Build as shared library" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_MPI_BUILD_TESTS "Fortuno: Build test suite" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_MPI_BUILD_EXAMPLES "Fortuno: Build example apps" ${PROJECT_IS_TOP_LEVEL})

option(FORTUNO_MPI_INSTALL "Fortuno: Install project" ${PROJECT_IS_TOP_LEVEL})

set(
  FORTUNO_MPI_INSTALL_MODULEDIR "modules" CACHE STRING
  "Sub-directory to install the Fortran module files into (relative to CMAKE_INSTALL_LIBDIR)"
)

option(
  FORTUNO_MPI_SUBPROJECT_REQUIRE_FIND
  "Whether all subprojects should be obtained by the find method (e.g. for packaging)"
  FALSE
)

option(
  FORTUNO_MPI_SUBPROJECT_DISABLE_FIND
  "Whether none of the subprojects should be obtained by the find method"
  FALSE
)

#[=================================================================================================[
#                            Project configuration                                                #
]=================================================================================================]

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(FortunoMpiHelpers)

if (FORTUNO_MPI_INSTALL)
  include(CMakePackageConfigHelpers)
  include(GNUInstallDirs)
endif ()

fortuno_mpi_setup_build_type("RelWithDebInfo")
set(BUILD_SHARED_LIBS ${FORTUNO_MPI_BUILD_SHARED_LIBS})

find_package(MPI REQUIRED)
if(NOT MPI_FORTRAN_FOUND)
  message(FATAL_ERROR "Failed to detect MPI-framework for Fortran")
endif()

#[=================================================================================================[
#                                 Main definition                                                 #
]=================================================================================================]

# Get subproject(s)
include(FetchContent)
include(subprojects/fortuno.cmake)

# Build library and examples
add_subdirectory(src)
if (FORTUNO_MPI_BUILD_EXAMPLES)
  add_subdirectory(example)
endif ()

#[=================================================================================================[
#                                 Install and export                                              #
]=================================================================================================]

if (FORTUNO_MPI_INSTALL)

  # pkg-config files
  configure_file(cmake/fortuno-mpi.pc.in fortuno-mpi.pc @ONLY)
  install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/fortuno-mpi.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
    COMPONENT FortunoMpi_development
  )

  # cmake export files
  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/FortunoMpiConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    # COMPATIBILITY SameMajorVersion
    COMPATIBILITY SameMinorVersion
  )
  configure_package_config_file(
      cmake/FortunoMpiConfig.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/FortunoMpiConfig.cmake
      INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoMpi
  )
  install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/FortunoMpiConfigVersion.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FortunoMpiConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoMpi
    COMPONENT FortunoMpi_development
  )

  export(
    EXPORT FortunoMpiTargets
    FILE FortunoMpiTargets.cmake
    NAMESPACE Fortuno::
  )
  install(
    EXPORT FortunoMpiTargets
    FILE FortunoMpiTargets.cmake
    NAMESPACE Fortuno::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FortunoMpi
    COMPONENT FortunoMpi_development
  )
endif ()

# Make project available for FetchContent
if (NOT PROJECT_IS_TOP_LEVEL)
  # Propagate variables
  if (CMAKE_VERSION VERSION_LESS 3.25)
    # TODO: Remove when required minimum cmake version is >= 3.25
    set(FortunoMpi_VERSION ${FortunoMpi_VERSION} PARENT_SCOPE)
    set(FortunoMpi_VERSION_MAJOR ${FortunoMpi_VERSION_MAJOR} PARENT_SCOPE)
    set(FortunoMpi_VERSION_MINOR ${FortunoMpi_VERSION_MINOR} PARENT_SCOPE)
    set(FortunoMpi_VERSION_PATCH ${FortunoMpi_VERSION_PATCH} PARENT_SCOPE)
    set(FortunoMpi_VERSION_TWEAK ${FortunoMpi_VERSION_TWEAK} PARENT_SCOPE)
  else ()
    return(
      PROPAGATE
      FortunoMpi_VERSION
      FortunoMpi_VERSION_MAJOR
      FortunoMpi_VERSION_MINOR
      FortunoMpi_VERSION_PATCH
      FortunoMpi_VERSION_TWEAK
    )
  endif ()
endif ()
