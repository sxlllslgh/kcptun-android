cmake_minimum_required(VERSION 4.3)

project(KcptunAndroid LANGUAGES C CXX)

set(BUILD_TESTING OFF CACHE BOOL "Disable tests for Android packaging" FORCE)

add_subdirectory(
    "${CMAKE_CURRENT_LIST_DIR}/kcptun/shimakaze"
    "${CMAKE_CURRENT_BINARY_DIR}/shimakaze"
)

add_executable(kcptun_android_client android_client_main.cpp)
target_link_libraries(kcptun_android_client PRIVATE shimakaze_core)
target_compile_features(kcptun_android_client PRIVATE cxx_std_23)
set_target_properties(kcptun_android_client PROPERTIES OUTPUT_NAME kcptun)
