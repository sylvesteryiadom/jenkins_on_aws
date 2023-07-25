# param (
#     [Parameter(Mandatory=$true)]
#     [string]$folderPath
# )

# # Check if the folder exists
# if (-not (Test-Path -Path $folderPath -PathType Container)) {
#     Write-Host "Input folder not found."
#     exit 1 # Failed exit code
# }

# # Get all text files in the folder
# $textFiles = Get-ChildItem -Path $folderPath -Filter "*.txt" -File

# # Check if any text files were found
# if ($textFiles.Count -gt 0) {
#     Write-Host "Text file(s) found in input folder."
#     exit 0 # Success exit code
# } else {
#     Write-Host "No text files found in input folder."
#     exit 1 # Failed exit code
# }
param (
    [Parameter(Mandatory=$true)]
    [string]$folderPath
)

# Check if the folder exists
if (-not (Test-Path -Path $folderPath -PathType Container)) {
    Write-Host "Input folder not found."
    exit 1 # Failed exit code
}

# Get all items (files and folders) in the folder
$items = Get-ChildItem -Path $folderPath

# Check if any files were found (excluding folders)
$fileCount = ($items | Where-Object { -not $_.PSIsContainer }).Count

# Check if any files (excluding folders) were found
if ($fileCount -gt 0) {
    Write-Host "File(s) found in input folder."
    exit 0 # Success exit code
} else {
    Write-Host "No files found in input folder."
    exit 1 # Failed exit code
}

# $directoryPath = "C:\path\to\directory"
# $largestFolder = Get-ChildItem -Path $directoryPath -Directory | ForEach-Object { $_.FullName + ": " + "{0:N2}" -f ((Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" } | Sort-Object -Property { [double]($_ -split ": ")[1] } -Descending | Select-Object -First 1
# Write-Host "The folder with the largest size is:" $largestFolder


# Get-ChildItem -Path "C:\path\to\directory" -Directory | ForEach-Object { $_.FullName + ": " + "{0:N2}" -f ((Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" }
