# window on windows build script
#check if in the scripts focler, if so, move up a directory
if ((Get-Location).Path -like "*\scripts") {
    Set-Location ..
}
Write-Output "Building the game for windows..."

# download the lov2D instacne
$loveDownload = "$env:tmp\love-11.4-win64.zip"
Invoke-WebRequest -Uri "https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip" -OutFile $loveDownload

#extract it
Expand-Archive -Path $loveDownload -DestinationPath "$env:tmp\love"

mkdir build 2> $null
#compress the game files into a zip
remove-item "build\Zero Percent Juice.zip" -ErrorAction Ignore # remove the old zip if it exists
remove-item "build\Zero Percent Juice.love" -ErrorAction Ignore
remove-item "build\Zero Percent Juice.exe" -ErrorAction Ignore
remove-item "build\*.dll" -ErrorAction Ignore
Start-Sleep 1 
# Copy-Item -Path "*" -Destination "build/tmp/" -Include "*.lua", "*.json", "*.png", "*.ttf" -Recurse
# Get-ChildItem -Path "*" -Include "*.lua", "*.json", "*.png", "*.ttf" -Recurse | Compress-Archive -DestinationPath "build\Zero Percent Juice.zip"

$wd = (Get-Location).Path
$basePath = $wd
if (!$basePath.EndsWith("\")) { $basePath += "\" }
$zip = [System.IO.Compression.ZipFile]::Open("build\Zero Percent Juice.zip", "Create")
Get-ChildItem -Path $wd -Include "*.lua", "*.json", "*.png", "*.ttf" -Recurse | ForEach-Object {
    # Calculate the relative path to keep the folder structure
    $relativePath = $_.FullName.Replace($basePath, "")
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relativePath)
}
$zip.Dispose()

#rename the zip to .love
Set-Location build
Rename-Item "Zero Percent Juice.zip" "Zero Percent Juice.love"
Set-Location ..

# create the final edxecuable 
write-output "Creating the executable... This may take some time"
Get-Content "$env:tmp\love\love-11.4-win64\love.exe","build\Zero Percent Juice.love" -Encoding Byte | Set-Content "build\Zero Percent Juice.exe" -Encoding Byte
#copy the dlls
Copy-Item "$env:tmp\love\love-11.4-win64\*.dll" -Destination "build"

#cleanup
Remove-Item $loveDownload
Remove-Item "$env:tmp\love" -Recurse

write-output "Done, executbale written to build\Zero Percent Juice.exe  Make sure you include the Dlls with the releases"