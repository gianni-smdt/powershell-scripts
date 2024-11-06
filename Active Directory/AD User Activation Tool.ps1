#Import necessary libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

#Import AD module
Import-Module ActiveDirectory

#Function to hide the PowerShell window (C#)
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
$form.Text = "AD User Activation Tool"
$form.Size = New-Object System.Drawing.Size(427,170)
$form.StartPosition = "CenterScreen"

#TextBox to specify a user (user name)
$textBoxSearch = New-Object System.Windows.Forms.TextBox
$textBoxSearch.Location = New-Object System.Drawing.Point(10,10)
$textBoxSearch.Size = New-Object System.Drawing.Size(170,20)
$form.Controls.Add($textBoxSearch)

#Button to search the specified user
$buttonSearch = New-Object System.Windows.Forms.Button
$buttonSearch.Text = "Search"
$buttonSearch.Location = New-Object System.Drawing.Point(190, 10)
$buttonSearch.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($buttonSearch)
$buttonSearch.Add_Click({
    #Get user name from the TextBox
    $userName = $textBoxSearch.Text

    #Ensure the user name is not empty
    if (-not [string]::IsNullOrWhiteSpace($userName)) {

        #Search user in AD
        $user = Get-ADUser -Identity $userName -Properties OperatingSystem, Description, Enabled
            
        #Check if the user account was found
        if ($user) {
            #Display information in the TextBoxes
            $textBoxName.Text = "$($user.GivenName) $($user.Surname)"
            $textBoxDescription.Text = $user.Description
            if($user.Enabled){
                $textBoxStatus.Text = "Enabled"
                $buttonUnlock.Enabled = $false
            } else {
                $textBoxStatus.Text = "Disabled"
                $buttonUnlock.Enabled = $true
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("The user you entered could not be found.`n`nPlease make sure that the user name is correct.", "AD User Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a user name before proceeding.", "AD User Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
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
    $textBoxName.Clear()
    $textBoxDescription.Clear()

    $buttonUnlock.Enabled = $false
})

#Label for the status box
$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Text = "Status:"
$labelStatus.Location = New-Object System.Drawing.Point(10, 100)
$labelStatus.Size = New-Object System.Drawing.Size(70, 20)
$form.Controls.Add($labelStatus)

#TextBox to display the current status
$textBoxStatus = New-Object System.Windows.Forms.TextBox
$textBoxStatus.Location = New-Object System.Drawing.Point(80, 100)
$textBoxStatus.Size = New-Object System.Drawing.Size(230, 20)
$textBoxStatus.Enabled = $false
$form.Controls.Add($textBoxStatus)

#Label for the description box
$labelDescription = New-Object System.Windows.Forms.Label
$labelDescription.Text = "Description:"
$labelDescription.Location = New-Object System.Drawing.Point(10, 70)
$labelDescription.Size = New-Object System.Drawing.Size(70, 20)
$form.Controls.Add($labelDescription)

#TextBox to display the description
$textBoxDescription = New-Object System.Windows.Forms.TextBox
$textBoxDescription.Location = New-Object System.Drawing.Point(80, 70)
$textBoxDescription.Size = New-Object System.Drawing.Size(230, 20)
$textBoxDescription.Enabled = $false
$form.Controls.Add($textBoxDescription)

#Label for the name
$labelName = New-Object System.Windows.Forms.Label
$labelName.Text = "Name:"
$labelName.Location = New-Object System.Drawing.Point(10, 40)
$labelName.Size = New-Object System.Drawing.Size(70, 20)
$form.Controls.Add($labelName)

#TextBox to display the name
$textBoxName = New-Object System.Windows.Forms.TextBox
$textBoxName.Location = New-Object System.Drawing.Point(80, 40)
$textBoxName.Size = New-Object System.Drawing.Size(230, 20)
$textBoxName.Enabled = $false
$form.Controls.Add($textBoxName)

#Button to unlock the user
$buttonUnlock = New-Object System.Windows.forms.Button
$buttonUnlock.Text = "Enable User"
$buttonUnlock.Location = New-Object System.Drawing.Point(320, 40)
$buttonUnlock.Size = New-Object System.Drawing.Size(80, 79)
$buttonUnlock.Enabled = $false
$form.Controls.Add($buttonUnlock) 
$buttonUnlock.Add_Click({
    $computerName = $textBoxSearch.Text
    try {
        #Enable the user account
        Set-ADComputer -Identity $computerName -Enabled $true
        [System.Windows.Forms.MessageBox]::Show("The user account '$computerName' was successfully enabled.", "AD User Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred while enabling the user account:`n`n$_", "AD User Activation Tool", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }
})

$form.ShowDialog()
