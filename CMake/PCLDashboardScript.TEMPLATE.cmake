#############################################################################
# OS      :
# Hardware:
# GPU     :
#############################################################################
# WARNING - The specific version and processor type of this machine
# should be reported in the header above. Indeed, this file will be sent
# to the dashboard as a NOTE file.
#
# On linux, you could run:
#     'uname -o' and 'cat /etc/*-release' to obtain the OS name.
#     'uname -mpi' to obtain hardware details.
##############################################################################

cmake_minimum_required(VERSION 2.8.3)

#-----------------------------------------------------------------------------
# Dashboard properties
#-----------------------------------------------------------------------------
set(MY_OPERATING_SYSTEM   "Linux") # Windows, Linux, Darwin...
set(MY_COMPILER           "g++4.5.2")
set(CTEST_SITE            "mymachine.pcl.com") # for example: mymachine.kitware, mymachine.bwh.harvard.edu, ...
# Open a shell and type in "cmake --help" to obtain the proper spelling
# of the generator
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(MY_BITNESS            "64")

#-----------------------------------------------------------------------------
# Dashboard options
#-----------------------------------------------------------------------------
set(WITH_MEMCHECK FALSE)
set(WITH_COVERAGE FALSE)
set(WITH_DOCUMENTATION FALSE)
set(CTEST_BUILD_CONFIGURATION "Release")
set(CTEST_TEST_TIMEOUT 500)
set(CTEST_BUILD_FLAGS "")

# experimental:
#     - run_ctest() macro will be called *ONE* time
#     - binary directory will *NOT* be cleaned
# continuous:
#     - run_ctest() macro will be called EVERY 5 minutes ...
#     - binary directory will *NOT* be cleaned
#     - configure/build will be executed *ONLY* if the repository has been updated
# nightly_clean:
#     - run_ctest() macro will be called *ONE* time
#     - binary directory *WILL BE* cleaned
# nightly_noclean:
#     - run_ctest() macro will be called *ONE* time
#     - binary directory will *NOT* be cleaned
set(SCRIPT_MODE "experimental") # "experimental", "continuous", "nightly_clean", "nightly_noclean"

# Invoke the script with the following syntax:
#  ctest -S myPCL_nightly.cmake -V
#

#-----------------------------------------------------------------------------
# Additional CMakeCache options
#-----------------------------------------------------------------------------
set(ADDITIONAL_CMAKECACHE_OPTION "
")

#-----------------------------------------------------------------------------
# Set any extra environment variables here
#-----------------------------------------------------------------------------
if(UNIX)
  set(ENV{DISPLAY} ":0")
endif()

#-----------------------------------------------------------------------------
# Required executables
#-----------------------------------------------------------------------------
find_program(CTEST_SVN_COMMAND NAMES svn)
find_program(CTEST_GIT_COMMAND NAMES git)
find_program(CTEST_COVERAGE_COMMAND NAMES gcov)
find_program(CTEST_MEMORYCHECK_COMMAND NAMES valgrind)

#-----------------------------------------------------------------------------
# Build Name
#-----------------------------------------------------------------------------
# Update the following variable to match the chosen build options. This
# variable is used to generate both the build directory and the build
# name.
set(BUILD_OPTIONS_STRING "${MY_BITNESS}bits")

#-----------------------------------------------------------------------------
# Teach the source and build directories
#-----------------------------------------------------------------------------
set(CTEST_SOURCE_DIRECTORY "/home/lorensen/ProjectGIT/PCLSuperBuild")
set(CTEST_BINARY_DIRECTORY "/home/lorensen/ProjectGIT/PCLSuperBuild-experimental")

##########################################
# WARNING: DO NOT EDIT BEYOND THIS POINT #
##########################################

set(CTEST_NOTES_FILES "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

#
# Project specific properties
#
set(CTEST_PROJECT_NAME "PCLSuperBuild")
set(CTEST_BUILD_NAME "${MY_OPERATING_SYSTEM}-${MY_COMPILER}-${BUILD_OPTIONS_STRING}-${CTEST_BUILD_CONFIGURATION}")

#
# Display build info
#
message("CTEST_SITE ................: ${CTEST_SITE}")
message("CTEST_BUILD_NAME ..........: ${CTEST_BUILD_NAME}")
message("SCRIPT_MODE ...............: ${SCRIPT_MODE}")
message("CTEST_BUILD_CONFIGURATION .: ${CTEST_BUILD_CONFIGURATION}")
message("WITH_COVERAGE: ............: ${WITH_COVERAGE}")
message("WITH_MEMCHECK .............: ${WITH_MEMCHECK}")
message("WITH_DOCUMENTATION ........: ${WITH_DOCUMENTATION}")

#
# Include dashboard driver script
#
include(${CTEST_SOURCE_DIRECTORY}/CMake/PCLDashboardDriverScript.cmake)
