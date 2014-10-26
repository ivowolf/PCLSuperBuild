#
# This is the main cmake file that defines the external projects
# 
# If you prefer to use your our build for a package, define:
# Boost: BOOST_ROOT
# Eigen3: EIGEN_INCLUDE_DIR
# FLANN: FLANN_LIBRARY, FLANN_INCLUDE_DIR
# Qhull: QHULL_LIBRARY, QHULL_INCLUDE_DIR
# VTK: VTK_DIR
#
# If you prefer to use a different version of a package, define:
# Boost:
#   set(BOOST_URL "http://sourceforge.net/projects/boost/files/boost/1.49.0/boost_1_49_0.tar.gz")
# Eigen3:
#   set(EIGEN3_URL "http://mirrors.mit.edu/ubuntu/pool/universe/e/eigen3/eigen3_3.0.5.orig.tar.bz2")
# FLANN:
#   set(FLANN_URL "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.7.1-src.zip")
#   set(FLANN_URL "http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.zip")
# Qhull:
#    set( QHULL_TAG "master" )
# VTK:
#   set( VTK_TAG "release" )
#
find_package(Git)
if(NOT GIT_FOUND)
  message(ERROR "Cannot find git. git is required for Superbuild")
endif()

option( USE_GIT_PROTOCOL "If behind a firewall turn this off to use http instead." ON)

set(git_protocol "git")

include( ExternalProject )

# Compute -G arg for configuring external projects with the same CMake gener    ator:
if(CMAKE_EXTRA_GENERATOR)
  set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(gen "${CMAKE_GENERATOR}" )
endif()

if(NOT CTEST_BUILD_CONFIGURATION)
  set(CTEST_BUILD_CONFIGURATION Release)
endif()

set( PCL_DEPENDENCIES )

if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Windows"))
  if( NOT USB_10_LIBRARY OR NOT USB_10_INCLULDE_DIR)
    include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-libusb.cmake )
    list( APPEND PCL_DEPENDENCIES libusb )
  endif()
endif()

if( NOT BOOST_ROOT )
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-Boost.cmake )
  list( APPEND PCL_DEPENDENCIES Boost )
endif()

if( NOT FLANN_LIBRARY OR NOT FLANN_INCLUDE_DIR)
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-FLANN.cmake )
  list( APPEND PCL_DEPENDENCIES FLANN )
endif()

if( NOT EIGEN_INCLUDE_DIR)
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-Eigen3.cmake )
  list( APPEND PCL_DEPENDENCIES Eigen3 )
endif()

if( NOT VTK_DIR)
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-VTK.cmake )
  list( APPEND PCL_DEPENDENCIES VTK )
endif()

if( NOT QHULL_LIBRARY OR NOT QHULL_INCLUDE_DIR)
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/External-Qhull.cmake )
  list( APPEND PCL_DEPENDENCIES Qhull )
endif()

if( WIN32)
  set(PCL_PATCH_COMMAND ${CMAKE_COMMAND} -DTEMPLATE_FILE:FILEPATH=${PCLSuperBuild_SOURCE_DIR}/CMakeExternals/EmptyFileForPatching.dummy -P ${PCLSuperBuild_SOURCE_DIR}/CMakeExternals/PatchPCL.cmake)
endif()

ExternalProject_Add( PCL
  DEPENDS ${PCL_DEPENDENCIES}
  GIT_REPOSITORY "https://github.com/PointCloudLibrary/pcl.git"
  GIT_TAG "pcl-1.7.2" #6951197e3926c1dbe8293f610ae11941d9d807fc"
  SOURCE_DIR PCL
  BINARY_DIR PCL-build
  CMAKE_GENERATOR ${gen}
  PATCH_COMMAND ${PCL_PATCH_COMMAND}
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
    -DBUILD_SHARED_LIBS:BOOL=TRUE
    -DBUILD_TESTS:BOOL=FALSE#TRUE
    # Eigen3
    -DEIGEN_INCLUDE_DIR:PATH=${EIGEN_INCLUDE_DIR}
    # Boost
    -DBoost_NO_SYSTEM_PATHS:BOOL=TRUE
    -DBOOST_ROOT:PATH=${BOOST_ROOT}
    # FLANN
     -DFLANN_LIBRARY:PATH=${FLANN_LIBRARY}
     -DFLANN_INCLUDE_DIR:PATH=${FLANN_INCLUDE_DIR}
    # VTK
    -DVTK_DIR:PATH=${VTK_DIR}
    # Qhull
    -DQHULL_LIBRARY:PATH=${QHULL_LIBRARY}
    -DQHULL_INCLUDE_DIR:PATH=${QHULL_INCLUDE_DIR}

    -DUSB_10_LIBRARY:path=${USB_10_LIBRARY}
    -DUSB_10_INCLUDE_DIR:path=${USB_10_INCLUDE_DIR}
  INSTALL_COMMAND ""
)
