function(util_add_lib target)
  cmake_parse_arguments(ARGS "" "" "SRC_DIRS;DEPS" ${ARGN})
  message(STATUS "util_add_lib ${target}")
  message(STATUS "ARGS_SRC_DIRS : ${ARGS_SRC_DIRS}")
  message(STATUS "ARGS_DEPS : ${ARGS_DEPS}")

  foreach(var ${ARGS_SRC_DIRS})
    file(GLOB_RECURSE files ${var}/*.cc ${var}/*.h)
    list(APPEND src_files ${files})
  endforeach()
  
  add_library(${target} ${src_files})
  target_link_libraries(${target} PRIVATE ${ARGS_DEPS})
  target_include_directories(${target} PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>" 
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
  )

  install(TARGETS ${target} EXPORT ${target}Targets
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
          RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
endfunction(util_add_lib)

function(util_add_exec target)
  cmake_parse_arguments(ARGS "" "" "SRC_DIRS;DEPS" ${ARGN})
  message(STATUS "util_add_exec ${target}")
  message(STATUS "ARGS_SRC_DIRS : ${ARGS_SRC_DIRS}")
  message(STATUS "ARGS_DEPS : ${ARGS_DEPS}")

  foreach(var ${ARGS_SRC_DIRS})
    file(GLOB_RECURSE files ${var}/*.cc ${var}/*.h)
    list(APPEND src_files ${files})
  endforeach()

  add_executable(${target} ${src_files})
  target_link_libraries(${target} PRIVATE ${ARGS_DEPS})
 
  # install(TARGETS ${exec_name} EXPORT ${exec_name}Targets
  #         LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #         ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  #         RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  #         INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  # )
endfunction(util_add_exec)
