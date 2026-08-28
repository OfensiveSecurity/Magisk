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
SetThreadIdealProcessor(GetCurrentThread(), preferredCoreIndex);
// or hard-pin with an affinity mask:
SetThreadAffinityMask(GetCurrentThread(), fastCoreMask);
SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_TIME_CRITICAL);

// Windows 11 22H2+ has explicit hints for hybrid CPUs:
THREAD_POWER_THROTTLING_STATE state = {};
state.Version = THREAD_POWER_THROTTLING_CURRENT_VERSION;
state.ControlMask = THREAD_POWER_THROTTLING_EXECUTION_SPEED;
state.StateMask = 0; // 0 = don't throttle, run at full speed
SetThreadInformation(GetCurrentThread(), ThreadPowerThrottling, &state, sizeof(state));
ULONG fastCores[] = { 0, 2, 4, 6 }; // example P-core indices
SetThreadSelectedCpuSets(hThread, fastCores, ARRAYSIZE(fastCores));