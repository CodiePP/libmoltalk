cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

IF(DEFINED CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ELSE()
	SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ENDIF()

#project(moltalk)

# The version number.
#set (VERSION_MAJOR 2)
#set (VERSION_MINOR 0)

#set(CMAKE_C_COMPILER "/usr/local/bin/gcc48")
#set(CMAKE_CXX_COMPILER "/usr/local/bin/g++48")
#set(CMAKE_CXX_COMPILER "/usr/local/bin/clang36")

add_definitions( -DLinux )
#add_definitions( -DFreeBSD )
#add_definitions( -DWindows )

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fopenmp -g -O1")
# clang also wants its own stdlib
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -g -O0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O0 -Wno-deprecated -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -g -fPIC")
#set(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} -fopenmp")

# boost
#set(BOOST_ROOT "/usr/local/boost_1_57_0")
#add_definitions( -DBOOST_ALL_DYN_LINK )
#set(Boost_ADDITIONAL_VERSIONS "1.49")
#set(Boost_DEBUG OFF)
#set(Boost_USE_STATIC_LIBS OFF)
#set(Boost_USE_STATIC_RUNTIME OFF)
#set(Boost_USE_MULTITHREADED ON)
#find_package( Boost 1.55.0 REQUIRED COMPONENTS system filesystem chrono thread date_time iostreams )
#LINK_DIRECTORIES ( ${Boost_LIBRARY_DIRS} )
#INCLUDE_DIRECTORIES (${Boost_INCLUDE_DIRS})

# mine
include_directories(".")

# link external libraries
set(libs "dl" "z")
#set(libs "z")

# list of source files to be compiled
file(GLOB SRCS *.cpp)

add_library (${PROJECT_NAME}_${CMAKE_BUILD_TYPE} SHARED
	${SRCS}
)

add_library (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}_s STATIC
	${SRCS}
)

if (CMAKE_BUILD_TYPE STREQUAL "DebugProfile")
	add_library (${PROJECT_NAME}_p${CMAKE_BUILD_TYPE} STATIC
		${SRCS}
	)
	set_target_properties(${PROJECT_NAME}_p${CMAKE_BUILD_TYPE} PROPERTIES COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
	#set(libs, "${libs} gcov")
	target_link_libraries (${PROJECT_NAME}_p${CMAKE_BUILD_TYPE}
		${libs}
		${Boost_LIBRARIES}
	)
endif()


target_link_libraries (${PROJECT_NAME}_${CMAKE_BUILD_TYPE} PUBLIC
	${libs}
	${Boost_LIBRARIES}
)

target_link_libraries (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}_s
	${libs}
	${Boost_LIBRARIES}
)

add_subdirectory( tests )

# done.

