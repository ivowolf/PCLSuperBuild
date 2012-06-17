#-----------------------------------------------------------------------------
# Get and build GTest
#
#-----------------------------------------------------------------------------

set(GTEST_URL "http://googletest.googlecode.com/files/gtest-1.6.0.zip")

ExternalProject_Add(GTest
  URL ${GTEST_URL}
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
  SOURCE_DIR GTest
  BINARY_DIR GTest-build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    INSTALL_COMMAND ""
)

set(GTEST_ROOT ${CMAKE_BINARY_DIR}/GTest-build)
set(GTEST_INCLUDE_DIR ${CMAKE_BINARY_DIR}/GTest/include)
