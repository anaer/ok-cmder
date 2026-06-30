param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

for ($i = 1; $i -le 100; $i++) {
    Write-Host "$i -------------------"
    & $Command $Arguments
    if ($LASTEXITCODE -eq 0) {
        exit 0
    }
    Start-Sleep -Seconds 3
}

exit 1
