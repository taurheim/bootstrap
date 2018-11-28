Import-Module -Name PSWorkflow
$jobs = Get-Job -state Suspended
echo "Resuming suspended jobs..."
$resumedJobs = $jobs | resume-job -wait
$resumedJobs | wait-job
echo "All suspended jobs have completed."
Start-Sleep -s 60
echo "Terminating."
start bash