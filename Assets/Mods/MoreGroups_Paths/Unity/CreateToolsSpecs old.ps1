# --- PowerShell Script to Generate Nested JSON Blueprint Files in a Subfolder ---

# 1. Configuration Parameters
# -----------------------------

# Define the path to your input CSV file
$inputCSVPath = ".\Input.csv"

# Define the array of factions to use when the 'Faction(empty for All)' column is empty.
$defaultFactions = @("Folktails", "IronTeeth") #,"Emberpelts"

# Define the file suffix/extension for the resulting files.
$outputFileSuffix = ".optional.blueprint.json"

# Define the *base* output folder name. The rest of the path comes from Prefabname.
$outputFolderName = "Blueprints"


# 2. Main Logic Function
# ------------------------

function Convert-CsvToBlueprintJson {
    param(
        [Parameter(Mandatory=$true)]
        [string]$CsvPath,
        [Parameter(Mandatory=$true)]
        [string[]]$DefaultFactions,
        [Parameter(Mandatory=$true)]
        [string]$FileSuffix,
        [Parameter(Mandatory=$true)]
        [string]$OutputBaseFolder
    )
    cls
    Write-Host "Starting conversion process with dynamic path extraction..."
    Write-Host "Input File: $CsvPath"
    Write-Host "Base Output Folder: $OutputBaseFolder"
    Write-Host "---"

    # Import the CSV data
    try {
        $data = Import-Csv -Path $CsvPath
    } catch {
        Write-Error "Could not read the CSV file at '$CsvPath'. Error: $($_.Exception.Message)"
        return
    }

    foreach ($row in $data) {
        # --- A. Determine Prefixes and Path ---
        $prefabNameFull = $row.Prefabname # e.g., Buildings/Paths/DoublePlatform/DoublePlatform.Folktails.blueprint

        if ([string]::IsNullOrWhiteSpace($prefabNameFull)) {
            continue
        }

        # 1. Extract the full directory path (everything before the last '/')
        $prefabDirectory = Split-Path -Path $prefabNameFull -Parent 
        # Result: Buildings/Paths/DoublePlatform

        # 2. Extract the file name part (everything after the last '/')
        $prefabFileNameWithExtension = Split-Path -Path $prefabNameFull -Leaf
        # Result: DoublePlatform.Folktails.blueprint
        
        # 3. Get the file prefix (name before the first '.' in the file name part)

        #Things to check
        #Blueprint last?
        #Faction?
        #Totalarray to use?

        $SplitPrefabname = $prefabFileNameWithExtension -split '\.'
        $SplitPrefabnameLen = $SplitPrefabname.Length-1

        $LastSplit = $SplitPrefabname[$SplitPrefabnameLen]
        if ($LastSplit -eq "blueprint"){
            $SplitPrefabname = $SplitPrefabname[0..($SplitPrefabname.Length-2)]
            $SplitPrefabnameLen = $SplitPrefabname.Length-1
        }

        #$prefabPrefix = ($prefabFileNameWithExtension -split '\.')[0]
		#$HasFaction = ($prefabFileNameWithExtension -split '\.')[1]
        #$HasFaction = $SplitPrefabname[$SplitPrefabnameLen]

        if ($SplitPrefabnameLen -gt 1){
            $prefabPrefix = $SplitPrefabname[0]+"."+$SplitPrefabname[1]
        }else{
            $prefabPrefix = $SplitPrefabname[0]
        }

        
        # Result: DoublePlatform

        # 4. Construct the final target directory
        # Combines the base folder (Blueprints) with the extracted directory path.
        $targetDirectory = Join-Path -Path $OutputBaseFolder -ChildPath $prefabDirectory
        # Result: Blueprints\Buildings\Paths\DoublePlatform

        # --- B. Determine Factions to Process ---
        $factionsToProcess = @()
        $rowFaction = $row."Faction(empty for All)"
        
        if ([string]::IsNullOrWhiteSpace($rowFaction)) {
            $factionsToProcess = $DefaultFactions
        } else {
            $factionsToProcess = $rowFaction.Split(',') | ForEach-Object { $_.Trim() }
        }

        if ($SplitPrefabnameLen -le 0){ #if input has not faction output should not ether
            $factionsToProcess = @("")
        }
				#Write-Host "Full: $prefabNameFull Prefix: $prefabPrefix"

        # --- C. Iterate Factions and Create Files ---
        foreach ($faction in $factionsToProcess) {
            
            # 1. Initialize Objects and Conditionally Add Properties (No change here)
            $nestedSpec = [ordered]@{}
            
            $toolGroupId = $row.ToolGroupId
            if (-not [string]::IsNullOrWhiteSpace($toolGroupId)) {
                $nestedSpec.ToolGroupId = $toolGroupId
            }
            $Devmode = $row.Devmode
            if (-not [string]::IsNullOrWhiteSpace($Devmode)) {
                try {
                    $Devmode = [bool]::Parse($Devmode)
                    $nestedSpec.DevModeTool = $Devmode
                } catch {
                    Write-Warning "Devmode value '$Devmode' for '$prefabNameFull' is not a valid boolean. Skipping property."
                }
            }

            $toolOrder = $row.ToolOrder
            if (-not [string]::IsNullOrWhiteSpace($toolOrder)) {
                try {
                    $nestedSpec.ToolOrder = [int]$toolOrder
                } catch {
                    Write-Warning "ToolOrder value '$toolOrder' for '$prefabNameFull' is not a valid integer. Skipping property."
                }
            }

            $outputObject = [ordered]@{
                #PrefabName = $prefabNameFull
            }
            
            if ($nestedSpec.Count -gt 0) {
                $outputObject.PlaceableBlockObjectSpec = $nestedSpec
            }
            
            # 2. Ensure the full path exists
            if (-not (Test-Path -Path $targetDirectory)) {
                Write-Host "Creating directory: $targetDirectory" -ForegroundColor Yellow
                New-Item -Path $targetDirectory -ItemType Directory | Out-Null
            }
            
            # 3. Determine Output File Path and Save
            # Output file name uses the extracted prefix + faction + suffix
            $outputFileName = "$prefabPrefix.$faction$FileSuffix"
            
            if([string]::IsNullOrWhiteSpace($faction)){
              $outputFileName = "$prefabPrefix$FileSuffix"
            }

            # Joins the full target directory and the final file name
            $outputFilePath = Join-Path -Path $targetDirectory -ChildPath $outputFileName

            $outputJson = $outputObject | ConvertTo-Json -Depth 5 -Compress

            $outputJson | Out-File -FilePath $outputFilePath -Encoding UTF8

            Write-Host "--> Created file: $outputFilePath" -ForegroundColor Green
        }
    }

    Write-Host "---"
    Write-Host "Conversion complete."
}

# 3. Execute the Function
# -----------------------

Convert-CsvToBlueprintJson `
    -CsvPath $inputCSVPath `
    -DefaultFactions $defaultFactions `
    -FileSuffix $outputFileSuffix `
    -OutputBaseFolder $outputFolderName