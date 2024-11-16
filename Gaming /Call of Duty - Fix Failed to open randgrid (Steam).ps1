<#
.DESCRIPTION
    This script/command fixes the error "Failed to open \??\D:\SteamLibrary\steamapps\common\Call of Duty HQ\randgrid.sys".

.NOTES
    You have to start Windows PowerShell as administrator
#>

#Replace C:\ and D:\ with your specific drive letters
Move-Item -Path "C:\SteamLibrary\steamapps\common\Call of Duty HQ\randgrid.sys" -Destination "D:\SteamLibrary\steamapps\common\Call of Duty HQ\randgrid.sys"  
