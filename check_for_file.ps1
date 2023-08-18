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

# NEW SCRIPT

param (
    [string]$folderNamesDir,
    [string]$jobFilesDir
)

# Read folder names from the input text file
$folderNames = Get-Content -Path $folderNamesDir

foreach ($folderName in $folderNames) {
    $folderPath = Join-Path -Path $jobFilesDir -ChildPath $folderName

    if (Test-Path -Path $folderPath -PathType Container) {
        Write-Host "Folder '$folderName' already exists."

        $subfolders = @("input", "output", "history")

        foreach ($subfolder in $subfolders) {
            $subfolderPath = Join-Path -Path $folderPath -ChildPath $subfolder

            if (-not (Test-Path -Path $subfolderPath -PathType Container)) {
                New-Item -Path $subfolderPath -ItemType Directory
                Write-Host "Subfolder '$subfolder' created in '$folderName'."
            } else {
                Write-Host "Subfolder '$subfolder' already exists in '$folderName'."
            }
        }
    } else {
        New-Item -Path $folderPath -ItemType Directory
        Write-Host "Folder '$folderName' created."

        $subfolders = @("input", "output", "history")

        foreach ($subfolder in $subfolders) {
            $subfolderPath = Join-Path -Path $folderPath -ChildPath $subfolder
            New-Item -Path $subfolderPath -ItemType Directory
            Write-Host "Subfolder '$subfolder' created in '$folderName'."
        }
    }
}

Write-Host "Folder creation process completed."

# ./mkdir_folders.ps1 -folderNamesDir "/Users/sylvesteryiadom/Desktop/folder_names.txt" -jobFilesDir "/Users/sylvesteryiadom/Desktop/input"

# GET FOLDER NAMES SCRIPT

# Path to the directory containing the folders
$directoryPath = "~/Desktop/allfolder"

# Path to the text file where folder names will be written
$outputFilePath = "~/Desktop/folder_names.txt"

# Get a list of folder names in the directory
$folderNames = Get-ChildItem -Path $directoryPath -Directory | Select-Object -ExpandProperty Name

# Write the folder names to the output text file
$folderNames | Out-File -FilePath $outputFilePath

Write-Host "Folder names have been copied to $outputFilePath"

