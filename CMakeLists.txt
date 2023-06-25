cmake_minimum_required(VERSION 3.10)
project("cx-foo" VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

include(cmake/utils.cmake)
utils_add_lib(cx_foo SHARED
  SRC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo
  INC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo/include)

utils_add_exec(cx_foo_client
  SRC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo_client
  DEPS cx_foo)

utils_install(TARGETS cx_foo cx_foo_client
  EXPORT cx_foo
  VERSION ${PROJECT_VERSION}
  CONFIG ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in)
