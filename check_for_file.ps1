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

# Specify your bucket name
$bucketName = "your-bucket-name"

# Specify the target date in the format "YYYY-MM-DD"
$targetDate = "2023-09-26"

# List objects in the bucket
$objects = aws s3 ls s3://$bucketName

# Loop through the objects and download those with the target date
foreach ($object in $objects) {
    # Extract the object key and last modified date from the listing
    $objectKey = ($object -split '\s+')[3]
    $lastModified = ($object -split '\s+')[0, 1] -join ' '

    # Convert the last modified date to the desired format (YYYY-MM-DD)
    $formattedDate = Get-Date $lastModified -Format "yyyy-MM-dd"

    # Check if the date matches the target date
    if ($formattedDate -eq $targetDate) {
        # Download the object
        aws s3 cp "s3://$bucketName/$objectKey" "./$objectKey"
        Write-Host "Downloaded $objectKey"
    }
}



$failedJobs = kubectl get job -n batch -o custom-columns="JOB_NAME:.metadata.name,FAILED:.status.failed" --no-headers=true | Where-Object { $_.FAILED -ge 1 } | ForEach-Object { $_.JOB_NAME }


$failed = $(kubectl get job -o=jsonpath='{.items[?(@.status.failed>=1)].metadata.name}' -n batch).Split(' ')

# Check if $failed array is empty (no failed jobs found)
if ($failed.Count -eq 0) {
    Write-Host "Failure"
} else {
    $output = kubectl describe job -n batch $failed[0] | Out-String

    # Check if the "BackoffLimitExceeded" pattern is found in the output
    if ($output -match "\bBackoffLimitExceeded\b") {
        Write-Host "Success"
    } else {
        Write-Host "Failure"
    }
}
