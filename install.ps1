$ErrorActionPreference = 'Stop'

# Change this once to your public GitHub repository.
$DownloadUrl = 'https://github.com/YOUR_USERNAME/KNLBooster/releases/latest/download/KNLBooster-win-x64.zip'

$work = Join-Path $env:TEMP ('KNLBoosterInstall_' + [Guid]::NewGuid().ToString('N'))
$zip = Join-Path $work 'KNLBooster-win-x64.zip'
$package = Join-Path $work 'package'

try {
    New-Item -ItemType Directory -Path $package -Force | Out-Null

    Write-Host 'Downloading KNL Booster...' -ForegroundColor Cyan
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $zip -UseBasicParsing

    Write-Host 'Extracting package...' -ForegroundColor Cyan
    Expand-Archive -Path $zip -DestinationPath $package -Force

    $exe = Get-ChildItem -Path $package -Filter 'KNLBoost.exe' -File -Recurse | Select-Object -First 1
    if (-not $exe) {
        throw 'KNLBoost.exe was not found in the downloaded package.'
    }

    Write-Host 'Requesting Administrator permission...' -ForegroundColor Cyan
    $p = Start-Process -FilePath $exe.FullName -ArgumentList '--install' -Verb RunAs -Wait -PassThru

    if ($p.ExitCode -ne 0) {
        throw "KNL Booster installer failed with exit code $($p.ExitCode)."
    }

    Write-Host ''
    Write-Host 'KNL Booster installed successfully.' -ForegroundColor Green
    Write-Host 'Right-click the Desktop/Folder background to use it.'
}
finally {
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
