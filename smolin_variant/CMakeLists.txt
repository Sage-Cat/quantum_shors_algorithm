cmake_minimum_required(VERSION 3.15)
project(SmolinVariant)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Boost REQUIRED COMPONENTS)

include_directories(${Boost_INCLUDE_DIRS})

add_executable(SmolinVariant main.cpp SmolinVariant.cpp)

target_link_libraries(SmolinVariant ${Boost_LIBRARIES})
