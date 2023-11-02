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
# param (
#     [Parameter(Mandatory=$true)]
#     [string]$folderPath
# )

# # Check if the folder exists
# if (-not (Test-Path -Path $folderPath -PathType Container)) {
#     Write-Host "Input folder not found."
#     exit 1 # Failed exit code
# }

# # Get all items (files and folders) in the folder
# $items = Get-ChildItem -Path $folderPath

# # Check if any files were found (excluding folders)
# $fileCount = ($items | Where-Object { -not $_.PSIsContainer }).Count

# # Check if any files (excluding folders) were found
# if ($fileCount -gt 0) {
#     Write-Host "File(s) found in input folder."
#     exit 0 # Success exit code
# } else {
#     Write-Host "No files found in input folder."
#     exit 1 # Failed exit code
# }

# $directoryPath = "C:\path\to\directory"
# $largestFolder = Get-ChildItem -Path $directoryPath -Directory | ForEach-Object { $_.FullName + ": " + "{0:N2}" -f ((Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" } | Sort-Object -Property { [double]($_ -split ": ")[1] } -Descending | Select-Object -First 1
# Write-Host "The folder with the largest size is:" $largestFolder


# Get-ChildItem -Path "C:\path\to\directory" -Directory | ForEach-Object { $_.FullName + ": " + "{0:N2}" -f ((Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" }

# NEW SCRIPT

# Get-ChildItem -Path "C:\allfolders" -Directory | Select-Object -ExpandProperty Name | Out-File -FilePath "C:\folder_names.txt"


# param (
#     [string]$folderNamesDir,
#     [string]$jobFilesDir
# )

# # Read folder names from the input text file
# $folderNames = Get-Content -Path $folderNamesDir

# foreach ($folderName in $folderNames) {
#     $folderPath = Join-Path -Path $jobFilesDir -ChildPath $folderName

#     if (Test-Path -Path $folderPath -PathType Container) {
#         Write-Host "Folder '$folderName' already exists."

#         $subfolders = @("input", "output", "history")

#         foreach ($subfolder in $subfolders) {
#             $subfolderPath = Join-Path -Path $folderPath -ChildPath $subfolder

#             if (-not (Test-Path -Path $subfolderPath -PathType Container)) {
#                 New-Item -Path $subfolderPath -ItemType Directory
#                 Write-Host "Subfolder '$subfolder' created in '$folderName'."
#             } else {
#                 Write-Host "Subfolder '$subfolder' already exists in '$folderName'."
#             }
#         }
#     } else {
#         New-Item -Path $folderPath -ItemType Directory
#         Write-Host "Folder '$folderName' created."

#         $subfolders = @("input", "output", "history")

#         foreach ($subfolder in $subfolders) {
#             $subfolderPath = Join-Path -Path $folderPath -ChildPath $subfolder
#             New-Item -Path $subfolderPath -ItemType Directory
#             Write-Host "Subfolder '$subfolder' created in '$folderName'."
#         }
#     }
# }

# Write-Host "Folder creation process completed."

# ./mkdir_folders.ps1 -folderNamesDir "/Users/sylvesteryiadom/Desktop/folder_names.txt" -jobFilesDir "/Users/sylvesteryiadom/Desktop/input"

param (
    [string]$bucketName,
    [string]$targetDate
)

# Check if required parameters are provided
if (-not $bucketName -or -not $targetDate) {
    Write-Host "Usage: script.ps1 -bucketName <bucketName> -targetDate <targetDate>"
    exit
}

# Create a folder with the target date
$folderPath = Join-Path -Path $PSScriptRoot -ChildPath $targetDate
if (-not (Test-Path $folderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# List objects in the specified bucket
$objects = aws s3 ls s3://$bucketName

# Loop through the objects and download those with the target date into the folder
foreach ($object in $objects) {
    $parts = ($object -split '\s+')

    if ($parts.Length -ge 4) {
        $objectKey = $parts[3]
        $lastModified = $parts[0, 1] -join ' '
        
        try {
            $formattedDate = Get-Date $lastModified -Format "yyyy-MM-dd"
        }
        catch {
            Write-Host "Error parsing date for $objectKey. Skipping."
            continue
        }

        if ($formattedDate -eq $targetDate) {
            $localFilePath = Join-Path -Path $folderPath -ChildPath $objectKey
            aws s3 cp "s3://$bucketName/$objectKey" $localFilePath
            Write-Host "Downloaded $objectKey"
        }
    }
    else {
        Write-Host "Invalid line format: $object. Skipping."
    }
}





$failedJobs = kubectl get job -n batch -o custom-columns="JOB_NAME:.metadata.name,FAILED:.status.failed" --no-headers=true | Where-Object { $_.FAILED -ge 1 } | ForEach-Object { $_.JOB_NAME }


$failed = $(kubectl get job -o=jsonpath='{.items[?(@.status.failed>=1)].metadata.name}' -n batch).Split(' ')

# Check if $failed array is empty (no failed jobs found)
if ($failed.Count -eq 0) {
    exit 1  # Exit with code 1 for failure
} else {
    $output = kubectl describe job -n batch $failed[0] | Out-String

    # Check if the "BackoffLimitExceeded" pattern is found in the output
    if ($output -match "\bBackoffLimitExceeded\b") {
        exit 0  # Exit with code 0 for success
    } else {
        exit 1  # Exit with code 1 for failure
    }
}


Get-ChildItem -Path "C:\path\to\directory" -Directory | ForEach-Object { $_.FullName + ": " + "{0:N2}" -f ((Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) + " MB" }

$filteredJobs = kubectl get jobs --no-headers | Where-Object { $_ -like "*binb*" } | ForEach-Object { $_.Split()[0] }

$folderPath = "C:\Your\Folder\Path"; $intervalInSeconds = 60; while ($true) { if ((Get-ChildItem -Path $folderPath -File -Recurse).Count -gt 0) { Write-Host "Files are being written to the folder." } else { Write-Host "No new files detected." }; Start-Sleep -Seconds $intervalInSeconds }
