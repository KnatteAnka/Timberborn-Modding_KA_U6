# Parameters with old and new GUID see : https://docs.google.com/spreadsheets/d/1f40vsabQAapOyAWYaY3yNB9oRH8WzcMhXIWf4NesKlo/edit?gid=2034175877#gid=2034175877


$OldGUID = @('PrefabGroupSpec','Id','Paths')
$NewGUID = @('TemplateCollectionSpec','CollectionId','Blueprints')

# ------------------ Real code below ------------------------

$FileSufixMaterial = ".\*.json"
$DirMaterialsToFix=$PSScriptRoot



& $PSScriptRoot\MassFixer.ps1 $DirMaterialsToFix $OldGUID $NewGUID $FileSufixMaterial