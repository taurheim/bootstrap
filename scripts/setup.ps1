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

    # Copy vscode settings over
    if (!(test-path "$HOME\AppData\Roaming\Code\User")) {
        New-Item "$HOME\AppData\Roaming\Code\User" -ItemType Directory
        Copy-Item -Recurse -Verbose -Force -Path "..\config\vscode\*" -Destination "$HOME\AppData\Roaming\Code\User\"
    }

    # Install vscode packages
    code --install-extension vscodevim.vim

    # Install Windows Subsystem for Linux
    & ((Split-Path $MyInvocation.InvocationName) + "\wsl.ps1")
}
