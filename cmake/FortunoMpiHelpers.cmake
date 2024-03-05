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


# Gets a subproject.
#
# Args:
#   subproject: name of the subproject
#   get_methods: priority list of get methods to obtain the subproject,
#     possible choices are 'find' and 'fetch'
#
macro (fortuno_mpi_get_subproject subproject get_methods)

  set(_prefix fortuno_mpi_sub_${subproject})
  set(_subproject_package ${${_prefix}_package})
  set(_subproject_source_dir ${${_prefix}_source_dir})
  set(_subproject_target ${${_prefix}_target})
  set(_subproject_git_repository ${${_prefix}_git_repository})
  set(_subproject_git_revision ${${_prefix}_git_revision})
  set(_subproject_dir ${${_prefix}_source_dir})

  if (TARGET ${_subproject_target})
    return ()
  endif ()

  foreach(_get_method IN ITEMS ${get_methods})

    if ("${_get_method}" STREQUAL "find")
      find_package(${_subproject_package})
      if (${_subproject_package}_FOUND)
        message(STATUS "Subproject ${subproject}: package ${_subproject_package} found")
        break()
      else ()
        message(STATUS "Subproject ${subproject}: package ${_subproject_package} not found")
      endif ()
    elseif ("${_get_method}" STREQUAL "fetch")
      if (EXISTS ${_subproject_dir})
        message(
          STATUS
          "Subproject ${subproject}: fetch skipped as source folder ${_subproject_dir} exists "
          "already"
        )
      else ()
        message(
          STATUS
          "Subproject ${subproject}: fetching from repository ${_subproject_git_repository} "
          "(revision ${_subproject_git_revision}) into source folder ${_subproject_dir}"
        )
        FetchContent_Declare(
          ${subproject}
          SOURCE_DIR ${_subproject_dir}
          GIT_REPOSITORY ${_subproject_git_repository}
          GIT_TAG ${_subproject_git_revision}
        )
        FetchContent_Populate(${subproject})
      endif ()
      cmake_language(CALL ${_prefix}_add_subdir)
      break()
    endif ()

  endforeach ()

  if (NOT TARGET ${_subproject_target})
    message(
      FATAL_ERROR
      "Subproject ${subproject}: Could not obtain to export target ${_subproject_target}"
    )
  endif ()

  unset(_prefix)
  unset(_subproject_package)
  unset(_subproject_source_dir)
  unset(_subproject_target)
  unset(_subproject_git_repository)
  unset(_subproject_git_revision)
  unset(_subproject_dir)
  unset(_get_method)

endmacro ()
