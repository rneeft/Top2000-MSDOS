Write-Host $env:SOURCEFOLDER
$conf = Get-Content -Path 'pipelines\dosbox.conf' -Raw
$newContent = $conf -replace "{{Source_Folder}}" , $env:SOURCEFOLDER
New-Item "pipelines\dosbox.conf" -Value $newContent -Force

Set-Variable SDL_VIDEODRIVER=dummy
$dos = Start-Process -FilePath "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe"  -ArgumentList "-conf $env:SOURCEFOLDER\pipelines\dosbox.conf -noconsole" -PassThru

Wait-Process $dos.Id