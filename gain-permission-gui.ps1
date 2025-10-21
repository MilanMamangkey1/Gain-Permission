Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Simple GUI to pick path and user, then call gain-permission.ps1
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Gain Permission GUI'
$form.Size = New-Object System.Drawing.Size(520,220)
$form.StartPosition = 'CenterScreen'

$lblPath = New-Object System.Windows.Forms.Label
$lblPath.Text = 'Folder:'
$lblPath.Location = New-Object System.Drawing.Point(10,20)
$lblPath.AutoSize = $true
$form.Controls.Add($lblPath)

$txtPath = New-Object System.Windows.Forms.TextBox
$txtPath.Location = New-Object System.Drawing.Point(70,16)
$txtPath.Size = New-Object System.Drawing.Size(360,20)
$txtPath.Text = 'D:\Haswell'
$form.Controls.Add($txtPath)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = 'Browse...'
$btnBrowse.Location = New-Object System.Drawing.Point(440,14)
$btnBrowse.Size = New-Object System.Drawing.Size(60,24)
$btnBrowse.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.SelectedPath = $txtPath.Text
    if ($dlg.ShowDialog() -eq 'OK') { $txtPath.Text = $dlg.SelectedPath }
})
$form.Controls.Add($btnBrowse)

$lblUser = New-Object System.Windows.Forms.Label
$lblUser.Text = 'User:'
$lblUser.Location = New-Object System.Drawing.Point(10,56)
$lblUser.AutoSize = $true
$form.Controls.Add($lblUser)

$txtUser = New-Object System.Windows.Forms.TextBox
$txtUser.Location = New-Object System.Drawing.Point(70,52)
$txtUser.Size = New-Object System.Drawing.Size(360,20)
$txtUser.Text = $env:USERNAME
$form.Controls.Add($txtUser)

$chkRunAsAdmin = New-Object System.Windows.Forms.CheckBox
$chkRunAsAdmin.Location = New-Object System.Drawing.Point(70,84)
$chkRunAsAdmin.Size = New-Object System.Drawing.Size(300,20)
$chkRunAsAdmin.Text = 'Require elevation (recommended)'
$chkRunAsAdmin.Checked = $true
$form.Controls.Add($chkRunAsAdmin)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = 'Apply Permissions'
$btnRun.Location = New-Object System.Drawing.Point(70,120)
$btnRun.Size = New-Object System.Drawing.Size(120,30)
$btnRun.Add_Click({
    $path = $txtPath.Text.Trim()
    $user = $txtUser.Text.Trim()
    if (-not (Test-Path -Path $path)) {
        [System.Windows.Forms.MessageBox]::Show("Path does not exist: $path", "Error", 'OK', 'Error') | Out-Null
        return
    }

    # Build argument list and start elevated if needed
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
    $script = Join-Path -Path $scriptDir -ChildPath 'gain-permission.ps1'
    if (-not (Test-Path -Path $script)) {
        [System.Windows.Forms.MessageBox]::Show("Helper script not found: $script", "Error", 'OK', 'Error') | Out-Null
        return
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell.exe'
    $args = "-NoProfile -ExecutionPolicy Bypass -File `"$script`" -Path `"$path`" -User `"$user`""
    $psi.Arguments = $args
    if ($chkRunAsAdmin.Checked) { $psi.Verb = 'runas' }
    $psi.UseShellExecute = $true

    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        [System.Windows.Forms.MessageBox]::Show("Operation started. If elevated, a UAC prompt may appear.", "Started", 'OK', 'Information') | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to start operation: $_", "Error", 'OK', 'Error') | Out-Null
    }
})
$form.Controls.Add($btnRun)

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = 'Close'
$btnClose.Location = New-Object System.Drawing.Point(200,120)
$btnClose.Size = New-Object System.Drawing.Size(80,30)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

$form.Add_Shown({ $form.Activate() })
[void] $form.ShowDialog()
