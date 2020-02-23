Clear-Host
Get-Job | Remove-Job

Import-Module .\New-WorkerPool.psm1

New-WorkerPool {DoSomeWork}