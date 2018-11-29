Import-Module -Name PSWorkflow

# Finish wsl.ps1
$jobs = Get-Job -state Suspended
Write-Host "Cleaning up Ubuntu install..." -NoNewLine
$resumedJobs = $jobs | resume-job -wait
$resumedJobs | wait-job
Write-Host "Complete."

Start-Sleep -s 5

# Install ubuntu
if (!(Get-Command "bash" -ErrorAction SilentlyContinue)) {
    echo "Installing Ubuntu..."
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
    Add-AppxPackage -Path ~/Ubuntu.appx
    RefreshEnv
    InlineScript { Ubuntu1804 install --root }
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
    Copy-Item "..\config\wsl-terminal\wsl-terminal.conf" "$HOME\wsl-terminal\etc\wsl-terminal.conf"
    Copy-Item "..\config\wsl-terminal\minttyrc" "$HOME\wsl-terminal\etc\minttyrc"
    Remove-Item "$HOME\wsl-terminal.7z"

    echo "Installing powerline font"
    wget "https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf?raw=true" -OutFile "$HOME\wsl-terminal\DejaVuSansMono.ttf"
    .\install_font.ps1 "$HOME\wsl-terminal\DejaVuSansMono.ttf"

    echo "Adding open-wsl to PATH"
    $oldpath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path
    $newpath = "$oldpath;$HOME\wsl-terminal"
    Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newPath
}

# Install & Configure linux stuff
$bootstrapPath = "$PSScriptRoot"
$linuxBootstrapPath = ($bootstrapPath -replace "\\", "/")
bash -c "./linux_bootstrap.sh $linuxBootstrapPath"