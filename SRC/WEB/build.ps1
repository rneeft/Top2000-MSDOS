$template = Get-Content -Path 'template_NL' -Raw
$nl_items = Get-ChildItem ('NL\*.html');
$imgs = Get-ChildItem('IMG\*.*');

Copy-Item "IMG" -Destination "BIN\NL\IMG" -Recurse

foreach ($item in $nl_items) {
    $path = "BIN\NL\"  + $item.Name;
    $content = Get-Content -Path $item -Raw
    $newContent = $template -replace "{{Content}}" , $content
    $newContent = $newContent -replace "{{Name}}", $item.Name
    New-Item -Path $path -Value $newContent -Force
}
