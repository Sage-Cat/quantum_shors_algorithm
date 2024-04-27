import argparse
import sys
import shutil
from pathlib import Path
import subprocess
from colorama import Fore, Style, init

# Initialize Colorama to auto-reset styles
init(autoreset=True)

def run_command(command):
    """Utility function to run commands safely and catch exceptions."""
    try:
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(Fore.GREEN + "[OK] " + Style.RESET_ALL + f"Success: '{' '.join(command)}'")
        return result
    except subprocess.CalledProcessError as e:
        print(Fore.RED + "[FAIL] " + Style.RESET_ALL + f"Error during '{' '.join(command)}': {e.stderr.decode()}", file=sys.stderr)
        sys.exit(1)

def clean_build_dir(build_dir):
    """Remove the build directory if it exists, using pathlib for path manipulation."""
    if build_dir.exists():
        shutil.rmtree(build_dir)

def setup_conan(build_dir):
    """Configure the conan installation."""
    run_command(['conan', 'install', '.', f'--output-folder={build_dir}', '--build=missing'])

def configure_cmake(build_dir):
    """Configure the project using CMake with provided options."""
    run_command(['cmake', '.', f'-B{build_dir}', '--preset', 'conan-release'])

def build_cmake(build_dir):
    """Build the project using CMake."""
    run_command(['cmake', '--build', str(build_dir)])

def build_project():
    """General build function that can handle full or incremental builds."""
    build_dir = Path('build')
    clean_build_dir(build_dir)
    setup_conan(build_dir)
    configure_cmake(build_dir)
    build_cmake(build_dir)

def main():
    build_project()

if __name__ == "__main__":
    main()
