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


$RemainingJobs = Get-Job | Where-Object State -eq "Running"
While($RemainingJobs){
    $RemainingJobs = Get-Job | Where-Object State -eq "Running"
    Clear-Host
    $RemainingJobs
    Start-Sleep -milliseconds 600
}