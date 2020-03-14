Clear-Host
Get-Job | Remove-Job # Clear any existing jobs

# Check if the script is being run in a normal console window, and if not, relaunch in a normal console window.
try {
    if ($Host.name -ne "ConsoleHost") {
        $CurrentScript = $MyInvocation.MyCommand.Definition
        $ps = Join-Path $PSHome 'powershell.exe'
        Start-Process $ps -ArgumentList "& '$CurrentScript'"
    } else {
        Import-Module .\New-WorkerPool.psm1
        DoSomeWork
        Read-Host
    }
} catch {
    Write-Host -ForegroundColor Red "Caught Exception: $($Error[0].Exception.Message)"
    exit 2
}