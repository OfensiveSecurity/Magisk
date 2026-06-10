# MAL: No hagas esto, esto busca en el sistema roto
# link_directories(/usr/lib/x86_64-linux-gnu)

# BIEN: Deja que CMake use las rutas del NDK automáticamente
find_library(log-lib log)
target_link_libraries(magisk-native ${log-lib})
