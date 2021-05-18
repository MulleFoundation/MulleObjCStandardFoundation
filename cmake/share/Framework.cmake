### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# This in theory can be included multiple times

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# FRAMEWORKS do not support three-phase build
#
if( NOT FRAMEWORK_NAME)
   set( FRAMEWORK_NAME "${PROJECT_NAME}")
endif()
if( NOT FRAMEWORK_IDENTIFIER)
   string( MAKE_C_IDENTIFIER "${FRAMEWORK_NAME}" FRAMEWORK_IDENTIFIER)
endif()
if( NOT FRAMEWORK_UPCASE_IDENTIFIER)
   string( TOUPPER "${FRAMEWORK_IDENTIFIER}" FRAMEWORK_UPCASE_IDENTIFIER)
endif()
# if( NOT FRAMEWORK_DOWNCASE_IDENTIFIER)
#    string( TOLOWER "${FRAMEWORK_IDENTIFIER}" FRAMEWORK_DOWNCASE_IDENTIFIER)
# endif()

if( NOT FRAMEWORK_FILES)
   set( FRAMEWORK_FILES "${PROJECT_FILES}")
   set( __FRAMEWORK_FILES_UNSET ON)
endif()


include( PreFramework OPTIONAL)

if( NOT FRAMEWORK_FILES)
   message( FATAL_ERROR "There are no sources to compile for framework ${FRAMEWORK_NAME}. Did mulle-sde reflect run yet ?")
endif()

add_library( "${FRAMEWORK_NAME}" SHARED
   ${FRAMEWORK_FILES}
)

include( FrameworkAux OPTIONAL)

if( NOT FRAMEWORK_LIBRARY_LIST)
  set( FRAMEWORK_LIBRARY_LIST
    ${DEPENDENCY_LIBRARIES}
    ${DEPENDENCY_FRAMEWORKS}
    ${OPTIONAL_DEPENDENCY_LIBRARIES}
    ${OPTIONAL_DEPENDENCY_FRAMEWORKS}
    ${OS_SPECIFIC_LIBRARIES}
    ${OS_SPECIFIC_FRAMEWORKS}
  )
endif()

set( SHARED_LIBRARY_LIST ${FRAMEWORK_LIBRARY_LIST})

include( PostSharedLibrary OPTIONAL) # additional hook

target_link_libraries( "${FRAMEWORK_NAME}"
   ${SHARED_LIBRARY_LIST} # use SHARED_LIBRARY_LIST because of PostSharedLibrary
)


set_target_properties( "${FRAMEWORK_NAME}" PROPERTIES
  FRAMEWORK TRUE
  # FRAMEWORK_VERSION A
  # headers must be part of ${FRAMEWORK_NAME} target else it don't work
  PUBLIC_HEADER "${INSTALL_PUBLIC_HEADERS}"
  PRIVATE_HEADER "${INSTALL_PRIVATE_HEADERS}"
  RESOURCE "${INSTALL_RESOURCES}"
  # XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
)

message( STATUS "INSTALL_PUBLIC_HEADERS=${INSTALL_PUBLIC_HEADERS}")
message( STATUS "INSTALL_PRIVATE_HEADERS=${INSTALL_PRIVATE_HEADERS}")
message( STATUS "INSTALL_RESOURCES=${INSTALL_RESOURCES}")
message( STATUS "SHARED_LIBRARY_LIST=${SHARED_LIBRARY_LIST}")

set( INSTALL_FRAMEWORK_TARGETS
   "${FRAMEWORK_NAME}"
   ${INSTALL_FRAMEWORK_TARGETS}
)

include( PostFramework OPTIONAL)


# clean FRAMEWORK_FILES for the next run, if set by this script
if( __FRAMEWORK_FILES_UNSET )
   unset( FRAMEWORK_FILES)
   unset( __FRAMEWORK_FILES_UNSET)
endif()
