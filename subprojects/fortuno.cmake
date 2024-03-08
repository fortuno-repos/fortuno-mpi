function (_fortuno_mpi_get_subproject_fortuno)

  # Define all subproject related variables
  set(FORTUNO_INSTALL ${FORTUNO_MPI_INSTALL})
  set(FORTUNO_INSTALL_MODULEDIR ${FORTUNO_MPI_INSTALL_MODULEDIR})
  set(FORTUNO_BUILD_SHARED_LIBS ${FORTUNO_MPI_BUILD_SHARED_LIBS})

  # Get the subproject
  fortuno_mpi_get_subproject(
    PACKAGE Fortuno
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/subprojects/fortuno
    GET_METHODS ${FORTUNO_MPI_SUBPROJECT_GET_METHODS}
    GIT_REPOSITORY "https://github.com/fortuno-repos/fortuno.git"
    GIT_REVISION "main"
    TARGETS Fortuno::Fortuno
    EXPORT_VARS Fortuno_VERSION
  )
  set(Fortuno_VERSION "${Fortuno_VERSION}" PARENT_SCOPE)

endfunction ()

_fortuno_mpi_get_subproject_fortuno()
