# from explorer (Win+e) -> Alt+f -> R, or from anywhere Win+x -> i
# Hack 18 font is pretty nice in PowerShell

${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

Set-Alias c cls
${function:x} = { exit }

${function:~} = { Set-Location ~ }
${function:cd.} = { Push-Location $env:DOTFILES }
${function:cdd} = { Set-Location ~\Development }
Set-Alias i Push-Location
Set-Alias o Pop-Location

${function:ls} = { cmd /R dir /OG /ON }

${function:f} = { explorer . }

Set-Alias g git

Set-Alias n npm
${function:ni} = { npm install --save @args }
${function:nid} = { npm install --save-dev @args }
${function:nig} = { npm install -g @args }
${function:nr} = { npm run @args }

if (Get-Command gvim.exe -ErrorAction SilentlyContinue | Test-Path) {
  $env:EDITOR = "gvim"
  ${function:v} = { gvim @args }
}
if (Get-Command nvim.exe -ErrorAction SilentlyContinue | Test-Path) {
  $env:EDITOR = "nvim-qt"
  ${function:v} = { nvim-qt @args }
}

${function:p} = { cmd /C start powershell }
${function:exe} = { cmd /R @args }
${function:title} = { $host.ui.RawUI.WindowTitle = $args }

function touch {
  Param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  if (Test-Path -LiteralPath $Path) {
    (Get-Item -Path $Path).LastWriteTime = Get-Date
  } else {
    New-Item -Type File -Path $Path
  }
}

function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }

$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.ErrorBackgroundColor = 'Black'
$Host.PrivateData.WarningForegroundColor = 'Yellow'
$Host.PrivateData.WarningBackgroundColor = 'Black'
$Host.PrivateData.DebugForegroundColor = 'Yellow'
$Host.PrivateData.DebugBackgroundColor = 'Black'
$Host.PrivateData.VerboseForegroundColor = 'Green'
$Host.PrivateData.VerboseBackgroundColor = 'Black'
$Host.PrivateData.ProgressForegroundColor = 'DarkGray'
$Host.PrivateData.ProgressBackgroundColor = 'Black'

function prompt {
  # fixes colors sticking around from bad commands
  $Host.UI.RawUI.BackgroundColor = 'Black'
  $Host.UI.RawUI.ForegroundColor = 'White'
  $location = $(Get-Location) -replace ($env:USERPROFILE).Replace('\','\\'), "~"
  $host.UI.RawUI.WindowTitle = $location
  "$location "
}

$localProfile = Join-Path $env:USERPROFILE '.PowerShell_profile.local.ps1'
if ([System.IO.File]::Exists($localProfile)) {
  . $localProfile
}

# cd ~
Clear-Host
