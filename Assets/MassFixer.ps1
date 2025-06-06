param([String]$CurrentDir=$PSScriptRoot,[String[]] $OldGUIDImp,[String[]] $NewGUIDImp,[String[]] $FileSufixImp) 


# Parameters with old and new GUID see : https://docs.google.com/spreadsheets/d/1f40vsabQAapOyAWYaY3yNB9oRH8WzcMhXIWf4NesKlo/edit?gid=2034175877#gid=2034175877
$OldGUID = @("m_Script: {fileID: -1587067794, guid: 6db671ca2a10521151a0623ea7cc13c9, type: 3}","_connectableBlocks:","_connectableDirections:","m_Script: {fileID: -979173865, guid: a01d35f43886f4b46e413d3c2ea20811, type: 3}","_direction3D: 0","_direction3D: 2","_direction3D: ","_offset:")
$NewGUID = @("m_Script: {fileID: 808986059, guid: a01d35f43886f4b46e413d3c2ea20811, type: 3}","_transputSpecs:","_directions:","m_Script: {fileID: 808986059, guid: a01d35f43886f4b46e413d3c2ea20811, type: 3}","_directions: 1","_directions: 4","_directions: ","_coordinates:")


# ------------------ Real code below ------------------------
$FileSufix = ".\*.prefab"




Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
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

#$File=$args[0]
cls
Write-host -----------------------------------
Write-host -- Starting Mass replacer        --
Write-host -----------------------------------



if ($OldGUIDImp -ne $null){
    $OldGUID = $OldGUIDImp
    $NewGUID = $NewGUIDImp
    if ($FileSufixImp -ne $null){
     $FileSufix = $FileSufixImp
     }
    Write-Host External input
    #pause
}else{


    Write-Host Select folder
    #pause
    $Subfolders = Get-ChildItem -Path $CurrentDir
    Write-host -----------------------------------
    foreach ($Folders in $Subfolders){
    
        if ("$Folders" -ne "Mods") {
         #Write-Host --- !$Folders!
         continue
         }
         $CurrentDir = Join-Path -Path $CurrentDir -ChildPath $Folders
        Write-Host $Folders
        break
    }

    $CurrentDir = Get-Folder -initialDirectory $CurrentDir
}






Write-Host $CurrentDir
if ( $CurrentDir -eq -1){
 exit
 }

Write-Host $CurrentDir$FileSufix
Write-host -----------------------------------
#Get all prefabs inc subfolders

$FilesToCheck = Get-ChildItem -Path $CurrentDir$FileSufix -Recurse -Force
foreach ($CheckFile in $FilesToCheck){
    Write-Host $CheckFile    
    $content = [System.IO.File]::ReadAllText("$CheckFile")
    $Count = 0
    For ($Loop = 0; $Loop -lt $OldGUID.count ; $Loop++){
        $Found = $content.IndexOf($OldGUID[$Loop])
        if ($Found -ne -1) {
            $Count++
            Write-Host Old: $OldGUID[$Loop]
            Write-Host New: $NewGUID[$Loop]
        }
        $content = $content.Replace($OldGUID[$Loop],$NewGUID[$Loop])
        
    }
    [System.IO.File]::WriteAllText("$CheckFile", $content)
    
}
Write-host -----------------------------------
Write-Host --------------- Done --------------
Write-host -----------------------------------
pause
exit