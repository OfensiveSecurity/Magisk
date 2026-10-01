#include <iostream>
#include <cstring>
#include <unistd.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/can.h>
#include <linux/can/raw.h>

int main() {
    const char *ifname = "can0";

    int fd = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (fd < 0) {
        perror("socket");
        return 1;
    }

    struct ifreq ifr{};
    std::strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);

    if (ioctl(fd, SIOCGIFINDEX, &ifr) < 0) {
        perror("SIOCGIFINDEX");
        close(fd);
        return 2;
    }

    struct sockaddr_can addr{};
    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    if (bind(fd, reinterpret_cast<struct sockaddr*>(&addr),
             sizeof(addr)) < 0) {
        perror("bind");
        close(fd);
        return 3;
    }

    std::cout << "Escuchando " << ifname << "...\n";

    while (true) {
        struct can_frame frame{};

        ssize_t n = read(fd, &frame, sizeof(frame));

        if (n == sizeof(frame)) {
            std::cout << "ID=0x"
                      << std::hex << frame.can_id
                      << " DLC=" << std::dec
                      << static_cast<int>(frame.can_dlc)
                      << " DATA=";

            for (int i = 0; i < frame.can_dlc; ++i)
                printf("%02X ", frame.data[i]);

            std::cout << '\n';
        }
    }

    close(fd);
    return 0;
}