echo off
cd Specifications
cls
:Init
set /P Menyitem="MG category to add: "
mkdir %Menyitem%
set /P DevmodeEn="Disable DevMode(Y/N): "

Echo ------------------------------------------------------------------------------------
echo {>Base.json

if /I %DevmodeEn% == Y (
	echo    "GroupId": "Subgroup_%Menyitem%",>>Base.json
	echo    "DevMode": "false">>Base.json
)else (
	echo    "GroupId": "Subgroup_%Menyitem%">>Base.json
)
echo }>>Base.json

Echo ------------------------------------------------------------------------------------

set Prefix=ToolSpecification.
set Suffix=.optional.json

echo Faction to Create?
set /P Faction="[B]oth Folktails and Ironteeth, [N]one  or Exact: "

:start
Echo ------------------------------------------------------------------------------------
set /P Question="Prefab name? (n to close,r to restart)"
rem echo on
if /I %Question% == N (
 	exit
 )
if /I %Question% == R (
 	goto Init
 )
rem @echo on
if /I %Faction% == B (
	echo Copying: Base.json to %Prefix%%Question%.IronTeeth%Suffix%
	copy "Base.json" "%Menyitem%\%Prefix%%Question%.IronTeeth%Suffix%"
	
	echo Copying: Base.json to %Prefix%%Question%.Folktails%Suffix%
	copy "Base.json" "%Menyitem%\%Prefix%%Question%.Folktails%Suffix%"
)else if /I %Faction% == N (
	echo Copying: Base.json to %Prefix%%Question%%Suffix%
	copy "Base.json" "%Menyitem%\%Prefix%%Question%%Suffix%"
)else (
	echo Copying: Base.json to %Prefix%%Question%.%Faction%%Suffix%
	copy "Base.json" "%Menyitem%\%Prefix%%Question%.%Faction%%Suffix%"
)
rem @echo off
echo -------------------------------------------------------------


goto start:
