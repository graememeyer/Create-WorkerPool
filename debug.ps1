Clear-Host
Get-Job | Remove-Job # Clear any existing jobs

# Check if the script is being run in a normal console window, and if not, relaunch in a normal console window.
if ($Host.name -ne "ConsoleHost") {
    $CurrentScript = $MyInvocation.MyCommand.Definition
    $ps = Join-Path $PSHome 'powershell.exe'
    Start-Process $ps -ArgumentList "& '$CurrentScript'"

    # Stops execution of this process.
    # Only continues execution of this script if in a stand-alone console window.
    break
}

# The actual debug script you want to run in the new window
Import-Module .\New-WorkerPool.psm1
New-WorkerPool {DemoSleepFunction} 10

<# 
Write-Host "Complete. Press the enter key to exit."
Read-Host # Hold the new window open after the process is complete.
#>

# Press any key to exit, rather than having to press enter like with Read-Host.
# Doesn't work in ISE apparently. 
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');