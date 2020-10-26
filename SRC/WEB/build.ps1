$templateNL = Get-Content -Path 'template_NL.html' -Raw
$templateEN = Get-Content -Path 'template_EN.html' -Raw
$nl_items = Get-ChildItem ('nl\*.html');
$en_items = Get-ChildItem ('en\*.html');

# making sure folder exists
mkdir -PATH "bin\img"  -Force
mkdir -PATH "bin\css" -Force

# copying site items
Copy-Item "img\*" -Destination "bin\img" -Force
Copy-Item "css\*" -Destination "bin\css" -Force
Copy-Item "favicon.ico" -Destination "bin\favicon.ico" -Force

# replace all items for Dutch.
foreach ($item in $nl_items) {
    $path = "bin\nl\"  + $item.Name;
    $content = Get-Content -Path $item -Raw
    $newContent = $templateNL -replace "{{Content}}" , $content
    $newContent = $newContent -replace "{{Name}}", $item.Name
    New-Item -Path $path -Value $newContent -Force
}

# replace all items for English.
foreach ($item in $en_items) {
    $path = "bin\en\"  + $item.Name;
    $content = Get-Content -Path $item -Raw
    $newContent = $templateEN -replace "{{Content}}" , $content
    $newContent = $newContent -replace "{{Name}}", $item.Name
    New-Item -Path $path -Value $newContent -Force
}

# create index html (Dutch)
$content = Get-Content -Path "BIN\nl\index.html" -Raw
# replace all ../ in the index.html
$newContent = $content -replace "\.\.\/", ""
New-item "bin\index.html" -Value $newContent -Force