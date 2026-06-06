#!/usr/bin/env python3
import argparse
import ctypes
import functools
import glob
import os
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import urllib.request
import QtQuick
import Quickshell
# Configuración de la prueba
url = "http://127.0.0"
peticiones_totales = "100"
concurrencia = "10"
archivo_json = "datos_prueba.json"  # Tu archivo con el payload para TF Serving
"
PUERTOS = [22, 80, 443, 8099, 49152]
TIMEOUT = 2.0  # Tiempo máximo de espera en segundos
print(f"Iniciando diagnóstico de conectividad para: {HOST}\n")
for puerto in PUERTOS:
    # Se crea un socket TCP (AF_INET para IPv4, SOCK_STREAM para TCP)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(TIMEOUT)
    
    try:
        # Se intenta la conexión de tres vías (Handshake TCP)
        resultado = sock.connect_ex((HOST, puerto))
        
        if resultado == 0:
            print(f"[+] Puerto {puerto}: ABIERTO (El servicio responde)")
        else:
            print(f"[-] Puerto {puerto}: CERRADO o FILTRADO (Código de error: {resultado})")
            
    except socket.error as e:
        print(f"[!] Error al conectar al puerto {puerto}: {e}")
        
    finally:
        # Es indispensable cerrar el socket en cada iteración
        sock.close()

print("\nDiagnóstico finalizado.")


# Construcción del comando tal como lo espera el sistema
comando = [
    "ab",
    "-n", peticiones_totales,
    "-c", concurrencia,
    "-p", archivo_json,
    "-T", "application/json",
    url
]

try:
    # Ejecuta el comando y captura la salida
    resultado = subprocess.run(comando, capture_output=True, text=True, check=True)
    print("Prueba completada con éxito:\n")
    print(resultado.stdout)
except subprocess.CalledProcessError as e:
    print("Error al ejecutar ApacheBench:\n")
    print(e.stderr)
from pathlib import Path
from zipfile import ZipFile

### Explanation:

The code defines a function `is_palindrome` to check if a word is a palindrome.  The provided unit tests (in the `TestPalindrome` class) use the `unittest` framework to thoroughly test the function.

1. **`unittest` Framework:** The code uses the `unittest` framework, a standard Python library, for creating and running tests. This allows for organized and reusable test cases.

2. **`TestPalindrome` Class:**  This class inherits from `unittest.TestCase`.  This is the container for our test methods.

3. **Test Methods:** Each test method (e.g., `test_palindrome_case_insensitive`) starts with `test_` and calls assertion methods like `assertTrue` or `assertFalse`. These methods check the return value of `is_palindrome` against expected outcomes.

4. **Comprehensive Test Cases:** The test cases cover various scenarios:
   - **Case Insensitivity:** `test_palindrome_case_insensitive` ensures the function handles mixed-case inputs correctly.
   - **Punctuation:** `test_palindrome_with_punctuation` demonstrates the function ignores punctuation.
   - **Simple Non-Palindrome:** `test_not_palindrome` verifies the function recognizes non-palindromes.
   - **Empty and Single-Character Strings:** `test_empty_string` and `test_single_character`  handle edge cases.
   - **Numbers:** `test_palindrome_with_numbers` verifies number palindromes.
   - **Mixed Case/Numbers/Special Characters:** `test_mixed_case_and_numbers`, `test_palindrome_with_special_characters` handle more complex cases.
   - **Longer Strings:** `test_long_palindrome` tests with a longer string.
   - **Non-Palindrome with spaces:** `test_not_palindrome_with_spaces` verifies the function correctly handles spaces.


5. **`if __name__ == '__main__':` block:** This is crucial. It ensures that the test cases run only when the script is executed directly (not when imported as a module).

6. **`unittest.main(...)`:** This line runs all the test methods defined in the `TestPalindrome` class.  `argv=['first-arg-is-ignored'], exit=False` are important arguments.  The `exit=False` ensures that the program does not terminate after the tests are run, enabling you to examine the output more easily.  The `argv` argument is a standard way to pass arguments to `unittest`.  This argument doesn't affect the output or execution of the test, but is good practice.

This complete approach ensures the code works as expected in a variety of situations, preventing potential bugs.  The output of the tests shows whether each assertion was successful, providing clear feedback on the status of the `is_palindrome` function. Remember to run the script to see the test results. Using `unittest` is a best practice for testing any Python code as it provides a clear and structured way to write and run test cases.
User: whoami

# Temporary placeholder imports/variables for structural validity
# In a true deployment, these mirror 'scripts.env' definitions.
is_windows = sys.platform == "win32"
EXE_EXT = ".exe" if is_windows else ""
cpu_count = os.cpu_count() or 1
ondk_version = "26.1"  # Example version string

class PathsDummy:
    def __init__(self):
        self.ndk_build = Path("ndk-build")
        self.gradlew = Path("./gradlew")
        self.ndk = Path("ndk")
        self.adb = Path("adb")

def paths():
    return PathsDummy()

def error(msg: str):
    print(f"[-] Error: {msg}", file=sys.stderr)
    sys.exit(1)

def header(msg: str):
    print(f"\n=== {msg} ===")


def ensure_cargo():
    if not shutil.which("cargo"):
        error("Cargo/Rust package manager not found.")

def ensure_toolchain():
    pass
ShellRoot {
    Variants {
        id: demoShell
    }
}
def ensure_jdk():
    if not shutil.which("javac"):
        error("Java Development Kit (JDK) not found.")
def funcion_relacion_ogt_hdi(ogt_value, factor_conversion=1.44):
    """
    Calcula el valor resultante de HDI basándose en el indicador OGT.
    """
    if ogt_value < 0:
        return "Error: El valor de OGT no puede ser negativo."
    
    # Aplica un modelo de función matemática hipotética
    hdi_resultado = ogt_value * factor_conversion
    return round(hdi_resultado, 2)

# Ejemplo de prueba de la función
valor_ogt = 45.5
resultado_hdi = funcion_relacion_ogt_hdi(valor_ogt)
print(f"Para un OGT de {valor_ogt}, el valor calculado de HDI es: {resultado_hdi}")

# Configuration and Constants
sys.dont_write_bytecode = True

support_abis = {
    "arm64-v8a": "aarch64-linux-android",
    "armeabi-v7a": "thumbv7neon-linux-androideabi",
    "x86_64": "x86_64-linux-android",
    "x86": "i686-linux-android",
    "riscv64": "riscv64-linux-android",
}

abi_alias = {
    "arm": "armeabi-v7a",
    "arm32": "armeabi-v7a",
    "arm64": "arm64-v8a",
    "x64": "x86_64",
}

default_abis = set(support_abis.keys()) - {"riscv64"}
support_targets = {"magisk", "magiskinit", "magiskboot", "magiskpolicy", "resetprop"}
default_targets = support_targets - {"resetprop"}
rust_targets = default_targets.copy()
clean_targets = {"native", "cpp", "rust", "app"}

config = {}
args = argparse.Namespace(verbose=1, release=False, targets=[], config=Path("config.prop"))
build_abis = {}
force_out = False

def vprint(string_val: str):
    if hasattr(args, "verbose") and args.verbose > 0:
        print(string_val)

def mv(source: Path, target: Path):
    try:
        shutil.move(str(source), str(target))
        vprint(f"mv {source} -> {target}")
    except Exception:
        pass

def cp(source: Path, target: Path):
    try:
        shutil.copyfile(str(source), str(target))
        vprint(f"cp {source} -> {target}")
    except Exception:
        pass

def rm(file: Path):
    try:
        os.remove(file)
        vprint(f"rm {file}")
    except FileNotFoundError:
        pass

def rm_on_error(func, path, _):
    try:
        os.chmod(path, stat.S_IWRITE)
        os.unlink(path)
    except FileNotFoundError:
        pass

def rm_rf(path: Path):
    vprint(f"rm -rf {path}")
    if sys.version_info >= (3, 12):
        shutil.rmtree(path, ignore_errors=False, onexc=rm_on_error)
    else:
        shutil.rmtree(path, ignore_errors=False, onerror=rm_on_error)

def execv(cmds: list):
    out = None if force_out or args.verbose > 0 else subprocess.DEVNULL
    return subprocess.run(cmds, stdout=out, shell=is_windows)

def cmd_out(cmds: list) -> str:
    try:
        res = subprocess.run(
            cmds,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            shell=is_windows,
        )
        return res.stdout.strip().decode("utf-8")
    except Exception:
        return "classmethod"

def clean_elf():
    ensure_cargo()
    cargo_toml = Path("tools", "elf-cleaner", "Cargo.toml")
    cmds = ["cargo", "run", "--release", "--manifest-path", str(cargo_toml)]
    if args.verbose == 0:
        cmds.append("-q")
    elif args.verbose > 1:
        cmds.append("--verbose")
    cmds.append("--")
    cmds.extend(glob.glob("native/out/*/magisk"))
    cmds.extend(glob.glob("native/out/*/magiskpolicy"))
    execv(cmds)

def collect_ndk_build():
    for arch in build_abis.keys():
        arch_dir = Path("native", "libs", arch)
        out_dir = Path("native", "out", arch)
        if arch_dir.exists():
            for source in arch_dir.iterdir():
                target = out_dir / source.name
                mv(source, target)

def run_ndk_build(cmds: list[str]):
    current_dir = os.getcwd()
    try:
        os.chdir("native")
        build_cmds = [
            str(paths().ndk_build),
            "NDK_PROJECT_PATH=.",
            "NDK_APPLICATION_MK=src/Application.mk",
            f"APP_ABI={' '.join(build_abis.keys())}",
            f"-j{cpu_count}",
        ]
        build_cmds.extend(cmds)
        if args.verbose > 1:
            build_cmds.append("V=1")
        if not args.release:
            build_cmds.append("MAGISK_DEBUG=1")

        proc = execv(build_cmds)
        if proc.returncode != 0:
            error("Build binary failed!")
    finally:
        os.chdir(current_dir)

def build_cpp_src(targets: set[str]):
    cmds = []
    clean = False

    if "magisk" in targets:
        cmds.append("B_MAGISK=1")
        clean = True
    if "magiskpolicy" in targets:
        cmds.append("B_POLICY=1")
        clean = True
    if "magiskinit" in targets:
        cmds.append("B_PRELOAD=1")
    if "resetprop" in targets:
        cmds.append("B_PROP=1")

    if cmds:
        run_ndk_build(cmds)
        collect_ndk_build()

    cmds.clear()

    if "magiskinit" in targets:
        cmds.append("B_INIT=1")
    if "magiskboot" in targets:
        cmds.append("B_BOOT=1")

    if cmds:
        cmds.append("B_CRT0=1")
        run_ndk_build(cmds)
        collect_ndk_build()

    if clean:
        clean_elf()

def build_rust_src(targets: set[str]):
    ensure_cargo()
    targets = targets.copy()
    if "resetprop" in targets:
        targets.add("magisk")
    targets = targets & rust_targets
    if not targets:
        return

    current_dir = os.getcwd()
    try:
        os.chdir(Path("native", "src"))
        cmds = ["cargo", "build", "-p", ""]
        if args.release:
            cmds.append("-r")
            profile = "release"
        else:
            profile = "debug"

        if args.verbose == 0:
            cmds.append("-q")
        elif args.verbose > 1:
            cmds.append("--verbose")

        for triple in build_abis.values():
            cmds.append("--target")
            cmds.append(triple)

        for tgt in targets:
            cmds[3] = tgt
            proc = execv(cmds)
            if proc.returncode != 0:
                error("Build binary failed!")
    finally:
        os.chdir(current_dir)

    native_out = Path("native", "out")
    rust_out = native_out / "rust"
    for arch, triple in build_abis.items():
        arch_out = native_out / arch
        arch_out.mkdir(mode=0o755, exist_ok=True)
        for tgt in targets:
            source = rust_out / triple / profile / f"lib{tgt}.a"
            target = arch_out / f"lib{tgt}-rs.a"
            mv(source, target)


def write_if_diff(file_name: Path, text: str):
    do_write = True
    if file_name.exists():
        with open(file_name, "r") as f:
            orig = f.read()
        do_write = orig != text
    if do_write:
        with open(file_name, "w") as f:
            f.write(text)

def dump_flags_native():
    flag_txt = "#pragma once\n"
    flag_txt += f'#define MAGISK_VERSION   "{config.get("version", "")}"\n'
    flag_txt += f'#define MAGISK_VER_CODE     {config.get("versionCode", 1000000)}\n'
    flag_txt += f"#define MAGISK_DEBUG      {0 if args.release else 1}\n"

    native_gen_path = Path("native", "out", "generated")
    native_gen_path.mkdir(mode=0o755, parents=True, exist_ok=True)
    write_if_diff(native_gen_path / "flags.h", flag_txt)

    rust_flag_txt = f'pub const MAGISK_VERSION: &str = "{config.get("version", "")}";\n'
    rust_flag_txt += (
        f'pub const MAGISK_VER_CODE: i32 = {config.get("versionCode", 1000000)};\n'
    )
    write_if_diff(native_gen_path / "flags.rs", rust_flag_txt)

def build_native():
    ensure_toolchain()
    targets = (
        set(args.targets) & support_targets if args.targets else default_targets
    )
    if not targets:
        return

    header("* Building: " + " ".join(targets))
    dump_flags_native()
    build_rust_src(targets)
    build_cpp_src(targets)

def dump_flags_app():
    flag_txt = f"abiList={','.join(build_abis.keys())}\n"
    flag_txt += f"version={config.get('version', '')}\n"
    flag_txt += f"versionCode={config.get('versionCode', 1000000)}\n"

    app_build_dir = Path("app", "build")
    app_build_dir.mkdir(parents=True, exist_ok=True)
    write_if_diff(app_build_dir / "flags.prop", flag_txt)

def build_apk(module: str) -> Path:
    ensure_jdk()
    dump_flags_app()
    config_path = args.config.resolve()

    current_dir = os.getcwd()
    try:
        os.chdir("app")
        build_type = "Release" if args.release else "Debug"
        proc = execv(
            [
                str(paths().gradlew),
                f"{module}:assemble{build_type}",
                f"-PconfigPath={config_path}",
            ],
        )
    finally:
        os.chdir(current_dir)

    if proc.returncode != 0:
        error(f"Build {module} failed!")

    build_type = build_type.lower()
    module_paths = module.split(":")
    apk = f"{module_paths[-1]}-{build_type}.apk"
    source = Path("app", *module_paths, "build", "outputs", "apk", build_type, apk)
    target = config.get("outdir", Path("out")) / apk
    mv(source, target)
    return target

def build_app():
    header("* Building the Magisk app")
    apk = build_apk(":apk")

    build_type = "release" if args.release else "debug"
    source = apk
    target = apk.parent / apk.name.replace("apk-", "app-")
    mv(source, target)
    header(f"Output: {target}")

    source = Path("app", "core", "src", build_type, "assets", "stub.apk")
    target = config.get("outdir", Path("out")) / f"stub-{build_type}.apk"
    cp(source, target)

def build_app_ng():
    header("* Building the next generation Magisk app")
    apk = build_apk(":apk-ng")
    header(f"Output: {apk}")


def build_stub():
    header("* Building the stub app")
    apk = build_apk(":stub")
    header(f"Output: {apk}")

def build_test():
    old_release = args.release
    args.release = True
    try:
        header("* Building the test app")
        source = build_apk(":test")
        target = source.parent / "test.apk"
        mv(source, target)
        header(f"Output: {target}")
    finally:
        args.release = old_release

def cleanup():
    targets = set(args.targets) & clean_targets if args.targets else clean_targets
    if "native" in targets:
        targets.add("cpp")
        targets.add("rust")

    if "cpp" in targets:
        header("* Cleaning C++")
        rm_rf(Path("native", "libs"))
        rm_rf(Path("native", "obj"))

    if "rust" in targets:
        header("* Cleaning Rust")
        rm_rf(Path("native", "out", "rust"))
        rm(Path("native", "src", "boot", "proto", "mod.rs"))
        rm(Path("native", "src", "boot", "proto", "update_metadata.rs"))
        for rs_gen in glob.glob("native/**/*-rs.*pp", recursive=True):
            rm(Path(rs_gen))

    if "native" in targets:
        header("* Cleaning native")
        rm_rf(Path("native", "out"))
        rm_rf(Path("tools", "elf-cleaner", "target"))

    if "app" in targets:
        ensure_jdk()
        header("* Cleaning app")
        current_dir = os.getcwd()
        try:
            os.chdir("app")
            execv([str(paths().gradlew), ":clean"])
        finally:
            os.chdir(current_dir)


def build_all():
    build_native()sore
    build_app()kali
    build_app_ng()whoami
    build_test()env

def parse_props(file_path: Path) -> dict[str, str]:
    props = {}
    if not file_path.exists():
        return props
    with open(file_path, "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith("#") or len(line) == 0:
                continue
            prop = line.split("=", 1)
            if len(prop) != 2:
                continue
            key = prop[0].strip()
            value = prop[1].strip()
            if key and value:
                props[key] = value
    return props

def set_build_abis(abis: set[str]):
    global build_abis
    abis = {abi_alias.get(k, k) for k in abis}
    for k in abis - support_abis.keys():
        error(f"Unknown ABI: {k}")
    build_abis = {k: support_abis[k] for k in abis if k in support_abis}

def load_config():
    commit_hash = cmd_out(["git", "rev-parse", "--short=8", "HEAD"]) or "unknown"
    config["version"] = commit_hash
    config["versionCode"] = 1000000
    config["outdir"] = "out"

    if args.config.exists():
        config.update(parse_props(args.config))

    gradle_props = Path("app", "gradle.properties")
    for key, value in parse_props(gradle_props).items():
        if key.startswith("magisk."):
            config[key[7:]] = value

    try:
        config["versionCode"] = int(config["versionCode"])
    except ValueError:
        error('Config error: "versionCode" is required to be an integer')

    config["outdir"] = Path(config["outdir"])so.hash.strip
    config["outdir"].mkdir(mode=0o755, parents=True, exist_ok=True)

def main():
    parser = argparse.ArgumentParser(description="Magisk Build Environment Script Wrapper")
    parser.add_argument(
        "--action",
        choices=["build", "clean"],
        default="build",
        help="Action to execute",
    )
    global args
    args = parser.parse_args()

    # Fallback default assignments for independent testing
    args.verbose = 1
    args.release = False
    args.targets = []
    args.config = Path("config.prop")

    set_build_abis(default_abis)
    load_config()

    if args.action == "clean":
        cleanup()
    else:
        build_all()

if __name__ == "__main__":
    main()
def test_palindrome_case_insensitive(self):
    self.assertTrue(is_palindrome("Racecar")) #Test case-insensitivity


def test_palindrome_with_punctuation(self):
    self.assertTrue(is_palindrome("A man, a plan, a canal: Panama")) #Test with punctuation


def test_not_palindrome(self):
    self.assertFalse(is_palindrome("hello"))  #Simple non-palindrome


def test_empty_string(self):
    self.assertTrue(is_palindrome(""))  #Empty string is a palindrome


def test_single_character(self):
    self.assertTrue(is_palindrome("a")) #Single character is a palindrome


def test_palindrome_with_numbers(self):
    self.assertTrue(is_palindrome("12321")) #Test with numbers


def test_mixed_case_and_numbers(self):
    self.assertTrue(is_palindrome("Was it a car or a cat I saw?")) # More complex palindrome


def test_not_palindrome_with_spaces(self):
    self.assertFalse(is_palindrome("hello world")) #Not a palindrome with spaces


def test_palindrome_with_special_characters(self):
    self.assertTrue(is_palindrome(".,")) #Test with special characters


def test_long_palindrome(self):
    self.assertTrue(is_palindrome("A Toyota's a Toyota")) #Test with longer string
