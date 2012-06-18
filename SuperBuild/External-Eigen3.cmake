#-----------------------------------------------------------------------------
# Get eigen
#
#-----------------------------------------------------------------------------
if(NOT EIGEN3_URL)
  set(EIGEN3_URL "http://mirrors.mit.edu/ubuntu/pool/universe/e/eigen3/eigen3_3.0.5.orig.tar.bz2")
endif()

ExternalProject_Add(Eigen3
  URL ${EIGEN3_URL}
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
  SOURCE_DIR Eigen3
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

set(EIGEN_INCLUDE_DIR ${CMAKE_BINARY_DIR}/Eigen3)
