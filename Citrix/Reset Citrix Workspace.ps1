<#
.SYNOPSIS
    Resets the Citrix Workspace.

.DESCRIPTION
    This script resets the Citrix Workspace to its default configuration. 
    The script includes simple graphical interaction elements. 

.NOTES
    2024, Gianni Schmidt
#>

#Import the necessary library
Add-Type -AssemblyName PresentationFramework

#Show query window
$answer = [System.Windows.MessageBox]::Show("Do you really want to reset the Citrix Workspace?", "Reset Citrix Workspace", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Warning)

#Check if "Yes" was selected
if($answer -eq [System.Windows.MessageBoxResult]::Yes){
    try{
        #Start process
        $process = Start-Process -FilePath "C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\CleanUp.exe" -ArgumentList "-cleanUser" -NoNewWindow -PassThru

        #Message that the workspace is currently being reset
        [System.Windows.MessageBox]::Show("The Citrix Workspace is being reset.`n`nPlease wait a moment.", "Reset Citrix Workspace", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)

        #Waiting for process to complete
        $process.WaitForExit()

        #Message that the workspace has been successfully reset
        [System.Windows.MessageBox]::Show("The Citrix Workspace has been successfully reset.", "Reset Citrix Workspace", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        #Message if an error occured
        [System.Windows.MessageBox]::Show("During the reset of the Citrix Workspace, an error occurred:`n`n$_.Exception.Message", "Reset Citrix Workspace", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
} else {
    #Message if "No" was selected
    [System.Windows.MessageBox]::Show("The Citrix Workspace was not reset.", "Reset Citrix Workspace", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}
