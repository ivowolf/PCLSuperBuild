# Called by External-FLANN.cmake (ExternalProject_Add) as a patch for FLANN-1.8.4.

# read whole file
set(path "src/cpp/flann/util/serialization.h")
file(STRINGS ${path} contents NEWLINE_CONSUME)

# Add the stdlib.h include
string(REPLACE "(int);" "(int);\n#if _WIN64 || _M_X64\n  BASIC_TYPE_SERIALIZER(__int64);\n  BASIC_TYPE_SERIALIZER(unsigned __int64);\n#endif" contents ${contents})

# set variable CONTENTS, which is substituted in TEMPLATE_FILE
set(CONTENTS ${contents})
configure_file(${TEMPLATE_FILE} ${path} @ONLY)

