set(fortuno_mpi_sub_fortuno_package Fortuno)
set(fortuno_mpi_sub_fortuno_source_dir ${PROJECT_SOURCE_DIR}/subprojects/fortuno)
set(fortuno_mpi_sub_fortuno_target Fortuno::Fortuno)
set(fortuno_mpi_sub_fortuno_git_repository "https://github.com/fortuno-repos/fortuno.git")
set(fortuno_mpi_sub_fortuno_git_revision "main")

function (fortuno_mpi_sub_fortuno_add_subdir)
  set(FORTUNO_INSTALL ${FORTUNO_MPI_INSTALL})
  set(FORTUNO_INSTALL_MODULEDIR ${FORTUNO_MPI_INSTALL_MODULEDIR})
  set(FORTUNO_BUILD_SHARED_LIBS ${FORTUNO_MPI_BUILD_SHARED_LIBS})
  add_subdirectory(subprojects/fortuno)
endfunction ()

fortuno_mpi_get_subproject(fortuno "${FORTUNO_MPI_SUBPROJECT_GET_METHODS}")
