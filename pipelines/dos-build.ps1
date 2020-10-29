Write-Host $env:SOURCEFOLDER
$conf = Get-Content -Path 'pipelines\dosbox.conf' -Raw
$newContent = $conf -replace "{{Source_Folder}}" , $env:SOURCEFOLDER
New-Item "pipelines\dosbox.conf" -Value $newContent -Force

SET SDL_VIDEODRIVER=dummy
& "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe" -conf $env:SOURCEFOLDER\pipelines\dosbox.conf -noconsole