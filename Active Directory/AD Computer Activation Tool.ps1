<#
.SYNOPSIS
    Retrieves information of a specified computer from Active Directory (AD) and enables account activation.
    
.DESCRIPTION
    This script accepts a computer name and displays the operating system (OS) as well as the description of 
    the computer. It also shows whether the specified computer is active or disabled in AD. If the computer is 
    disabled, a button allows its activation of the computer.

.NOTES
    2024, Gianni Schmidt
#>

#Import necessary libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

#Import AD module
Import-Module ActiveDirectory

#Hide the PowerShell window (C#)
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class User {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
$HWND = $([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
[void][User]::ShowWindow($HWND, 0)  

#Create the main window
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD Computer Activation Tool"
$form.Size = New-Object System.Drawing.Size(427,170)
$form.StartPosition = "CenterScreen"

#TextBox to specify a computer by its name
$textBoxSearch = New-Object System.Windows.Forms.TextBox
$textBoxSearch.Location = New-Object System.Drawing.Point(10,10)
$textBoxSearch.Size = New-Object System.Drawing.Size(170,20)
$form.Controls.Add($textBoxSearch)

#Button to search the specified computer
$buttonSearch = New-Object System.Windows.Forms.Button
$buttonSearch.Text = "Search"
$buttonSearch.Location = New-Object System.Drawing.Point(190, 10)
$buttonSearch.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($buttonSearch)
$buttonSearch.Add_Click({
    #Get computer name from the TextBox
    $computerName = $textBoxSearch.Text

    #Ensure the computer name is not empty
    if (-not [string]::IsNullOrWhiteSpace($computerName)) {

        #Search computer in AD
        $computer = Get-ADComputer -Identity $computerName -Properties OperatingSystem, Description, Enabled
            
        #Check if the computer account was found
        if ($computer) {
            #Display information in the TextBoxes
            $textBoxOS.Text = $computer.OperatingSystem
            $textBoxDescription.Text = $computer.Description
            if($computer.Enabled){
                $textBoxStatus.Text = "Enabled"
                $buttonUnlock.Enabled = $false
            } else {
                $textBoxStatus.Text = "Disabled"
                $buttonUnlock.Enabled = $true
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("The computer you entered could not be found.`n`nPlease make sure that the computer name is correct.", "AD Computer Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a computer name before proceeding.", "AD Computer Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }
})

#Button to clear the entry
$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "Clear Entry"
$buttonClear.Location = New-Object System.Drawing.Point(300, 10)
$buttonClear.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($buttonClear)
$buttonClear.Add_Click({
    $textBoxSearch.Clear()
    $textBoxStatus.Clear()
    $textBoxOS.Clear()
    $textBoxDescription.Clear()

    $buttonUnlock.Enabled = $false
})

#Label for the status box
$labelType = New-Object System.Windows.Forms.Label
$labelType.Text = "Status:"
$labelType.Location = New-Object System.Drawing.Point(10, 100)
$labelType.Size = New-Object System.Drawing.Size(90, 20)
$form.Controls.Add($labelType)

#TextBox to display the current status
$textBoxStatus = New-Object System.Windows.Forms.TextBox
$textBoxStatus.Location = New-Object System.Drawing.Point(110, 100)
$textBoxStatus.Size = New-Object System.Drawing.Size(200, 20)
$textBoxStatus.Enabled = $false
$form.Controls.Add($textBoxStatus)

#Label for the description box
$labelDescription = New-Object System.Windows.Forms.Label
$labelDescription.Text = "Description:"
$labelDescription.Location = New-Object System.Drawing.Point(10, 70)
$labelDescription.Size = New-Object System.Drawing.Size(90, 20)
$form.Controls.Add($labelDescription)

#TextBox to display the description
$textBoxDescription = New-Object System.Windows.Forms.TextBox
$textBoxDescription.Location = New-Object System.Drawing.Point(110, 70)
$textBoxDescription.Size = New-Object System.Drawing.Size(200, 20)
$textBoxDescription.Enabled = $false
$form.Controls.Add($textBoxDescription)

#Label for the OS
$labelOS = New-Object System.Windows.Forms.Label
$labelOS.Text = "Operating System:"
$labelOS.Location = New-Object System.Drawing.Point(10, 40)
$labelOS.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($labelOS)

#TextBox to display the current OS
$textBoxOS = New-Object System.Windows.Forms.TextBox
$textBoxOS.Location = New-Object System.Drawing.Point(110, 40)
$textBoxOS.Size = New-Object System.Drawing.Size(200, 20)
$textBoxOS.Enabled = $false
$form.Controls.Add($textBoxOS)

#Button to unlock the computer
$buttonUnlock = New-Object System.Windows.forms.Button
$buttonUnlock.Text = "Enable PC"
$buttonUnlock.Location = New-Object System.Drawing.Point(320, 40)
$buttonUnlock.Size = New-Object System.Drawing.Size(80, 79)
$buttonUnlock.Enabled = $false
$form.Controls.Add($buttonUnlock) 
$buttonUnlock.Add_Click({
    $computerName = $textBoxSearch.Text
    try {
        #Enable the computer account
        Set-ADComputer -Identity $computerName -Enabled $true
        [System.Windows.Forms.MessageBox]::Show("The computer account '$computerName' was successfully enabled.", "AD Computer Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred while enabling the computer account:`n`n$_", "AD Computer Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }
})

$form.ShowDialog()
