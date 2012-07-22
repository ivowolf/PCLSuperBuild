#-----------------------------------------------------------------------------
# Get and build VTK
#
#-----------------------------------------------------------------------------

if(NOT VTK_TAG)
  set( VTK_TAG "release" )
endif()

find_package(Qt4)
set(USE_QT "OFF")
if(QT4_FOUND)
  set(USE_QT "ON")
endif()

ExternalProject_Add(VTK
  GIT_REPOSITORY "${git_protocol}://vtk.org/VTK.git"
  GIT_TAG "${VTK_TAG}"
  SOURCE_DIR VTK
  BINARY_DIR VTK-build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
    -DBUILD_SHARED_LIBS:BOOL=TRUE
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DVTK_USE_QT:BOOL=${USE_QT}
  INSTALL_COMMAND ""
)

set(VTK_DIR "${CMAKE_BINARY_DIR}/VTK-build")
