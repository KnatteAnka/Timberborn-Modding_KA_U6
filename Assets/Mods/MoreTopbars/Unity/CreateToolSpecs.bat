echo off
U:
cd U:\TimberbornModding\UnityProjects\KA_U6\Assets\Mods\MoreTopbars\Unity
cd Specifications
cls
:Init
set /P Menyitem="MG category to add: "
mkdir %Menyitem%


Echo ------------------------------------------------------------------------------------
echo {>Base.json
echo   "GoodSpec": {>>Base.json

echo    "GoodGroupId": "%Menyitem%",>>Base.json


echo }>>Base.json
echo }>>Base.json

Echo ------------------------------------------------------------------------------------

set Prefix=Good.
set Suffix=.optional.json

echo Faction to Create?


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

echo Copying: Base.json to %Prefix%%Question%%Suffix%
copy "Base.json" "%Menyitem%\%Prefix%%Question%%Suffix%"

rem @echo off
echo -------------------------------------------------------------


goto start:
