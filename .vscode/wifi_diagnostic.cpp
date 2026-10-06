#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

std::string env(const char* name)
{
    const char* value = std::getenv(name);
    return value ? value : "";
}

void check(const std::string& name)
{
    const std::string value = env(name.c_str());

    if (value.empty())
        std::cout << "[MISSING] " << name << '\n';
    else
        std::cout << "[OK]      " << name << " = " << value << '\n';
}

int main()
{
    std::cout << "=== GitHub Actions / Google WIF diagnostic ===\n\n";

    const std::vector<std::string> variables = {
        "GITHUB_ACTIONS",
        "GITHUB_REPOSITORY",
        "GITHUB_REF",
        "GITHUB_REF_NAME",
        "GITHUB_WORKFLOW",
        "GITHUB_EVENT_NAME",
        "GITHUB_SHA",
        "GOOGLE_APPLICATION_CREDENTIALS",
        "GOOGLE_GHA_CREDS_PATH",
        "PROJECT_ID"
    };

    for (const auto& name : variables)
        check(name);

    std::cout << "\n=== RESULT ===\n";

    if (env("GITHUB_ACTIONS") != "true")
    {
        std::cout << "[WARN] Not running inside GitHub Actions.\n";
        return 2;
    }

    if (env("GITHUB_REPOSITORY").empty())
    {
        std::cout << "[FAIL] GITHUB_REPOSITORY is missing.\n";
        return 3;
    }

    if (env("GOOGLE_GHA_CREDS_PATH").empty() &&
        env("GOOGLE_APPLICATION_CREDENTIALS").empty())
    {
        std::cout << "[FAIL] Google credentials path is missing.\n";
        return 4;
    }

    std::cout << "[OK] GitHub Actions environment is detectable.\n";
    std::cout << "[INFO] WIF rejection must be fixed in Google Cloud's\n";
    std::cout << "       Workload Identity Provider attribute condition.\n";

    return 0;
}