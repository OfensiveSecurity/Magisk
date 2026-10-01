jobs:

  platform-diagnostic:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - name: Platform
        run: |
          set -eux
          echo "=== RUNNER ==="
          uname -a
          uname -m

          echo "=== CPU ==="
          lscpu

          echo "=== MEMORY ==="
          free -h

          echo "=== STORAGE ==="
          df -h

          echo "=== COMPILERS ==="
          clang++ --version
          g++ --version

          echo "=== TARGET ==="
          echo "Android API: 35"
          echo "ABI: arm64-v8a"

  cpp-build:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - name: Build can_reader
        run: |
          set -eux

          if [ -f can_reader.cpp ]; then
            mkdir -p build

            g++ \
              -std=c++17 \
              -O2 \
              -Wall \
              -Wextra \
              -Wpedantic \
              can_reader.cpp \
              -o build/can_reader

            file build/can_reader
          else
            echo "can_reader.cpp no existe"
          fi

  network-lab:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - name: Install CAN tools
        run: |
          sudo apt-get update
          sudo apt-get install -y can-utils iproute2

      - name: Virtual CAN
        run: |
          set -eux

          sudo modprobe vcan
          sudo ip link add vcan0 type vcan
          sudo ip link set vcan0 up

          ip -details link show vcan0

      - name: CAN loopback
        run: |
          set -eux

          timeout 5s candump -L vcan0 > can.log 2>&1 &
          PID=$!

          sleep 1

          cansend vcan0 123#11223344
          cansend vcan0 456#AABBCCDD

          sleep 1

          kill "$PID" 2>/dev/null || true

          cat can.log