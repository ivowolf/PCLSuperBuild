#-----------------------------------------------------------------------------
# Get and build VTK
#
#-----------------------------------------------------------------------------

if(NOT QHULL_TAG)
  set( QHULL_TAG "master" )
endif()

ExternalProject_Add(Qhull
  GIT_REPOSITORY "${git_protocol}://gitorious.org/qhull/qhull.git"
  GIT_TAG "${QHULL_TAG}"
  SOURCE_DIR Qhull
  BINARY_DIR Qhull-build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/Qhull-install
)

set(QHULL_INCLUDE_DIR ${CMAKE_BINARY_DIR}/Qhull-install/include)
set(QHULL_ROOT ${CMAKE_BINARY_DIR}/Qhull-install)
if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Windows"))
  set(QHULL_LIBRARY ${CMAKE_BINARY_DIR}/Qhull-install/lib/libqhull${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(QHULL_LIBRARY ${CMAKE_BINARY_DIR}/Qhull-install/lib/qhullstatic.lib)
endif()

