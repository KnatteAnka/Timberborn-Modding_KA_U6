#How to create Spec files:
* Open Templetecollection of a mod or game item to edit
* Update the Input.csv with blueprint lines
* set ToolGroupID and Toolorder (empty to not edit)
* Set faction if specific faction or leave blank if create factions defined in the Powershell file

* Run CreateToolsSpecs.ps1

* it then create files needed in an underfolder called Blueprints skips any that has no changes to them