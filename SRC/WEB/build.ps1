$template = Get-Content -Path 'template_NL.html' -Raw
$nl_items = Get-ChildItem ('nl\*.html');
$en_items = Get-ChildItem ('en\*.html');

# making sure folder exists
mkdir -PATH "BIN\IMG"  -Force
mkdir -PATH "BIN\css" -Force

# copying site items
Copy-Item "IMG\*" -Destination "BIN\img" -Force
Copy-Item "css\*" -Destination "BIN\css" -Force
Copy-Item "favicon.ico" -Destination "BIN\favicon.ico" -Force

# replace all items for Dutch.
foreach ($item in $nl_items) {
    $path = "BIN\nl\"  + $item.Name;
    $content = Get-Content -Path $item -Raw
    $newContent = $template -replace "{{Content}}" , $content
    $newContent = $newContent -replace "{{Name}}", $item.Name
    New-Item -Path $path -Value $newContent -Force
}

# replace all items for English.
foreach ($item in $en_items) {
    $path = "BIN\en\"  + $item.Name;
    $content = Get-Content -Path $item -Raw
    $newContent = $template -replace "{{Content}}" , $content
    $newContent = $newContent -replace "{{Name}}", $item.Name
    New-Item -Path $path -Value $newContent -Force
}

# create index html (Dutch)
$content = Get-Content -Path "BIN\nl\index.html" -Raw
# replace all ../ in the index.html
$newContent = $content -replace "\.\.\/", ""
New-item "BIN\index.html" -Value $newContent -Force