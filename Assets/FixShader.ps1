# Parameters with old and new GUID see : https://docs.google.com/spreadsheets/d/1f40vsabQAapOyAWYaY3yNB9oRH8WzcMhXIWf4NesKlo/edit?gid=2034175877#gid=2034175877


$OldGUID = @("m_Shader: {fileID: 4800000, guid: 35f36bb365f79ca4e89792767c32279a, type: 3}","m_Shader: {fileID: 4800000, guid: 61b8a3d0e50058145afac06a1f978d96, type: 3}")
$NewGUID = @("m_Shader: {fileID: -6465566751694194690, guid: f8dcdce8e5ef2d4439f9bd03d694655f, type: 3}","m_Shader: {fileID: -6465566751694194690, guid: f8dcdce8e5ef2d4439f9bd03d694655f, type: 3}")

# ------------------ Real code below ------------------------

$FileSufixMaterial = ".\*.mat"
$DirMaterialsToFix=$null



& $PSScriptRoot\MassFixer.ps1 $DirMaterialsToFix $OldGUID $NewGUID $FileSufixMaterial