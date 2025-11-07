# =============================================
# CONFIGURAÇÃO DO PROJETO - EDITAR APÓS CLONAR
set(PROJECT_NAME "template-build")
set(PROJECT_VERSION "1.0.0")
set(PROJECT_DESCRIPTION "Template projeto em C++")
# =============================================

cmake_minimum_required(VERSION 3.10)
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# =============================================
# CONFIGURAÇÃO DE DETECÇÃO AUTOMÁTICA DE FONTES
# =============================================
option(USE_AUTO_SOURCE_DETECTION "Detectar arquivos fonte automaticamente" ON)

if(USE_AUTO_SOURCE_DETECTION)
    message(STATUS "Detectando arquivos fonte automaticamente...")
    file(GLOB_RECURSE DETECTED_SOURCES "src/*.cpp")
    
    if(DETECTED_SOURCES)
        set(SOURCES ${DETECTED_SOURCES})
        list(SORT SOURCES)  # Ordena os arquivos para consistência
        message(STATUS "Encontrados ${SOURCES} arquivos fonte:")
        foreach(source ${SOURCES})
            message(STATUS "  - ${source}")
        endforeach()
    else()
        message(WARNING "Detecção automática falhou, usando lista manual")
        set(SOURCES
            src/main.cpp
            src/io/utf8_config.cpp
        )
    endif()
else()
    message(STATUS "Usando lista manual de arquivos fonte")
    # Lista manual fallback
    set(SOURCES
        src/main.cpp
        src/io/utf8_config.cpp
    )
endif()

# =============================================
# CONFIGURAÇÕES DO COMPILADOR
# =============================================

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

# =============================================
# TARGET DO PROJETO
# =============================================
add_executable(${PROJECT_NAME} ${SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE includes)

# Forçar codificação UTF-8 no GCC / Clang
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${PROJECT_NAME} PRIVATE 
        "-finput-charset=UTF-8"
        "-fexec-charset=UTF-8" 
        "-fwide-exec-charset=UTF-8"
    )
endif()

# =============================================
# MENSAGENS INFORMATIVAS
# =============================================
message(STATUS "=========================================")
message(STATUS "Configurando projeto: ${PROJECT_NAME}")
message(STATUS "Descrição: ${PROJECT_DESCRIPTION}")
message(STATUS "Versão: ${PROJECT_VERSION}")
message(STATUS "Detecção automática: ${USE_AUTO_SOURCE_DETECTION}")
message(STATUS "Arquivos fonte: ${SOURCES}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "CXX Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "=========================================")

# =============================================
# PROPRIEDADES DO TARGET
# =============================================
set_target_properties(${PROJECT_NAME} PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)