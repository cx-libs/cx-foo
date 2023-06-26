function(utils_add_lib ARG_TARGET ARG_TYPE)
  cmake_parse_arguments(ARG "" "SRC_DIR;INC_DIR;OUTPUT_NAME" "DEPS" ${ARGN})
  message(STATUS "==== util_add_lib ====")
  message(STATUS "TARGET      : ${ARG_TARGET}")
  message(STATUS "TYPE        : ${ARG_TYPE}")
  message(STATUS "SRC_DIR     : ${ARG_SRC_DIR}")
  message(STATUS "INC_DIR     : ${ARG_INC_DIR}")
  message(STATUS "DEPS        : ${ARG_DEPS}")
  message(STATUS "OUTPUT_NAME : ${ARG_OUTPUT_NAME}")

  file(GLOB_RECURSE files ${ARG_SRC_DIR}/*.cc ${ARG_SRC_DIR}/*.h)
  list(APPEND src_files ${files})

  add_library(${ARG_TARGET} ${ARG_TYPE} ${src_files})
  target_link_libraries(${ARG_TARGET} PRIVATE ${ARG_DEPS})
  target_include_directories(${ARG_TARGET} PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
    "$<BUILD_INTERFACE:${ARG_INC_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
  )
  if (ARG_OUTPUT_NAME)
    set_property(TARGET ${ARG_TARGET} PROPERTY OUTPUT_NAME ${ARG_OUTPUT_NAME})
  endif(ARG_OUTPUT_NAME)

  include(GenerateExportHeader)
  generate_export_header(${ARG_TARGET})
  message(STATUS "Done")
endfunction(utils_add_lib)


function(utils_add_exec ARG_TARGET)
  cmake_parse_arguments(ARG "" "SRC_DIR;OUTPUT_NAME" "DEPS" ${ARGN})
  message(STATUS "==== util_add_exec ====")
  message(STATUS "TARGET      : ${ARG_TARGET}")
  message(STATUS "SRC_DIR     : ${ARG_SRC_DIR}")
  message(STATUS "DEPS        : ${ARG_DEPS}")
  message(STATUS "OUTPUT_NAME : ${ARG_OUTPUT_NAME}")

  file(GLOB_RECURSE files ${ARG_SRC_DIR}/*.cc ${ARG_SRC_DIR}/*.h)
  list(APPEND src_files ${files})

  add_executable(${ARG_TARGET} ${src_files})
  target_link_libraries(${ARG_TARGET} PRIVATE ${ARG_DEPS})
  if (ARG_OUTPUT_NAME)
    set_property(TARGET ${ARG_TARGET} PROPERTY OUTPUT_NAME ${ARG_OUTPUT_NAME})
  endif(ARG_OUTPUT_NAME)

  message(STATUS "Done")
endfunction(utils_add_exec)


function(utils_install ARG_PACKAGE)
  cmake_parse_arguments(ARG "" "VERSION;CONFIG" "TARGETS" ${ARGN})
  message(STATUS "==== util_install ====")
  message(STATUS "PACKAGE : ${ARG_PACKAGE}")
  message(STATUS "VERSION : ${ARG_VERSION}")
  message(STATUS "CONFIG  : ${ARG_CONFIG}")
  message(STATUS "TARGETS : ${ARG_TARGETS}")

  install(TARGETS ${ARG_TARGETS} EXPORT ${ARG_PACKAGE}
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
          RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
  
  install(EXPORT ${ARG_PACKAGE} FILE ${ARG_PACKAGE}.cmake DESTINATION shared/${ARG_PACKAGE})

  include(CMakePackageConfigHelpers)
  configure_package_config_file(${ARG_CONFIG}
    "${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}Config.cmake"
    INSTALL_DESTINATION shared/${ARG_PACKAGE}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}ConfigVersion.cmake"
    VERSION "0.0.1"
    COMPATIBILITY AnyNewerVersion
  )

  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}ConfigVersion.cmake
    DESTINATION shared/${ARG_PACKAGE}
  )

  message(STATUS "Done")
endfunction(utils_install)