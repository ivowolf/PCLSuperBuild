#-----------------------------------------------------------------------------
# Get FLANN
#
#-----------------------------------------------------------------------------
if(NOT FLANN_URL)
  set(FLANN_URL "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.7.1-src.zip")
  #set(FLANN_URL "http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.zip")
endif()

set(FLANN_PATCH_COMMAND ${CMAKE_COMMAND} -DTEMPLATE_FILE:FILEPATH=${PCLSuperBuild_SOURCE_DIR}/CMakeExternals/EmptyFileForPatching.dummy -P ${PCLSuperBuild_SOURCE_DIR}/CMakeExternals/PatchFLANN-1.7.1.cmake)

ExternalProject_Add(FLANN
  URL ${FLANN_URL}
  URL_MD5 d780795f523eabda7c7ea09c6f5cf235 #for 1.7.1
  #URL_MD5 a0ecd46be2ee11a68d2a7d9c6b4ce701 #for 1.8.4
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
  SOURCE_DIR FLANN
  BINARY_DIR FLANN-build
  PATCH_COMMAND ${FLANN_PATCH_COMMAND}
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/FLANN-install
    -DBUILD_MATLAB_BINDINGS=OFF
    -DBUILD_PYTHON_BINDINGS=OFF
)

set(FLANN_INCLUDE_DIR ${CMAKE_BINARY_DIR}/FLANN-install/include)
if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Windows"))
  set(FLANN_LIBRARY ${CMAKE_BINARY_DIR}/FLANN-build/lib/libflann${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(FLANN_LIBRARY ${CMAKE_BINARY_DIR}/FLANN-install/lib/flann.lib)
endif()