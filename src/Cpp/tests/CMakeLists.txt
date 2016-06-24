
cmake_minimum_required(VERSION 2.8)

project(UT_libmoltalk)

IF(DEFINED CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ELSE()
   SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ENDIF()

# boost
#set(Boost_ADDITIONAL_VERSIONS "1.49")
set(Boost_DEBUG OFF)
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_USE_MULTITHREADED ON)
find_package( Boost 1.48.0 REQUIRED COMPONENTS system thread date_time chrono unit_test_framework)
include_directories(${Boost_INCLUDE_DIRS})

# mine
include_directories(..)

file(GLOB SRCS ut*.cpp mocks/*.cpp)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")

        add_executable ( ${PROJECT_NAME}
          ${SRCS}
        )

target_link_libraries ( ${PROJECT_NAME}
          moltalk_${CMAKE_BUILD_TYPE}
          ${Boost_LIBRARIES}
        )
endif()

if (CMAKE_BUILD_TYPE STREQUAL "DebugProfile")
        add_executable ( p${PROJECT_NAME}
                ${SRCS}
        )
        set_target_properties(p${PROJECT_NAME} PROPERTIES LINK_FLAGS "-fprofile-arcs -ftest-coverage ")
        target_link_libraries ( p${PROJECT_NAME}
                moltalk_p${CMAKE_BUILD_TYPE}
                #${libs}
                #gcov
                ${Boost_LIBRARIES}
        )

endif()


