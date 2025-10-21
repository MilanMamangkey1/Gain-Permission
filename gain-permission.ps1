param(
	[Parameter(Mandatory=$false)]
	[string]$Path = "D:\Haswell",

	[Parameter(Mandatory=$false)]
	[string]$User = $env:USERNAME
)

function Test-IsElevated {
	$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	(New-Object System.Security.Principal.WindowsPrincipal($identity)).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsElevated)) {
	Write-Error "This script must be run elevated (as Administrator)." -ErrorAction Stop
}

if (-not (Test-Path -Path $Path)) {
	Write-Error "Path '$Path' does not exist." -ErrorAction Stop
}

# Take ownership of the folder and all child items
Write-Host "Taking ownership of '$Path' and child items..."
takeown /f "$Path" /r /d Y | Out-Null

# Grant full control to the specified user, preserving inheritance and applying to child objects
Write-Host "Granting full control to '$User' on '$Path' (recursively)..."
# Use icacls with /grant:r to replace explicit entries for the user, /inheritance:e to enable inheritance
icacls "$Path" /grant:r "${User}:(OI)(CI)F" /t /c | Out-Null

Write-Host "Done."