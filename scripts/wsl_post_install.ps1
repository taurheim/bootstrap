Import-Module -Name PSWorkflow

Start-Transcript -Path "$HOME\bootstrap\out\wsl_post_install_$(Get-Date -Format FileDateTime).txt"

# Finish wsl.ps1
$jobs = Get-Job -state Suspended
Write-Host "Cleaning up Ubuntu install..." -NoNewLine
$resumedJobs = $jobs | resume-job -wait
$resumedJobs | wait-job
Write-Host "Complete."

Start-Sleep -s 5

Unregister-ScheduledTask -TaskName ResumeWSLInstall -Confirm:$false

# Install ubuntu
if (!($($(wslconfig /list /all) -replace "\0","") -match "Ubuntu")) {
    echo "Installing Ubuntu..."
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
    Add-AppxPackage -Path ~/Ubuntu.appx
    RefreshEnv
    Ubuntu1804 install --root
    Remove-Item ~/Ubuntu.appx
    echo "Finished installing Ubuntu."
}

# Install wsl-terminal
if (!(test-path "$HOME\wsl-terminal")) {
    echo "Installing wsl-terminal..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    wget "https://github.com/goreliu/wsl-terminal/releases/download/v0.8.11/wsl-terminal-0.8.11.7z" -OutFile "$HOME\wsl-terminal.7z"
    7z x "$HOME\wsl-terminal.7z" -o"$HOME"

    echo "Copying wsl-terminal settings over"
    Copy-Item "$HOME\bootstrap\config\wsl-terminal\wsl-terminal.conf" "$HOME\wsl-terminal\etc\wsl-terminal.conf"
    Copy-Item "$HOME\bootstrap\config\wsl-terminal\minttyrc" "$HOME\wsl-terminal\etc\minttyrc"
    Remove-Item "$HOME\wsl-terminal.7z"

    echo "Installing powerline font"
    wget "https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf?raw=true" -OutFile "$HOME\wsl-terminal\DejaVuSansMono.ttf"
    & "$HOME\bootstrap\scripts\install_font.ps1" "$HOME\wsl-terminal\DejaVuSansMono.ttf"

    echo "Adding open-wsl to PATH"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "Machine") + ";$HOME\wsl-terminal", [EnvironmentVariableTarget]::Machine)
}

# Install & Configure linux stuff
$bootstrapPath = Split-Path $PSScriptRoot -Parent
$linuxBootstrapPath = wsl wslpath -a ($bootstrapPath -replace "\\", "/")
$scriptPath = wsl wslpath -a ("$HOME\bootstrap\scripts\linux_bootstrap.sh" -replace "\\", "/")
bash -c "$scriptPath $linuxBootstrapPath"
Stop-Transcript
