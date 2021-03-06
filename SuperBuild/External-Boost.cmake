#-----------------------------------------------------------------------------
# Get Boost
#
#-----------------------------------------------------------------------------
if( NOT WIN32)
  configure_file(
    ${CMAKE_SOURCE_DIR}/SuperBuild/boost-configure.sh.in
    ${CMAKE_BINARY_DIR}/boost-configure.sh
    @only
    )
  configure_file(
    ${CMAKE_SOURCE_DIR}/SuperBuild/boost-install.sh.in
    ${CMAKE_BINARY_DIR}/boost-install.sh
    @only
    )
  set(BOOST_CONFIGURE_COMMAND "${CMAKE_BINARY_DIR}/boost-configure.sh")
  set(BOOST_INSTALL_COMMAND "${CMAKE_BINARY_DIR}/boost-install.sh")

  if(NOT BOOST_URL)
    set(BOOST_URL "http://sourceforge.net/projects/boost/files/boost/1.49.0/boost_1_49_0.tar.gz")
  endif()

  ExternalProject_Add(Boost
    URL ${BOOST_URL}
    DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}
    SOURCE_DIR Boost
    BINARY_DIR Boost-build
    CONFIGURE_COMMAND ${BOOST_CONFIGURE_COMMAND}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${BOOST_INSTALL_COMMAND}
  )

  set(BOOST_ROOT ${CMAKE_BINARY_DIR}/Boost-build)
else()
  set(MITK_USE_Boost TRUE)
  if(NOT MITK_THIRDPARTY_DOWNLOAD_PREFIX_URL)
    set(MITK_THIRDPARTY_DOWNLOAD_PREFIX_URL http://mitk.org/download/thirdparty)
  endif()

  set(MITK_USE_Boost_LIBRARIES "thread;filesystem;date_time;iostreams")
  include( ${CMAKE_SOURCE_DIR}/SuperBuild/BoostFromMITK.cmake )
  set(BOOST_ROOT ${CMAKE_BINARY_DIR}/Boost-install)
endif()
