echo "Installing WSL..."

# Schedule a task to continue running the script upon restart
$resumeSuspendedJobsScriptPath = $PSScriptRoot + '\wsl_post_install.ps1'
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

    # Cleanup?
    echo "Windows features enabled."
}

$job = install-wsl -asjob
Wait-job $job
