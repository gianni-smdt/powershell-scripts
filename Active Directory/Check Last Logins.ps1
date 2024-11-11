<#
.SYNOPSIS
    Retrieves users from specific OUs and displays information regarding their login.

.DESCRIPTION
    This script retrieves all AD users within one or more OUs and displays their name, their last login date, 
    and their last password change date. Additionally, it marks certain users to indicate whether a password change is due.

.NOTES
    2024, Gianni Schmidt
#>

#Import all necessary libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Import the AD module
Import-Module ActiveDirectory

#Create the main window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Check Last Logins"
$form.Size = New-Object System.Drawing.Size(715, 570)
$form.StartPosition = "CenterScreen"

#Create and add the table 
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Size = New-Object System.Drawing.Size(680, 500)
$dataGridView.Location = New-Object System.Drawing.Point(10, 10)
$dataGridView.AutoSizeColumnsMode = 'Fill'
$dataGridView.ColumnHeadersHeightSizeMode = 'AutoSize'
$form.Controls.Add($dataGridView)

#Define the columns
$dataGridView.Columns.Add("Name", "Name")
$dataGridView.Columns.Add("LastLogonDate", "Last logged in")
$dataGridView.Columns.Add("PasswordLastSet", "Password last changed")
$dataGridView.Columns.Add("User_must_be_reset", "Must be reset")

#Center the content of the column "User_must_be_reset"
$dataGridView.Columns["User_must_be_reset"].DefaultCellStyle.Alignment = 'MiddleCenter'

#Retrieve and merge users from the OU(s)
$ouDN1 = "OU=Enter,DC=your,DC=OU,DC=here"
$ouDN2 = "OU=Enter,DC=your,DC=OU,DC=here"
$usersInOU1 = Get-ADUser -Filter * -SearchBase $ouDN1 -Properties LastLogonDate, PasswordLastSet
$usersInOU2 = Get-ADUser -Filter * -SearchBase $ouDN2 -Properties LastLogonDate, PasswordLastSet
<#You can add more OUs here#>

$combinedUsers = $usersInOU1 + $usersInOU2 #+other 

$sortedUsers = $combinedUsers | Sort-Object Name

$sortedUsers | ForEach-Object {
    #Process user data
    $user = $_
    $lastLogon = $user.LastLogonDate
    $passwordLastSet = $user.PasswordLastSet

    #Check if the last login was before the last password change
    $lastLogonBeforePasswordChange = if ($lastLogon -lt $passwordLastSet) { "" } else { "x" }

    #Insert information
    $rowIndex = $dataGridView.Rows.Add()
    $dataGridView.Rows[$rowIndex].Cells[0].Value = $user.Name
    $dataGridView.Rows[$rowIndex].Cells[1].Value = $lastLogon
    $dataGridView.Rows[$rowIndex].Cells[2].Value = $passwordLastSet
    $dataGridView.Rows[$rowIndex].Cells[3].Value = $lastLogonBeforePasswordChange
}

#Color rows that are marked with an "X"
foreach ($row in $dataGridView.Rows) {
    if ($row.Cells["User_must_be_reset"].Value -eq "x") {
        $row.DefaultCellStyle.BackColor = [System.Drawing.Color]::LightCoral
    }
}

$form.ShowDialog()
