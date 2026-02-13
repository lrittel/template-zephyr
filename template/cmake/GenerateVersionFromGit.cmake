find_package(Git)

if(Git_FOUND)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags --dirty --match "v*"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
    RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(NOT GIT_DESCRIBE_ERROR_CODE)
    set(APPLICATION_VERSION ${GIT_DESCRIBE_VERSION})
  else()
    message(WARNING "Unable to determine version from git, using an invalid version string")
  endif()
else()
  message(WARNING "Git not found, using an invalid version string")
endif()

# Set the fallback version to something that will not appear to be more recent than the actual version.
if(NOT DEFINED APPLICATION_VERSION)
  set(APPLICATION_VERSION v0.0.0-unknown)
endif()

message(STATUS "Application version: ${APPLICATION_VERSION}")
return(PROPAGATE APPLICATION_VERSION)
