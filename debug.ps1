Import-Module .\New-WorkerPool.psm1

# New-WorkerPool {DoSomeWork}


Start-Job -ScriptBlock {DoSomeWork}

While($false){
    $test = Receive-Job -Id 1        
}
