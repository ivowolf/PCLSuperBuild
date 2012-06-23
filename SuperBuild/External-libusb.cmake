#-----------------------------------------------------------------------------
# Get and build VTK
#
#-----------------------------------------------------------------------------

if(NOT LIBUSB_TAG)
  set( LIBUSB_TAG "master" )
endif()

configure_file(
  ${CMAKE_SOURCE_DIR}/SuperBuild/libusb-configure.sh.in
  ${CMAKE_BINARY_DIR}/libusb-configure.sh
  @only
  )
configure_file(
  ${CMAKE_SOURCE_DIR}/SuperBuild/libusb-install.sh.in
  ${CMAKE_BINARY_DIR}/libusb-install.sh
  @only
  )

set(LIBUSB_CONFIGURE_COMMAND "${CMAKE_BINARY_DIR}/libusb-configure.sh")
set(LIBUSB_INSTALL_COMMAND "${CMAKE_BINARY_DIR}/libusb-install.sh")

ExternalProject_Add(libusb
  GIT_REPOSITORY "${git_protocol}://git.libusb.org/libusb.git"
  GIT_TAG "${LIBUSD_TAG}"
  SOURCE_DIR libusb
  CONFIGURE_COMMAND ${LIBUSB_CONFIGURE_COMMAND}
  BUILD_COMMAND ""
  INSTALL_COMMAND ${LIBUSB_INSTALL_COMMAND}
)

set(USB_10_LIBRARY "${CMAKE_BINARY_DIR}/libusb-install/libusb-1.0${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(USB_10_INCLUDE_DIR "${CMAKE_BINARY_DIR}/libusb-install/include")
