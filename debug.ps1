Clear-Host
Get-Job | Remove-Job

Import-Module .\New-WorkerPool.psm1
Start-Process PowerShell.exe {Import-Module "$env:WhereAmI\New-WorkerPool.psm1"; DoSomeWork}