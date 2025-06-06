


# ------------------ Real code below ------------------------
$FileSufixRipped = ".\*.shader.Meta"
$FileSufix = ".\*.shadergraph.Meta"
$FileSufixMaterial = ".\*.mat"

Function Get-Folder($initialDirectory="",$Description_Header)

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $Description_Header
    if ($null -eq $Description_Header){
     $foldername.Description = "Select a folder"
     }
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory
    $Dialog = $foldername.ShowDialog()
    if($Dialog -eq "OK")
    {
        $folder += $foldername.SelectedPath
        return $folder
    }

    
    return -1
}
function Test-StringContents {
  param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$Phrase,
    [string[]]$TestingWords
  )
  process {
    $count = -1
    foreach ($test in $TestingWords) {
      $count++
      $Splitvar = $test -split ":"
      #Write-host Comparing: $Phrase.ToLower() with $test.ToLower()
      if ($Splitvar.ToLower() -eq $Phrase.ToLower()) {
        return $count
      }
    }
    return -1
  }
}

cls
Write-host -----------------------------------
Write-host -- Starting Shader Fix           --
Write-host -----------------------------------
$DirRippedShader = $PSScriptRoot #Get-Location

$DirRippedShader = "U:\TimberbornModding\UnityProjects\AssetRipper U7\Assets\Resources\Timberborn_U7.9\Resources\shaders"

$DirRippedShader = Get-Folder -initialDirectory $DirRippedShader -Description_Header "Select the folder where Exported Shader is`n Example Assets/Resources/Timberborn/Resources/Shaders"
$DirBaseShader = Get-Folder -initialDirectory $DirRippedShader -Description_Header "Select Basegame Shader folder`n Example Assets/Plugins/Shaders"
$DirMaterialsToFix = Get-Folder -initialDirectory $DirRippedShader -Description_Header "Select a folder that has materials to fix (or in subfolders)`n Example Assets/Resources/Timberborn/materials"

if ( $DirRippedShader -eq -1){
 exit
 }

if ( $DirBaseShader -eq -1){
 exit
 }

 if ( $DirMaterialsToFix -eq -1){
 exit
 }

#$DirRippedShader = "U:\TimberbornModding\UnityProjects\AssetRipper U7\Assets\Resources\Timberborn_U7.9\Resources\shaders"
#$DirBaseShader = "U:\TimberbornModding\UnityProjects\AssetRipper U7\Assets\Plugins\Shaders"

Write-Host $DirRippedShader$FileSufixRipped
Write-host -----------------------------------

$FilesToCheck = Get-ChildItem -Path $DirRippedShader$FileSufixRipped -Recurse -Force

$GUIList = New-Object System.Collections.Generic.List[System.Object]
Write-host ----------------------------------------------- Ripped Shaders ------------------------------------------------------------
foreach ($CheckFile in $FilesToCheck){
    #Write-host --------------File:---------------------   
    #Write-Host $CheckFile    
    
    $content = [System.IO.File]::ReadAllText("$CheckFile")

    $splitcont = $content -split ":"
    $Rippedguid = $splitcont[2] -split "\n"
    $Rippedguid = $Rippedguid[0]
    
    #Write-host -----------------------------------
    #Write-Host $content
    #Write-host -----------------------------------
    #Write-Host $splitcont[2]
    

    #$ShaderFileName = Split-Path $CheckFile -leaf
    $ShaderName = (Split-Path -Path $CheckFile -Leaf).Split(".")[0]
    
    Write-Host $ShaderName `t`t`t : $Rippedguid
    #Write-host -----------------------------------
    #Write-Host 

    $GUIList.add($ShaderName+":"+$Rippedguid+":")

    
}
##                                   Get Base game shader and match it with ripped shaders to compile a list of replacement guids
Write-host --------------------------------------------------------------------------------------------------------------------
Write-Host $DirBaseShader$FileSufix
Write-host -----------------------------------
$FilesToCheck = Get-ChildItem -Path $DirBaseShader$FileSufix -Recurse -Force

foreach ($CheckFile in $FilesToCheck){
    Write-host --------------File:---------------------   
    Write-Host $CheckFile    
    
    $content = [System.IO.File]::ReadAllText("$CheckFile")

    $splitcont = $content -split ": "
    $Baseguid = $splitcont[2] -split "\n"
    $Baseguid = $Baseguid[0]
    
    #Write-host -----------------------------------
    #Write-Host $content
    #Write-host -----------------------------------
    #Write-Host $splitcont[2]
    

    $ShaderName = (Split-Path $CheckFile -leaf).Split(".")[0]
    
    $index = Test-StringContents -Phrase $ShaderName -TestingWords $GUIList
    
    Write-Host $ShaderName  `t $index `t`t`t`t`t : $Baseguid 

    if ($index -ne -1){
        $GUIList[$index] += $Baseguid
    }

    #pause
}


Write-host --------------------------------------------------------------------------------------------------------------------
#pause
$OldList = New-Object System.Collections.Generic.List[System.Object]
$NewList = New-Object System.Collections.Generic.List[System.Object]
foreach ($Loop in $GUIList){
    
    $Row = $Loop -split ":"
    $Shadername = $Row[0]
    $Rippedguid = $Row[1]
    $BaseGUID = $Row[2]
    Write-host Shadername: $Shadername  Ripped_GUID: $Rippedguid Basegame_GUID: $BaseGUID
    Write-host -----------------------------------
    if ($Baseguid -ne ""){
        $OldList.Add($Rippedguid)
        $NewList.Add($Baseguid)
    }
}
Write-host ------------Old-----------------------
Write-Host $OldList
Write-host ------------New-----------------------
Write-Host $NewList

& $PSScriptRoot\MassFixer.ps1 $DirMaterialsToFix $OldList $NewList $FileSufixMaterial