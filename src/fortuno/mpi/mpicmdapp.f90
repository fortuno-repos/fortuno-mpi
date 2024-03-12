! This file is part of Fortuno.
! Licensed under the BSD-2-Clause Plus Patent license.
! SPDX-License-Identifier: BSD-2-Clause-Patent

!> Contains the command line app for driving mpi tests
module fortuno_mpi_mpicmdapp
  use fortuno_base_basetypes, only : test_item
  use fortuno_base_testcmdapp, only : test_cmd_app
  use fortuno_mpi_mpidriver, only : init_mpi_driver, mpi_driver
  use fortuno_mpi_mpienv, only : init_mpi_env, final_mpi_env, mpi_env
  use fortuno_mpi_mpiconlogger, only : init_mpi_console_logger, mpi_console_logger
  implicit none

  private
  public :: init_mpi_cmd_app, execute_mpi_cmd_app, mpi_cmd_app


  !> App for driving mpi tests through command line app
  type, extends(test_cmd_app) :: mpi_cmd_app
  end type mpi_cmd_app

contains

  !> Convenience wrapper setting up and running the mpi command line up
  !!
  !! Note: This routine stops the code during execution and never returns.
  !!
  subroutine execute_mpi_cmd_app(testitems)

    !> Items to be considered by the app
    type(test_item), intent(in) :: testitems(:)

    type(mpi_cmd_app) :: app
    type(mpi_env) :: mpienv
    integer :: exitcode

    call init_mpi_env(mpienv)
    call init_mpi_cmd_app(app, mpienv)
    call app%run(testitems, exitcode)
    call final_mpi_env(mpienv)
    stop exitcode, quiet=.true.

  end subroutine execute_mpi_cmd_app


  !> Set up the mpi command line app
  subroutine init_mpi_cmd_app(this, mpienv)

    !> Instance
    type(mpi_cmd_app), intent(out) :: this

    !> MPI environment
    type(mpi_env), intent(in) :: mpienv

    type(mpi_console_logger), allocatable :: logger
    type(mpi_driver), allocatable :: driver

    allocate(logger)
    call init_mpi_console_logger(logger, mpienv)
    call move_alloc(logger, this%logger)
    allocate(driver)
    call init_mpi_driver(driver, mpienv)
    call move_alloc(driver, this%driver)

  end subroutine init_mpi_cmd_app

end module fortuno_mpi_mpicmdapp
