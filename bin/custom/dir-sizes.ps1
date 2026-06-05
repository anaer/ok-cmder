# dir-sizes.ps1
Get-ChildItem -Directory | ForEach-Object {
    $dirName = $_.Name
    $size = (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum
    $sizeMB = if ($size) { [math]::Round($size / 1MB, 2) } else { 0 }

    [PSCustomObject]@{
        Name = $dirName
        SizeMB = $sizeMB
    }
} | Sort-Object -Property SizeMB -Descending | Select-Object -First 10  | Format-Table -AutoSize