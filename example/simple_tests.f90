! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

module simple_tests
  use mylib, only : broadcast
  use fortuno, only : is_equal, test_item
  use fortuno_mpi, only : global_comm, test => mpi_case_item, check => mpi_check, this_rank
  implicit none

  private
  public :: get_simple_tests

contains

  ! Returns the tests from this module
  function get_simple_tests() result(testitems)
    type(test_item), allocatable :: testitems(:)

    testitems = [&
        test("broadcast", test_broadcast) &
    ]

  end function get_simple_tests


  subroutine test_broadcast()
     integer, parameter :: sourcerank = 0, sourceval = 1, otherval = -1
     integer :: buffer

     character(:), allocatable :: msg

    ! GIVEN source rank contains a different integer value as all other ranks
    if (this_rank() == sourcerank) then
      buffer = sourceval
    else
      buffer = otherval
    end if

    ! WHEN source rank broadcasts its value
    call broadcast(global_comm(), buffer, sourcerank)

    ! Make every third rank fail for demonstration purposes
    block
      use fortuno_utils, only : as_char
      if (mod(this_rank(), 3) == 2) then
        buffer = sourceval + 1
        msg = "Failing on rank " // as_char(this_rank()) // " on purpose"
      end if
    end block

    ! THEN each rank must contain source rank's value
    call check(is_equal(buffer, sourceval), msg=msg)

  end subroutine test_broadcast

end module simple_tests
