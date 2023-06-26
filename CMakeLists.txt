cmake_minimum_required(VERSION 3.10)
project("cxfoo" VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

include(cmake/utils.cmake)

utils_add_lib(TARGET cxfoo 
  TYPE SHARED
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo
  INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo)

utils_add_exec(TARGET cxfoo_cli 
  OUTPUT_NAME cxfoo
  SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/cxfoo_cli
  DEPS cxfoo)

utils_install(PACKAGE cxfoo
  VERSION ${PROJECT_VERSION}
  CONFIG ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.cmake.in
  TARGETS cxfoo cxfoo_cli)
