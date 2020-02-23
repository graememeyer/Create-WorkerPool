Clear-Host
Get-Job | Remove-Job

Import-Module .\New-WorkerPool.psm1

New-WorkerPool {DoSomeWork}

# Write-Host ""
# for ($i = 1; $i -le 100; $i++ )
# {
#     Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i;
#     Start-Sleep -Milliseconds 100
# }
# Write-Host ""


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