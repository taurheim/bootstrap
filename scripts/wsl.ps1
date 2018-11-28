echo "Installing WSL..."

# Schedule a task to continue running the script upon restart
$resumeSuspendedJobsScriptPath = $PSScriptRoot + '\resume_suspended_jobs.ps1'
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File `"$resumeSuspendedJobsScriptPath`""
Get-ScheduledTask -TaskName ResumeWSLInstall -EA SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
$act = New-ScheduledTaskAction -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Argument $resumeActionscript
$trig = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:55
Register-ScheduledTask -TaskName ResumeWSLInstall -Action $act -Trigger $trig -RunLevel Highest
echo "Scheduled."

# Enable the windows feature for WSL
workflow install-wsl {
    echo "Enabling windows features..."
    # Enable windows subsystem feature
    choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
    Restart-Computer -Wait
    echo "WSL Features enabled."
    Start-Sleep -s 15

    # Install ubuntu
    echo "15 Seconds have elapsed. Installing Ubuntu."
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
    Add-AppxPackage -Path ~/Ubuntu.appx
    RefreshEnv
    InlineScript { Ubuntu1804 install --root }
}

$job = install-wsl -asjob

Wait-job $job
