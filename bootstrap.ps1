# Install chocolatey package manager
if (!(Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    echo "Installing Chocolatey..."
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    echo "Chocolatey successfully installed"
    $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    refreshenv
}

# Install git for windows
if (!(Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    choco upgrade git -y -params '"/GitAndUnixToolsOnPath"'
    refreshenv
}

# Grab the rest of the bootstrapper
if (!(test-path "$env:USERPROFILE\bootstrap\")) {
    pushd $env:USERPROFILE
    git clone https://github.com/taurheim/bootstrap.git
    popd
    refreshenv
}

# Start the rest of the scripts
echo "`n`nSuccessfully got the bootstrap script! Use the following command to install what you need!`n"
echo "$env:USERPROFILE\bootstrap\scripts\setup.ps1 -all > $env:USERPROFILE\bootstrap\out\setup_$(Get-Date -Format FileDateTime).txt"
echo "`n"