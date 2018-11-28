param (
    [switch]$all = $false
)

if (!$all) {
    echo "The setup script doesn't currently support options. Please call with -all for a full setup"
} else {
    echo "Installing all tools & packages..."

    choco install everything googlechrome vscode -y

    # Spotify on chocolatey currently has issues with checksum verification. For that reason, we disabled the check for it.
    choco install spotify -y --ignore-checksums

    # Install Windows Subsystem for Linux
    & ((Split-Path $MyInvocation.InvocationName) + "\wsl.ps1")
}
