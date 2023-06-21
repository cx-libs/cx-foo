function(util_add_lib target)
  cmake_parse_arguments(ARGS "" "" "SRC_DIRS;DEPS" ${ARGN})
  message(STATUS "==== util_add_lib ${target} ====")
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

  
endfunction(util_add_lib)


function(util_add_exec target)
  cmake_parse_arguments(ARGS "" "" "SRC_DIRS;DEPS" ${ARGN})
  message(STATUS "==== util_add_exec ${target} ====")
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


function(util_install)
  cmake_parse_arguments(ARGS "" "PACKAGE" "TARGETS" ${ARGN})
  message(STATUS "==== util_install ${ARGS_PACKAGE} ====")
  message(STATUS "ARGS_PACKAGE : ${ARGS_PACKAGE}")
  message(STATUS "ARGS_TARGETS : ${ARGS_TARGETS}")

  install(TARGETS ${ARGS_TARGETS} EXPORT ${ARGS_PACKAGE}
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
          RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
  
  install(EXPORT ${ARGS_PACKAGE} FILE ${ARGS_PACKAGE}.cmake DESTINATION shared/${ARGS_PACKAGE})

  include(CMakePackageConfigHelpers)
  configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${ARGS_PACKAGE}Config.cmake"
    INSTALL_DESTINATION shared/${ARGS_PACKAGE}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${ARGS_PACKAGE}ConfigVersion.cmake"
    VERSION "0.0.1"
    COMPATIBILITY AnyNewerVersion
  )

  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${ARGS_PACKAGE}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${ARGS_PACKAGE}ConfigVersion.cmake
    DESTINATION shared/${ARGS_PACKAGE}
  )

endfunction(util_install)