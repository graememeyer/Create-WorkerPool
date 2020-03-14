# Create-WorkerPool

<#
.SYNOPSIS
    Creates an auto-scaling pool of workers for multi-threaded processing.
.DESCRIPTION
    Powershell module to create an auto-scaling pool of workers for multi-threaded processing.
.NOTES
    File Name : New-WorkerPool.psm1
    Author    : Graeme Meyer (@graememeyer)
    Version   : 0.5
.LINK
    https://github.com/graememeyer/New-WorkerPool
#>

[int] $DefaultWorkerCount = 5

function New-WorkerPool {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_})]
        [scriptblock] $ScriptBlock,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $WorkerCount
    )

    Write-Host "Script block you have submitted: $($ScriptBlock)"

    if(!$WorkerCount){
        Write-Warning "You have not submitted a number of workers - the default of $($DefaultWorkerCount) will be used."
        $WorkerCount = $DefaultWorkerCount
    }

    Write-Host "Starting jobs..."
    # Create the thread pool
    $env:WhereAmI = Get-Location 
    for ($i=1; $i -le $WorkerCount; $i++){
        Start-Job -ScriptBlock $ScriptBlock -InitializationScript { Import-Module "$env:WhereAmI\New-WorkerPool.psm1" }
    }
    Write-Host "$($WorkerCount) jobs started..."
    
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
}

function DemoSleepFunction {
    # Do some work
    Write-Host "Starting some work."
    $Total=0
    for($i; $i-le 5;$i++){
        $SleepAmount = Get-Random -Minimum -0 -Maximum 1000
        Start-Sleep -Milliseconds $SleepAmount
        $Total = $Total + $SleepAmount
    }
    Write-Host "Ending some work. Total sleep time: $($Total)"
    # Return a message to the main thread
    return $Total
}