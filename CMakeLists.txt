cmake_minimum_required(VERSION 3.10)
project("cx-foo")

include(tools/util.cmake)

set(CMAKE_CXX_STANDARD 17)

util_add_lib(cx_foo SRC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo)
util_add_exec(cx_foo_client SRC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo_client DEPS cx_foo)
