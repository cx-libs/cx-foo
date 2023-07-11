cmake_minimum_required(VERSION 3.10)
project("cx-foo" VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

find_package(gRPC REQUIRED)

include(cmake/helper.cmake)
add_lib(cx_foo SHARED
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo
  INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo/include)

add_exec(cx_foo_client 
  OUTPUT_NAME cx_foo
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cx_foo_client
  DEPS    cx_foo gRPC::grpc++)

enable_testing()
add_tests(cx_foo_tests
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests
  DEPS    cx_foo)

add_install(${PROJECT_NAME}
  TARGETS cx_foo cx_foo_client
  VERSION ${PROJECT_VERSION}
  CONFIG  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in
)

