cmake_minimum_required(VERSION 3.10)
project(day_03 CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_GLIBCXX_DEBUG")

set(SOURCE_EX00
		ex00/main.cpp
)

set(SOURCE_EX01
		ex01/main.cpp
)

add_executable(ex00 ${SOURCE_EX00})
add_executable(ex01 ${SOURCE_EX01})
