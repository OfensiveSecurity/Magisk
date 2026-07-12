#!/bin/bash
# Opción 1: Desde Developer Command Prompt
cl nfc_reader.cpp /link winscard.lib

# Opción 2: Con proyecto CMake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(NFCApp)

set(CMAKE_CXX_STANDARD 17)

add_executable(nfc_app nfc_reader.cpp)
target_link_libraries(nfc_app PRIVATE winscard.lib)
pkg install clang cmake ninja
clang++ -std=c++20 oreo.cpp -o oreo
sudo apt update
sudo apt install build-essential cmake
g++ -std=c++20 oreo.cpp -o oreo