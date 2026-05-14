cmake_minimum_required(VERSION 3.10)
project(slowcopy C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(slowcopy slowcopy.c)

install(TARGETS slowcopy DESTINATION bin)
