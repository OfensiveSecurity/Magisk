#!/bin/bash
mkdir actions-runner && cd actions-runner
# Download the latest runner package
clang++ -O2 resilient_fetch.cpp -lcurl -o resilient_fetch
./resilient_fetch
clang++ -O2 -pthread gateway_scanner.cpp -o gateway_scanner
./gateway_scanner
curl -O -L https://github.com/actions/runner/releases/download/v2.328.0/actio>
# Extract the installer
tar xzf ./actions-runner-linux-arm64-2.328.0.tar.gz
ifconfig wlan0 | grep 'inet '
scp -P 8022 u0_a254@192.168.100.1:~/.ssh/id_nexus ~/.ssh/id_nexus
vncserver
echo anonima33ok
DISPLAY=:2 startxfce4 &
