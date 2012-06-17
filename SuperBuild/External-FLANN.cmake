#-----------------------------------------------------------------------------
# Get FLANN
#
#-----------------------------------------------------------------------------
set(FLANN_URL "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.7.1-src.zip")

ExternalProject_Add(FLANN
  URL ${FLANN_URL}
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
  SOURCE_DIR FLANN
  BINARY_DIR FLANN-build
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/FLANN-install
)

find_library(FLANN_LIBRARY
  NAMES flann_cpp flann_cpp_s
  PATHS ${CMAKE_BINARY_DIR}/FLANN-install
  PATH_SUFFIXES lib lib64)

find_path(FLANN_INCLUDE_DIR flann/flann.hpp
  PATHS ${CMAKE_BINARY_DIR}/FLANN-install
  PATH_SUFFIXES include)
