cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

IF(DEFINED CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ELSE()
	SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ENDIF()

project(moltalk)

# The version number.
set (VERSION_MAJOR 2)
set (VERSION_MINOR 0)

#set(CMAKE_C_COMPILER "/usr/local/bin/gcc48")
#set(CMAKE_CXX_COMPILER "/usr/local/bin/g++48")
#set(CMAKE_CXX_COMPILER "/usr/local/bin/clang36")

add_definitions( -DLinux )
#add_definitions( -DFreeBSD )
#add_definitions( -DWindows )

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fopenmp -g -O1")
# clang also wants its own stdlib
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -g -O0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O0 -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -g -fPIC")
set(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} -fPIC")

# boost
set(BOOST_ROOT "/opt/boost_1_61_0")
add_definitions( -DBOOST_ALL_DYN_LINK )
#set(Boost_ADDITIONAL_VERSIONS "1.49")
set(Boost_DEBUG OFF)
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_STATIC_RUNTIME ON)
set(Boost_USE_MULTITHREADED ON)
find_package( Boost 1.61.0 REQUIRED COMPONENTS system filesystem chrono thread date_time iostreams )
LINK_DIRECTORIES ( ${Boost_LIBRARY_DIRS} )
INCLUDE_DIRECTORIES (${Boost_INCLUDE_DIRS})


add_subdirectory( src )

# done.

