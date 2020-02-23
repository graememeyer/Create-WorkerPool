Clear-Host
Get-Job | Remove-Job

Import-Module .\New-WorkerPool.psm1

New-WorkerPool {DoSomeWork}

$Jobs = Get-Job
$TotalJobsCount = $Jobs.count
$RunningJobsCount = $TotalJobsCount

While($RunningJobsCount -gt 0){
    $RunningJobs = $Jobs | Where-Object State -ne "Completed"
    $RunningJobsCount = $RunningJobs.count
    $RemainingJobsCount = $TotalJobsCount - $RunningJobsCount
    $PercentOfJobsComplete =  $RemainingJobsCount / $TotalJobsCount * 100
    Write-Progress -Activity "Jobs in progress" -Status "$($PercentOfJobsComplete)% Complete:" -PercentComplete $PercentOfJobsComplete;
    Start-Sleep -Milliseconds 600
}

"All jobs complete."