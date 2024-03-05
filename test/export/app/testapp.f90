! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Test app driving Fortuno unit tests
program testapp
  use mpi_f08, only : mpi_comm, mpi_bcast, MPI_INTEGER
  use fortuno, only : is_equal
  use fortuno_mpi, only : execute_mpi_cmd_app, global_comm, test => mpi_case_item,&
      & check => mpi_check, this_rank
  implicit none

  call execute_mpi_cmd_app(&
      testitems=[&
          test("success", test_success)&
      ]&
  )

contains

  subroutine test_success()

    integer :: buffer

    buffer = 0
    if (this_rank() == 0) buffer = 1
    call mpi_bcast(buffer, 1, MPI_INTEGER, 0, global_comm())
    call check(is_equal(buffer, 1))

  end subroutine test_success

end program testapp
