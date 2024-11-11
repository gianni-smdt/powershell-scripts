#Import necessary libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

#Import the AD module
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
$form.Text = "Retrieve Computer DN"
$form.Size = New-Object System.Drawing.Size(620,110)
$form.StartPosition = "CenterScreen"

#Label for the computer name
$labelSearch = New-Object System.Windows.Forms.Label
$labelSearch.Text = "Computer name:"
$labelSearch.Location = New-Object System.Drawing.Point(10, 10)
$labelSearch.Size = New-Object System.Drawing.Size(90, 20)
$form.Controls.Add($labelSearch)

#TextBox to enter a computer name
$textBoxSearch = New-Object System.Windows.Forms.TextBox
$textBoxSearch.Location = New-Object System.Drawing.Point(100,10)
$textBoxSearch.Size = New-Object System.Drawing.Size(210,20)
$form.Controls.Add($textBoxSearch)

#Button to search the specified computer
$buttonSearch = New-Object System.Windows.Forms.Button
$buttonSearch.Text = "Suchen"
$buttonSearch.Location = New-Object System.Drawing.Point(320, 10)
$buttonSearch.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($buttonSearch)
$buttonSearch.Add_Click({
    $computerName = $textBoxSearch.Text
    if (-not [string]::IsNullOrWhiteSpace($computerName)) {
        $computer = Get-ADComputer -Identity $computerName -Properties DistinguishedName
        if ($computer) {
            $textBoxOU.Text = $computer.DistinguishedName
        } else {
            [System.Windows.Forms.MessageBox]::Show("The computer you entered could not be found.`n`nPlease ensure that the name is correct.", "Retrieve Computer DN", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a computer name.", "Retrieve Computer DN", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }
})

#Label for the DN
$labelDN = New-Object System.Windows.Forms.Label
$labelDN.Text = "DN:"
$labelDN.Location = New-Object System.Drawing.Point(10, 40)
$labelDN.Size = New-Object System.Drawing.Size(30, 20)
$form.Controls.Add($labelDN)

#Textbox to display the DN of the specified computer
$textBoxDN = New-Object System.Windows.Forms.TextBox
$textBoxDN.Location = New-Object System.Drawing.Point(40,40)
$textBoxDN.Size = New-Object System.Drawing.Size(550,40)
$textBoxDN.Enabled = $false
$form.Controls.Add($textBoxDN)

$form.ShowDialog()
