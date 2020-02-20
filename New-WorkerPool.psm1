# Create-WorkerPool

<#
.SYNOPSIS
    Creates an auto-scaling pool of workers for multi-threaded processing.
.DESCRIPTION
    Powershell module to create an auto-scaling pool of workers for multi-threaded processing.
.NOTES
    File Name : New-WorkerPool.psm1
    Author    : Graeme Meyer (@graememeyer)
    Version   : 0.1
.LINK
    https://github.com/graememeyer/
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

    # Create the thread pool
    $env:WhereAmI = Get-Location 
    for ($i=0; $i -le $WorkerCount; $i++){
        Start-Job -ScriptBlock $ScriptBlock -InitializationScript { Import-Module "$env:WhereAmI\New-WorkerPool.psm1" }
    }
}

function DoSomeWork {
    # Do some work
    Write-Host "Starting some work."
    $Total=0
    for($i; $i-le 5;$i++){
        $SleepAmount = Get-Random -Minimum -0 -Maximum 5000
        Start-Sleep -Milliseconds $SleepAmount
        $Total = $Total + $SleepAmount
    }
    Write-Host "Ending some work. Total sleep time: $($Total)"
    # Return a message to the main thread
    return $Total
}