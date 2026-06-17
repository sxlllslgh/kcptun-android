cmake_minimum_required(VERSION 4.3)

project(ShimakazeAndroid LANGUAGES C CXX)

set(BUILD_TESTING OFF CACHE BOOL "Disable tests for Android packaging" FORCE)

add_subdirectory(
    "${CMAKE_CURRENT_LIST_DIR}/shimakaze/shimakaze"
    "${CMAKE_CURRENT_BINARY_DIR}/shimakaze"
)

if(TARGET cryptopp)
    target_include_directories(cryptopp
        PRIVATE
            "${CMAKE_CURRENT_LIST_DIR}/android-compat"
    )
    target_compile_definitions(cryptopp
        PUBLIC
            CRYPTOPP_DISABLE_ANDROID_ADVANCED_ISA=1
    )
endif()

add_executable(shimakaze_android_client android_client_main.cpp)
target_link_libraries(shimakaze_android_client PRIVATE shimakaze_core)
target_compile_features(shimakaze_android_client PRIVATE cxx_std_23)
set_target_properties(shimakaze_android_client PROPERTIES OUTPUT_NAME shimakaze)
