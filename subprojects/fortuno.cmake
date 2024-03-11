# Imports the Fortuno subproject.

# Define variables influencing how and from where the subproject is obtained
set(CMAKE_REQUIRE_FIND_PACKAGE_Fortuno ${FORTUNO_MPI_SUBPROJECT_REQUIRE_FIND})
set(CMAKE_DISABLE_FIND_PACKAGE_Fortuno ${FORTUNO_MPI_SUBPROJECT_DISABLE_FIND})
# set FETCHCONTENT_SOURCE_DIR_FORTUNO to use a local source of the subproject

# Define all subproject related variables
option(FORTUNO_INSTALL "Fortuno: Whether to install project" ${FORTUNO_MPI_INSTALL})
set(
  FORTUNO_INSTALL_MODULEDIR "${FORTUNO_MPI_INSTALL_MODULEDIR}" CACHE STRING
  "Fortuno: Installation directory for Fortran module files (relative to CMAKE_INSTALL_LIBDIR)"
)
option(
  FORTUNO_BUILD_SHARED_LIBS "Fortuno: Build as shared library" ${FORTUNO_MPI_BUILD_SHARED_LIBS}
)

FetchContent_Declare(
  Fortuno
  GIT_REPOSITORY "https://github.com/fortuno-repos/fortuno.git"
  GIT_TAG "main"
  FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(Fortuno)

if (Fortuno_FOUND)
  message(STATUS "Subproject Fortuno: using installed version")
else ()
  message(STATUS "Subproject Fortuno: building from source in ${fortuno_SOURCE_DIR}")
endif ()
