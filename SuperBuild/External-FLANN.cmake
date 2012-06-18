#-----------------------------------------------------------------------------
# Get FLANN
#
#-----------------------------------------------------------------------------
set(FLANN_URL "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.7.1-src.zip")

ExternalProject_Add(FLANN
  DEPENDS GTest
  URL ${FLANN_URL}
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
  SOURCE_DIR FLANN
  BINARY_DIR FLANN-build
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/FLANN-install
)

set(FLANN_INCLUDE_DIR ${CMAKE_BINARY_DIR}/FLANN-install/include)
set(FLANN_LIBRARY ${CMAKE_BINARY_DIR}/FLANN-install/lib/libflann_cpp${CMAKE_SHARED_LIBRARY_SUFFIX})
