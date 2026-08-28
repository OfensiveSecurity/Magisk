#include <windows.h>
#include <vector>

// 1. Enumerate CPU sets and find which ones are "preferred" (P-cores)
ULONG count = 0;
GetSystemCpuSetInformation(nullptr, 0, &count, GetCurrentProcess(), 0);
std::vector<BYTE> buffer(count);
auto* info = reinterpret_cast<PSYSTEM_CPU_SET_INFORMATION>(buffer.data());
GetSystemCpuSetInformation(info, count, &count, GetCurrentProcess(), 0);

// Walk the array; each entry has EfficiencyClass and SchedulingClass
// Higher EfficiencyClass = faster core (P-core on hybrid Intel)