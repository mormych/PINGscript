# PINGscript


function Read-File {
    param (
        $FileName
    )

    return Get-Content -Path $FileName
}

function Check-Internet {
    param (
        [string]$Address
    )
    
    If (Test-Connection $Address -Quiet) {
        Write-Host "OK" -ForegroundColor Green 
    } Else {
        Throw "No internet connection"
    }
}

function Send-Email() {

    Param (
        [string[]]$IPArray, 
        [string[]]$Adresses
    )

    $config = Read-File -FileName $PSScriptRoot\config
    $username = $config[0]
    $password = ConvertTo-SecureString $config[1] -AsPlainText -Force
    $smtp = $config[2]

    $Cred = New-Object System.Management.Automation.PSCredential ($username, $password)

    $MailMessage = @{
        To = $Adresses
        From = $username
        Subject = "Brak komunikacji PING"
        Body = "Uwaga! Wykryto brak komunikacji z następującymi hostami: <p>$(Out-String -InputObject $IPArray)</p>"
        Smtpserver = $smtp
        BodyAsHtml = $true
        Encoding = "UTF8"
        Credential = $Cred
        UseSsl = $true
    }
    Send-MailMessage @MailMessage
}

Write-Host "Checking internet connection..." -NoNewline

try {
    Check-Internet -Address 1.1.1.1
} catch {
    Write-Error $_
    Exit
}

Write-Host "Loading data from files..." -NoNewline
try {
    $HostsToPing = Read-File -FileName $PSScriptRoot\hosts
    [string[]]$AddressesToSend = Read-File -FileName $PSScriptRoot\addresses
} catch {
    Write-Error "Undefined error while reading data from files...."
    Exit
}
Write-Host "OK" -ForegroundColor Green 

$NotRespondingHosts = New-Object System.Collections.ArrayList

foreach ($Address in $HostsToPing) {
    try {
        Write-Host "Trying to PING $($Address)..." -NoNewline
        Check-Internet -Address $Address
    } catch {
        Write-Host "HOST: $($Address) NOT RESPONDING!. Reporting..." -ForegroundColor Red
        $NotRespondingHosts.Add($Address) > $null
    } finally {
        Write-Host "Loading next host..."
    }
}

Write-Host "No host to PING"

Write-Host "Statistics"
Write-Host "Not responding hosts: $($NotRespondingHosts.Count)" -ForegroundColor Red
Write-Host "All hosts           : $($HostsToPing.Count)" -ForegroundColor Yellow
Write-Host "Responding hosts    : $($HostsToPing.Count - $NotRespondingHosts.Count)" -ForegroundColor Green

If($NotRespondingHosts.Count -gt 0) {
    Write-Host "We discovered not responding hosts. This incident will be reported" -ForegroundColor Red
    Send-Email -IPArray $NotRespondingHosts -Adresses $AddressesToSend
}