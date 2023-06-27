cmake_minimum_required(VERSION 3.10)
project("cxfoo" VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

find_package(grpc)

include(cmake/helper.cmake)
add_lib(cxfoo SHARED
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo
  INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo/include)

add_exec(cxfoo_cli OUTPUT_NAME cxfoo
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo_cli
  DEPS    cxfoo)

add_install(${PROJECT_NAME} 
  VERSION ${PROJECT_VERSION}
  CONFIG  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in
  TARGETS cxfoo cxfoo_cli)
