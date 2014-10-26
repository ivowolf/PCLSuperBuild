# Called by External-FLANN.cmake (ExternalProject_Add) as a patch for FLANN-1.8.4.

# read whole file
set(path "PCLConfig.cmake.in")
file(STRINGS ${path} contents NEWLINE_CONSUME)

# Add the BOOST_ROOT
string(REPLACE "endif(PCL_ALL_IN_ONE_INSTALLER)" "  set(BOOST_ROOT \"@BOOST_ROOT@\")\n  endif(PCL_ALL_IN_ONE_INSTALLER)" contents ${contents})

# set variable CONTENTS, which is substituted in TEMPLATE_FILE
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

