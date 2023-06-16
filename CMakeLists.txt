cmake_minimum_required(VERSION 3.10)
project("cx-foo")

set(CMAKE_CXX_STANDARD 17)


file(GLOB_RECURSE src_list src/cx_foo/*.cc src/cx_foo/*.h)
add_library(cx_foo ${src_list})
target_include_directories(cx_foo PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
install(TARGETS cx_foo DESTINATION lib)

file(GLOB_RECURSE src_list src/cx_queue/*.cc src/cx_queue/*.h)
add_library(cx_queue ${src_list})
target_include_directories(cx_queue PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
install(TARGETS cx_queue DESTINATION lib)


file(GLOB_RECURSE src_list src/cx_foo_exe/*.cc src/cx_foo_exe/*.h)
add_executable(cx_foo_exe ${src_list})
set_target_properties(cx_foo_exe PROPERTIES OUTPUT_NAME cx_foo)
target_link_directories(cx_foo_exe PRIVATE cx_queue)
install(TARGETS cx_foo_exe DESTINATION bin)
