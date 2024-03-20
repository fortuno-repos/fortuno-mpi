! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Contains a trivial implementation for a serial suite
module fortuno_mpi_mpisuite
  use fortuno, only : test_item
  use fortuno_mpi_mpibasetypes, only : mpi_suite_base
  implicit none

  private
  public :: mpi_suite, mpi_suite_item


  !> Base type for all serial suites
  type, extends(mpi_suite_base) :: mpi_suite
  end type mpi_suite

contains

  !> Returns a serial suite instance wrapped as test_item
  function mpi_suite_item(name, items) result(testitem)
    character(*), intent(in) :: name
    type(test_item), intent(in) :: items(:)
    type(test_item), allocatable :: testitem

    allocate(testitem)
    testitem%item = mpi_suite(name=name, items=items)

  end function mpi_suite_item

end module fortuno_mpi_mpisuite
