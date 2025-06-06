For help with mods see https://discord.com/channels/558398674389172225/1064824959697944666/1064988131545317427

# Getting started to Mod the game:

There is some types of mods:
* Asset Mods
* Code Mods
* Combined Mods
* Config Mods

Game now has official mod support see: https://github.com/mechanistry/timberborn-modding


## Asset Mods:
These are often also called codeless mods, This is because they add assets(buildings) to the game without any need of c# code all is done in Unity and text editor of Specifications. 
So in a nutshell we reuse base functionality in a new way or new parameters
To create model any 3d program can be used to create a base 
but then Blender is recomended with timbermesh plugin to not have to include base game materials in your mod
**Example:** Staircase mod
**For more info see: ** https://discord.com/channels/558398674389172225/1042573456732082206
**Text guide:**(U5) https://t.ly/RIzqN
**Video Guide:** [Youtube Series](https://www.youtube.com/playlist?list=PLCSAr-ZkwfVQZlUN_m3gCRqljfAKUCPpo)

## Code Mods
These are mods that change how the game behave in the background or GUI without adding any new buildings
**Example:** SimpleFloodgateTriggers
**For more info see:** https://timberapi.com/
**Or check source code of other mods**

## Combined mods
These are mods that add assets but also use Code
**Example:** Ladder, Choo choo and more
to get started read up on the 2 above just that any script placed inside the modfolder of Assets mods will be compiled and entry dll have to be linked to in the mod.json

Publicizing of code is now handled by official mod tools
old Publicizing of code method: https://discord.com/channels/558398674389172225/888491376143134760/1152584823802708068

## Config Mods:
These are mods that just add config files to edit how the game behave
**Example:** Realistic behaviour
look at https://mod.io/g/timberborn/m/more-groups
and https://timberapi.com/tool_groups/

# Extra tools and fixes and tips

## Export exising game files:
**Text guide:**(U5) https://t.ly/RIzqN
**Video Guide:** https://youtu.be/FwPBRgJs5Gk

## Usefull links:
Community Wiki: https://timberborn.wiki.gg/wiki/Creating_Mods_(Update_6)
Theapologist316 guide: https://datvm.github.io/TimberbornMods/ModdingGuide/ and https://discord.com/channels/558398674389172225/1361178829078659193

## Framerate for mecanical rotation
Rotation looks to be 104 frames for one mecanical rotation

## Fix Blank textures/materials
 Official mod tool does not handle ripped assets so you need to disable urp:
 https://discord.com/channels/558398674389172225/888491376143134760/1268958098018537472

## Mod: TImprove 4 Modders
Good tool that gives some help with mod sorting and helps with mod upload as it sorts disabled mods last when uploading
https://discord.com/channels/558398674389172225/1346064915852689408

## Python: TBCopy-Rename
Tool to rename files and its internal example create Ironteeth version from folktails
https://discord.com/channels/558398674389172225/888491376143134760/1293106519071522819

## Mass replace GUIDS
When game updates some components may break and best way is to replace the guids so the content of the component is retained
this can be done with any notepad and replace 
see this for a list of guids: https://docs.google.com/spreadsheets/d/1f40vsabQAapOyAWYaY3yNB9oRH8WzcMhXIWf4NesKlo/edit?gid=0#gid=0
there is filter views for different versions of the game, do request write permission if you want to add more guids

to find broken components GUID:s i duplicate the prefab
Edit the duplicate and remove the broken component and add the correct one
now open both and compare the files and find the row thats changed with guid

or you may use my Massfixer powershell script
https://github.com/KnatteAnka/Timberborn-Modding_KA_U6/blob/main/Assets/MassFixer.ps1
What this does is it has 2 arrays created in the google doc that tells it what to search for and what to replace it with
Usage:
* if needed update the 2 variables at the top of the code to get the latest list from the google doc
* Run the powershell script
* Select a folder and it will check each prefab in there and its subfolders
* Check prefabs and see if there is any component still broken for example some may need special care to fix
Example U7 Path nav mesh need add tab to array of paths

## Update of the base game
example going from U6-U7
1. Update Official Mod package (guide for package install if manual install download a new download)
* Open Package manager
* Select the Timberborn Modding Tools and press update
2. Remove the Plugins/Timberborn folder then Import Dll Files
3. Fix any broken scripts see **Mass replace GUIDS**
also see this: https://youtu.be/_VL-mzWdqwM

## Placeholder materials
To get smaller mods when using base game materials dummy materials may be used.
this is a one color material thats smaller in size as Timbermesh reference the name not the material in the Timbermesh
Placeholders as of 2025-04-27:
[PlaceholderMaterialPackage](https://github.com/KnatteAnka/Timberborn-Modding_KA_U6/blob/main/Assets/All_Material/Resources/Placeholders.unitypackage)

# Update 7 info:

* Specification folder is now called Blueprints
* Blueprints has a new header info in each file, Check base game for the correct header
* A lot of Components has broken with this update and 
Path nav mesh need to be fixed some manually as the array is deeper in so add a Tab


# Update 6 info:
1. Building model Spec now uses text fields instead of links
2. Labled Entity Spec replaces component that holds Displayname and Loc key
3. Some Componet for paths is replaced and use instead Path and Block object with path range but check an existing building in base game to find differance.
4. Particle Connection way changed check base game item to use the same or as reference

## Components
1.  Block object updated with new options
  Batch Change them with Text editor, convertion to be tested: https://discord.com/channels/558398674389172225/888491376143134760/1258322890613461075
2. Removed subtoolgroup support (TAPI addon?)
3. Timbermesh description instead of meshy description (example construction site)
4. Enterable replaced with Enterable Specification with more settings.
5. Water blockage components changed

## Other changes
1. Spec file updated format
2. Folderview updated
3. Location file do not allow empty lines anymore
7. Materials have to be under a Resources folder
8. When doing asset ripper remove Plugins and monobehavior to not get errors.´
