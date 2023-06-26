function(utils_add_lib)
  cmake_parse_arguments(ARGS "" "TARGET;TYPE;OUTPUT_NAME;SRC_DIR;INC_DIR" "DEPS" ${ARGN})
  message(STATUS "==== util_add_lib  ====")
  message(STATUS "TARGET        : ${ARGS_TARGET}")
  message(STATUS "TYPE          : ${ARGS_TYPE}")
  message(STATUS "ARGS_SRC_DIR  : ${ARGS_SRC_DIR}")
  message(STATUS "ARGS_INC_DIR  : ${ARGS_INC_DIR}")
  message(STATUS "ARGS_DEPS     : ${ARGS_DEPS}")
  message(STATUS "OUTPUT_NAME   : ${ARGS_OUTPUT_NAME}")

  file(GLOB_RECURSE files ${ARGS_SRC_DIR}/*.cc ${ARGS_SRC_DIR}/*.h)
  list(APPEND src_files ${files})

  add_library(${ARGS_TARGET} ${ARGS_TYPE} ${src_files})
  target_link_libraries(${ARGS_TARGET} PRIVATE ${ARGS_DEPS})
  target_include_directories(${ARGS_TARGET} PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
    "$<BUILD_INTERFACE:${ARGS_INC_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
  )
  if (ARGS_OUTPUT_NAME)
    set_property(TARGET ${ARGS_TARGET} PROPERTY OUTPUT_NAME ${ARGS_OUTPUT_NAME})
  endif(ARGS_OUTPUT_NAME)

  include(GenerateExportHeader)
  generate_export_header(${ARGS_TARGET})

  message(STATUS "Done")
endfunction(utils_add_lib)


function(utils_add_exec)
  cmake_parse_arguments(ARGS "" "TARGET;OUTPUT_NAME;SRC_DIR" "DEPS" ${ARGN})
  message(STATUS "==== util_add_exec  ====")
  message(STATUS "TARGET        : ${ARGS_TARGET}")
  message(STATUS "TYPE          : ${ARGS_TYPE}")
  message(STATUS "ARGS_SRC_DIR  : ${ARGS_SRC_DIR}")
  message(STATUS "ARGS_DEPS     : ${ARGS_DEPS}")
  message(STATUS "OUTPUT_NAME   : ${ARGS_OUTPUT_NAME}")

  file(GLOB_RECURSE files ${ARGS_SRC_DIR}/*.cc ${ARGS_SRC_DIR}/*.h)
  list(APPEND src_files ${files})

  add_executable(${ARGS_TARGET} ${src_files})
  target_link_libraries(${ARGS_TARGET} PRIVATE ${ARGS_DEPS})
  if (ARGS_OUTPUT_NAME)
    set_property(TARGET ${ARGS_TARGET} PROPERTY OUTPUT_NAME ${ARGS_OUTPUT_NAME})
  endif(ARGS_OUTPUT_NAME)

  message(STATUS "Done")
endfunction(utils_add_exec)


function(utils_install)
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

  message(STATUS "Done")
endfunction(utils_install)