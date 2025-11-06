# =============================================
# CONFIGURAÇÃO DO PROJETO - EDITAR APÓS CLONAR
set(PROJECT_NAME "template-build")
# =============================================

cmake_minimum_required(VERSION 3.10)
project(${PROJECT_NAME})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configurações para suporte a UTF-8
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -Wall -finput-charset=UTF-8 -fexec-charset=UTF-8 -fwide-exec-charset=UTF-8")
elseif(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8 /source-charset:utf-8 /execution-charset:utf-8")
    add_compile_definitions(_UNICODE UNICODE _CRT_SECURE_NO_WARNINGS)
endif()

# Garantir consistência em versões mais novas do CMake
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.20)
    set(CMAKE_CXX_STANDARD_REQUIRED YES)
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()

set(SOURCES
    src/main.cpp
    src/io/utf8_config.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE includes)

# Forçar codificação UTF-8 no GCC / Clang
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${PROJECT_NAME} PRIVATE "-finput-charset=UTF-8")
    target_compile_options(${PROJECT_NAME} PRIVATE "-fexec-charset=UTF-8")
    target_compile_options(${PROJECT_NAME} PRIVATE "-fwide-exec-charset=UTF-8")
endif()

message(STATUS "Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "CXX Flags: ${CMAKE_CXX_FLAGS}")