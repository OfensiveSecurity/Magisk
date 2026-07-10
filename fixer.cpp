#include <git2.h>
#include <iostream>

void verificar_soporte_git() {
    int features = git_libgit2_features();
    
    if (features & GIT_FEATURE_HTTPS) {
        std::cout << "[ OK ] Soporte HTTPS disponible.\n";
    } else {
        std::cout << "[ ERROR ] libgit2 NO tiene soporte HTTPS compilado.\n";
    }
    
    if (features & GIT_FEATURE_SSH) {
        std::cout << "[ OK ] Soporte SSH disponible.\n";
    }
}

