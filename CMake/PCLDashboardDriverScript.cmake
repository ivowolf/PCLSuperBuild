#
# Included from a dashboard script, this cmake file will drive the configure
# and build steps of the PCL Superbuild
#

# The following variable are expected to be define in the top-level script:
set(expected_variables
  ADDITIONAL_CMAKECACHE_OPTION
  CTEST_NOTES_FILES
  CTEST_SITE
  CTEST_CMAKE_GENERATOR
  WITH_MEMCHECK
  WITH_COVERAGE
  WITH_DOCUMENTATION
  CTEST_BUILD_CONFIGURATION
  CTEST_TEST_TIMEOUT
  CTEST_BUILD_FLAGS
  CTEST_PROJECT_NAME
  CTEST_SOURCE_DIRECTORY
  CTEST_BINARY_DIRECTORY
  CTEST_BUILD_NAME
  SCRIPT_MODE
  CTEST_COVERAGE_COMMAND
  CTEST_MEMORYCHECK_COMMAND
  CTEST_SVN_COMMAND
  CTEST_GIT_COMMAND
  )

set(repository git://gitorious.org/pclsuperbuild/pclsuperbuild.git)

if(EXISTS "${CTEST_LOG_FILE}")
  list(APPEND CTEST_NOTES_FILES ${CTEST_LOG_FILE})
endif()

foreach(var ${expected_variables})
  if(NOT DEFINED ${var})
    message(FATAL_ERROR "Variable ${var} should be defined in top-level script !")
  endif()
endforeach()

if(NOT DEFINED CTEST_CONFIGURATION_TYPE AND DEFINED CTEST_BUILD_CONFIGURATION)
  set(CTEST_CONFIGURATION_TYPE ${CTEST_BUILD_CONFIGURATION})
endif()


# Should binary directory be cleaned?
set(empty_binary_directory FALSE)

# Attempt to build and test also if 'ctest_update' returned an error
set(force_build FALSE)

# Set model and track options
set(model "")
if(SCRIPT_MODE STREQUAL "experimental")
  set(empty_binary_directory FALSE)
  set(force_build TRUE)
  set(model Experimental)
elseif(SCRIPT_MODE STREQUAL "continuous")
  set(empty_binary_directory TRUE)
  set(force_build FALSE)
  set(model Continuous)
elseif(SCRIPT_MODE STREQUAL "nightly")
  set(empty_binary_directory TRUE)
  set(force_build TRUE)
  set(model Nightly)
else()
  message(FATAL_ERROR "Unknown script mode: '${SCRIPT_MODE}'. Script mode should be either 'experimental', 'continuous' or 'nightly'")
endif()
set(track ${model})
set(track ${CTEST_TRACK_PREFIX}${track}${CTEST_TRACK_SUFFIX})

# For more details, see http://www.kitware.com/blog/home/post/11
set(CTEST_USE_LAUNCHERS 0)
#if(CTEST_CMAKE_GENERATOR MATCHES ".*Makefiles.*")
#  set(CTEST_USE_LAUNCHERS 1)
#endif()
#if(NOT ${CTEST_CMAKE_GENERATOR} MATCHES "Visual Studio")
#  set(CTEST_USE_LAUNCHERS 1)
#endif()

if(empty_binary_directory)
  message("Directory ${CTEST_BINARY_DIRECTORY} cleaned !")
  ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
endif()

set(CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")
set(CTEST_SOURCE_DIRECTORY "${CTEST_SOURCE_DIRECTORY}")

#
# run_ctest macro
#
macro(run_ctest)
  ctest_start(${model} TRACK ${track})

  set(build_in_progress_file ${CTEST_BINARY_DIRECTORY}/PCL-build/BUILD_IN_PROGRESS)
  file(WRITE ${build_in_progress_file} "Generated by ${CMAKE_CURRENT_LIST_FILE}\n")

  ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}" RETURN_VALUE FILES_UPDATED)

  # force a build if this is the first run and the build dir is empty
  if(NOT EXISTS "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt")
    message("First time build - Initialize CMakeCache.txt")
    set(force_build TRUE)

    #-------------------------------------------------------------------------
    # Write initial cache.
    #-------------------------------------------------------------------------
    file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CTEST_USE_LAUNCHERS:BOOL=${CTEST_USE_LAUNCHERS}
GIT_EXECUTABLE:FILEPATH=${CTEST_GIT_COMMAND}
WITH_COVERAGE:BOOL=${WITH_COVERAGE}
${ADDITIONAL_CMAKECACHE_OPTION}
")
  endif()

  if(FILES_UPDATED GREATER 0 OR force_build)

    set(force_build FALSE)

    #-------------------------------------------------------------------------
    # Update
    #-------------------------------------------------------------------------
##    ctest_submit(PARTS Update)

    #-------------------------------------------------------------------------
    # Configure
    #-------------------------------------------------------------------------
    message("----------- [ Configure ${CTEST_PROJECT_NAME} ] -----------")

    # First configure the SuperBuild
    ctest_configure(BUILD "${CTEST_BINARY_DIRECTORY}")
    ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")
#    ctest_submit(PARTS Configure)

    # Then configure PCL
    set(pcl_build_dir "${CTEST_BINARY_DIRECTORY}/PCL-build")
    set(pcl_source_dir "${CTEST_BINARY_DIRECTORY}/PCL")
    ctest_configure(
      BUILD "${pcl_build_dir}"
      SOURCE "${pcl_source_dir}"
      APPEND)
##    ctest_submit(PARTS Configure)


    #-------------------------------------------------------------------------
    # Build top level
    #-------------------------------------------------------------------------
    set(build_errors)
    message("----------- [ Build ${CTEST_PROJECT_NAME} ] -----------")
    ctest_build(BUILD "${CTEST_BINARY_DIRECTORY}" NUMBER_ERRORS build_errors)
##    ctest_submit(PARTS Build)
 
    file(REMOVE ${build_in_progress_file})

    #-------------------------------------------------------------------------
    # Test
    #-------------------------------------------------------------------------
    message("----------- [ Test ${CTEST_PROJECT_NAME} ] -----------")
    ctest_test(
      BUILD "${pcl_build_dir}"
    )
##    ctest_submit(PARTS Test)

    #-------------------------------------------------------------------------
    # Global coverage ...
    #-------------------------------------------------------------------------
    # HACK Unfortunately ctest_coverage ignores the BUILD argument, try to force it...
    file(READ ${pcl_build_dir}/CMakeFiles/TargetDirectories.txt pcl_build_coverage_dirs)
    file(APPEND "${CTEST_BINARY_DIRECTORY}/CMakeFiles/TargetDirectories.txt" "${pcl_build_coverage_dirs}")

    if(WITH_COVERAGE AND CTEST_COVERAGE_COMMAND)
      message("----------- [ Global coverage ] -----------")
      ctest_coverage(BUILD "${pcl_build_dir}")
      ctest_submit(PARTS Coverage)
    endif()

    #-------------------------------------------------------------------------
    # Global dynamic analysis ...
    #-------------------------------------------------------------------------
    if(WITH_MEMCHECK AND CTEST_MEMORYCHECK_COMMAND)
        message("----------- [ Global memcheck ] -----------")
        ctest_memcheck(BUILD "${pcl_build_dir}")
        ctest_submit(PARTS MemCheck)
    endif()

    #-------------------------------------------------------------------------
    # Note should be at the end
    #-------------------------------------------------------------------------
    ctest_submit()

  else()
    file(REMOVE ${build_in_progress_file})
  endif()
endmacro()

if(SCRIPT_MODE STREQUAL "continuous")
  while(${CTEST_ELAPSED_TIME} LESS 46800) # Lasts 13 hours (Assuming it starts at 9am, it will end around 10pm)
    set(START_TIME ${CTEST_ELAPSED_TIME})
    run_ctest()
    set(interval 300)
    # Loop no faster than once every <interval> seconds
    message("Wait for ${interval} seconds ...")
    ctest_sleep(${START_TIME} ${interval} ${CTEST_ELAPSED_TIME})
  endwhile()
else()
  run_ctest()
endif()
