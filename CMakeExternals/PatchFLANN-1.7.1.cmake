# Called by External-FLANN.cmake (ExternalProject_Add) as a patch for FLANN-1.8.4.

# read whole file
set(path "src/cpp/flann/util/cuda/result_set.h")
file(STRINGS ${path} contents NEWLINE_CONSUME)

# Changes for CUDA >= v5.5, see https://github.com/mariusmuja/flann/issues/133
string(REPLACE "__int_as_float(0x7f800000)" "2139095040.f" contents ${contents})

# set variable CONTENTS, which is substituted in TEMPLATE_FILE
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

#read again
file(STRINGS ${path} contents NEWLINE_CONSUME)
string(REPLACE "__device__" "__device__ __host__" contents ${contents})
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

#remove examples, test, doc from build by patching CMakeLists.txt
set(path "CMakeLists.txt")
file(STRINGS ${path} contents NEWLINE_CONSUME)
string(REPLACE "add_subdirectory( examples )" "" contents ${contents})
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

file(STRINGS ${path} contents NEWLINE_CONSUME)
string(REPLACE "add_subdirectory( test )" "" contents ${contents})
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

file(STRINGS ${path} contents NEWLINE_CONSUME)
string(REPLACE "add_subdirectory( doc )" "" contents ${contents})
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)
