param (
    [switch]$all = $false
)

if (!$all) {
    echo "The setup script doesn't currently support options. Please call with -all for a full setup"
} else {
    echo "Installing all tools & packages..."

    choco install everything googlechrome vscode 7zip.install -y

    # Spotify on chocolatey currently has issues with checksum verification. For that reason, we disabled the check for it.
    choco install spotify -y --ignore-checksums

    refreshenv

    # vscode
    if (!(test-path "$HOME\AppData\Roaming\Code\User")) {
        New-Item "$HOME\AppData\Roaming\Code\User" -ItemType Directory
    }
    # Copy vscode settings over
    Copy-Item -Recurse -Verbose -Force -Path "..\config\vscode\*" -Destination "$HOME\AppData\Roaming\Code\User\"
    # Install vscode packages
    code --install-extension vscodevim.vim

    # Make a bin folder for user scripts
    # Note: this assumes bootstrap's location
    New-Item "$HOME\bin" -ItemType Directory
    Copy-Item -Force -Recurse -Verbose -Path "${env:USERPROFILE}\bootstrap\tools\windows\*" -Destination "$HOME\bin"

    # Modify the PATH
    echo "Path backup:"
    echo $([Environment]::GetEnvironmentVariable("Path", "User"))
    echo $([Environment]::GetEnvironmentVariable("Path", "Machine"))

    # Add the user scripts to $HOME/bin
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + "$HOME\bin", [EnvironmentVariableTarget]::User)

    # Install Windows Subsystem for Linux
    & ((Split-Path $MyInvocation.InvocationName) + "\wsl.ps1") > "$(env:USERPROFILE)\bootstrap\out\wsl_$(Get-Date -Format FileDateTime).txt"
}
