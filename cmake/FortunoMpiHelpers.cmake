# This file is part of Fortuno.
# Licensed under the BSD-2-Clause Plus Patent license.
# SPDX-License-Identifier: BSD-2-Clause-Patent

include(FetchContent)


# Sets up the build type.
function (fortuno_mpi_setup_build_type default_build_type)

  get_property(_multiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(_multiConfig)
    message(STATUS "Build type multi-config (build type selected at the build step)")
  else()
    if(NOT CMAKE_BUILD_TYPE)
      message(STATUS "Build type ${default_build_type} (default single-config)")
      set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Build type" FORCE)
      set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")
      set_property(
        CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "RelWithDebInfo"
      )
    else()
      message(STATUS "Fortuno: build type: ${CMAKE_BUILD_TYPE} (manually selected single-config)")
    endif()
  endif()

endfunction()


# Obtains a subproject by the provided list of methods.
#
# Args:
#   subproject_package: name of the subproject package
#   PACKAGE_SOURCE_DIR package_source_dir: where to download the package source
#   TARGETS target: Target names to use for checking whether subproject was obtained successfully
#   GIT_REPOSITORY git_repository: Git repository to fetch the subproject from.
#   GIT_REVISION git_revision: Git revision to fetch
#   GET_METHODS get_methods: priority list of get methods to obtain the subproject,
#     possible choices are 'find', 'fetch'.
#   FIND_PACKAGE_ARGS find_package_args: optional arguments to pass to find_package()
#
function (fortuno_mpi_get_subproject subproject_package)
  list(REMOVE_AT ARGV 0)
  set(one_value_args PACKAGE SOURCE_DIR GIT_REPOSITORY GIT_REVISION)
  set(multi_value_args GET_METHODS TARGETS FIND_PACKAGE_ARGS)
  cmake_parse_arguments(subproject "" "${one_value_args}" "${multi_value_args}" ${ARGV})

  # Check whether targets are already there
  set(_targets_found)
  set(_targets_missing)
  foreach (_target IN ITEMS ${subproject_TARGETS})
    if (TARGET ${_target})
      LIST(APPEND _targets_found ${_target})
    else ()
      LIST(APPEND _targets_missing ${_target})
    endif ()
  endforeach ()
  if (_targets_found AND _targets_missing)
    message(
      FATAL_ERROR
      "Subproject ${subproject_package}: Inconsistent targets, some targets (${_targets_found}) "
      "exist already, while others (${_targets_missing}) are missing"
    )
  elseif (_targets_found)
    message(STATUS "Subproject ${subproject_package}: All targets already defined")
    return ()
  endif ()

  # Obtain subproject according to the priority list
  set(_allowed_methods "find" "fetch")
  foreach (_get_method IN ITEMS ${subproject_GET_METHODS})

    # Check get-method name correctness
    if (NOT ${_get_method} IN_LIST _allowed_methods)
      message(
        FATAL_ERROR
        "Subproject ${subproject_package}: Invalid subproject get method '${_get_method}'"
      )
    endif ()

    # Try to find the package in the system
    if ("${_get_method}" STREQUAL "find")

      find_package(${subproject_package} QUIET ${subproject_FIND_PACKAGE_ARGS})
      if (${${subproject_package}_FOUND})
        message(STATUS "Subproject ${subproject_package}: found by find_package()")
        break ()
      endif ()

    # Fetch package from external source (if it had not been fetched yet)
    elseif ("${_get_method}" STREQUAL "fetch")

      if (EXISTS "${subproject_SOURCE_DIR}")
        message(
          STATUS
          "Subproject ${subproject_package}: source directory ${subproject_SOURCE_DIR} "
          "already exists, will use local version instead of fetching"
        )
        add_subdirectory(${subproject_SOURCE_DIR})
        break ()
      endif ()

      FetchContent_Declare(
        ${subproject_package}
        SOURCE_DIR ${subproject_SOURCE_DIR}
        GIT_REPOSITORY ${subproject_GIT_REPOSITORY}
        GIT_TAG ${subproject_GIT_REVISION}
      )
      FetchContent_MakeAvailable(${subproject_package})

      message(
        STATUS
        "Subproject ${subproject_package}: fetched from git repository "
        "${subproject_GIT_REPOSITORY}@${subproject_GIT_REVISION} to source directory "
        "${subproject_SOURCE_DIR}"
      )
      break ()

    endif()

  endforeach ()

  # Check whether all required targets are present
  foreach (_target IN ITEMS ${subproject_TARGETS})
    if (NOT TARGET ${_target})
      message(
        FATAL_ERROR
        "Subproject ${subproject_package}: Could not obtain subproject to provide target "
        "${_target}"
      )
    endif ()
  endforeach ()

endfunction ()
