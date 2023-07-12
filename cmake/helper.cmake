macro(find_pkg pack_name)
  message(STATUS "==== find_pkg ====")
  find_package(${pack_name} CONFIG REQUIRED)
  message(STATUS "prefix path   : ${CMAKE_PREFIX_PATH}")
  message(STATUS "include dirs  : ${${pack_name}_INCLUDE_DIRS}")
  message(STATUS "libs          : ${${pack_name}_LIBS}")
  message(STATUS "config        : ${${pack_name}_DIR}")
  message(STATUS "version       : ${${pack_name}_VERSION}")
endmacro()

function(add_lib ARG_TARGET ARG_TYPE)
  cmake_parse_arguments(ARG "" "SRC_DIR;INC_DIR;OUTPUT_NAME" "DEPS" ${ARGN})
  message(STATUS "==== add_lib ====")
  message(STATUS "TARGET      : ${ARG_TARGET}")
  message(STATUS "TYPE        : ${ARG_TYPE}")
  message(STATUS "SRC_DIR     : ${ARG_SRC_DIR}")
  message(STATUS "INC_DIR     : ${ARG_INC_DIR}")
  message(STATUS "DEPS        : ${ARG_DEPS}")
  message(STATUS "OUTPUT_NAME : ${ARG_OUTPUT_NAME}")

  # Add lib
  file(GLOB_RECURSE src_files ${ARG_SRC_DIR}/*.cc ${ARG_SRC_DIR}/*.cpp ${ARG_SRC_DIR}/*.c)
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

  # Generate export header
  include(GenerateExportHeader)
  generate_export_header(${ARG_TARGET})

  # Set headers set for install
  file(GLOB_RECURSE inc_files ${ARG_INC_DIR}/*.h ${ARG_SRC_DIR}/*.hpp)
  target_sources(${ARG_TARGET} PUBLIC FILE_SET HEADERS
    BASE_DIRS ${ARG_INC_DIR}
    FILES ${inc_files})
  
  message(STATUS "Done")
endfunction(add_lib)


function(add_exec ARG_TARGET)
  cmake_parse_arguments(ARG "" "SRC_DIR;OUTPUT_NAME" "DEPS" ${ARGN})
  message(STATUS "==== add_exec ====")
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
endfunction(add_exec)


function(add_install ARG_PACKAGE)
cmake_parse_arguments(ARG "" "VERSION;CONFIG" "TARGETS" ${ARGN})
  message(STATUS "==== add_install ====")
  message(STATUS "PACKAGE : ${ARG_PACKAGE}")
  message(STATUS "VERSION : ${ARG_VERSION}")
  message(STATUS "CONFIG  : ${ARG_CONFIG}")
  message(STATUS "TARGETS : ${ARG_TARGETS}")

  # Export targets
  include(GNUInstallDirs)
  install(TARGETS ${ARG_TARGETS} EXPORT ${ARG_PACKAGE}
          FILE_SET HEADERS
          LIBRARY DESTINATION   "$<$<CONFIG:Debug>:debug/>${CMAKE_INSTALL_LIBDIR}"
          ARCHIVE DESTINATION   "$<$<CONFIG:Debug>:debug/>${CMAKE_INSTALL_LIBDIR}"
          RUNTIME DESTINATION   "$<$<CONFIG:Debug>:debug/>${CMAKE_INSTALL_BINDIR}"
          INCLUDES DESTINATION  "${CMAKE_INSTALL_INCLUDEDIR}")

  install(EXPORT ${ARG_PACKAGE}
          FILE        "${ARG_PACKAGE}Targets.cmake"
          DESTINATION "${CMAKE_INSTALL_DATADIR}/${ARG_PACKAGE}")

  # Export config
  include(CMakePackageConfigHelpers)
  configure_package_config_file(${ARG_CONFIG} "${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}Config.cmake"
                                INSTALL_DESTINATION  "${CMAKE_INSTALL_DATADIR}/${ARG_PACKAGE}"
                                NO_SET_AND_CHECK_MACRO
                                NO_CHECK_REQUIRED_COMPONENTS_MACRO)

  write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}ConfigVersion.cmake"
                                   VERSION ${ARG_VERSION}
                                   COMPATIBILITY AnyNewerVersion)

  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${ARG_PACKAGE}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_DATADIR}/${ARG_PACKAGE}
  )

  message(STATUS "Done")
endfunction(add_install)

function(add_tests ARG_TARGET)
  cmake_parse_arguments(ARG "" "SRC_DIR" "DEPS" ${ARGN})
  message(STATUS "==== add_tests ====")
  message(STATUS "TARGET      : ${ARG_TARGET}")
  message(STATUS "SRC_DIR     : ${ARG_SRC_DIR}")
  message(STATUS "DEPS        : ${ARG_DEPS}")

  file(GLOB_RECURSE src_files ${ARG_SRC_DIR}/*.cc ${ARG_SRC_DIR}/*.cpp ${ARG_SRC_DIR}/*.c)
  set(src_names)
  foreach (src_file ${src_files})
    get_filename_component(src_name ${src_file} NAME)
    list(APPEND src_names ${src_name})
  endforeach()

  create_test_sourcelist (test_src_files ${ARG_TARGET}.cc ${src_names})
  add_executable(${ARG_TARGET}  ${ARG_TARGET}.cc ${src_files})
  target_link_libraries(${ARG_TARGET} PRIVATE ${ARG_DEPS})

  foreach (src_name ${src_names})
    get_filename_component(test_name ${src_name} NAME_WE)
    message(STATUS "${ARG_TARGET} ${test_name}")
    add_test (NAME ${test_name} COMMAND ${ARG_TARGET} ${test_name})
  endforeach ()
endfunction(add_tests)