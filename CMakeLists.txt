CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(PCLSuperBuild)
ENABLE_TESTING()

# Configure the CTestCustom.cmake file
configure_file(CMake/CTestCustom.cmake.in CTestCustom.cmake @ONLY)

include( ${CMAKE_SOURCE_DIR}/SuperBuild.cmake )
