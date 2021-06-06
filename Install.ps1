param (
  [switch]$Link = $false,
  [switch]$PSProfile = $false
)

if ([string]::IsNullOrEmpty($env:DOTFILES)) {
  $env:DOTFILES=Split-Path -parent $PSCommandPath
}

function Test-IsAdmin {
  ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function Link() {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$dest,
    [Parameter(Mandatory=$true)]
    [string]$src
  )
  Begin {
    Write-Host "Linking $dest" -ForegroundColor 'DarkGray'
  }
  Process {
    if (-Not (Test-Path $src)) {
      Write-Host "$src does not exist" -ForegroundColor 'Yellow'
    } else {
      if (Test-Path $dest) {
        (Remove-Item $dest -Recurse -Force -Confirm:$false) | Out-Null
      } else {
        $parent=Split-Path -parent $dest
        if (-Not (Test-Path $parent -PathType Container)) {
          (New-Item $parent -ItemType Directory) | Out-Null
        }
      }
      if (Test-Path $src -PathType Container) {
        (New-Item -Path $dest -ItemType Junction -Value $src) | Out-Null
      } elseif (Test-Path $src -PathType Leaf) {
        (New-Item -Path $dest -ItemType HardLink -Value $src) | Out-Null
      }
    }
  }
}

function Install-Links() {
  [CmdletBinding()]
  Param ()
  Begin {
    if (Test-IsAdmin) { Throw "Do not run as admin" }
    Write-Host "Installing links..." -ForegroundColor 'Blue'
  }
  Process {
    Link "$env:USERPROFILE\.PowerShell_profile.ps1" "$env:DOTFILES\profile.ps1"
    Link "$env:USERPROFILE\.PowerShell_profile.local.ps1" "$env:DOTFILES\local\profile.ps1"
    Link "$env:USERPROFILE\.gitconfig" "$env:DOTFILES\git\gitconfig"
    Link "$env:USERPROFILE\.gitconfig.windows" "$env:DOTFILES\git\gitconfig.windows"
    Link "$env:USERPROFILE\.gitconfig.local" "$env:DOTFILES\local\gitconfig"
    Link "$env:USERPROFILE\.gitignore" "$env:DOTFILES\git\gitignore"
    Link "$env:USERPROFILE\.editorconfig" "$env:DOTFILES\editorconfig"
    Link "$env:USERPROFILE\.rgignore" "$env:DOTFILES\rgignore"
    Link "$env:USERPROFILE\.ideavimrc" "$env:DOTFILES\JetBrains\ideavimrc"
    if (Get-Command gvim.exe -ErrorAction SilentlyContinue | Test-Path) {
      Link "$env:USERPROFILE\vimfiles\vimrc" "$env:DOTFILES\neovim\init.vim"
      Link "$env:USERPROFILE\vimfiles\spell\en.utf-8.add" "$env:DOTFILES\neovim\spell\en.utf-8.add"
    }
    if (Get-Command nvim.exe -ErrorAction SilentlyContinue | Test-Path) {
      Link "$env:LOCALAPPDATA\nvim\init.vim" "$env:DOTFILES\neovim\init.vim"
      Link "$env:LOCALAPPDATA\nvim\spell\en.utf-8.add" "$env:DOTFILES\neovim\spell\en.utf-8.add"
    }
    Link "$env:APPDATA\Code\User\settings.json" "$env:DOTFILES\vscode\settings.json"
    Link "$env:APPDATA\Code\User\keybindings.json" "$env:DOTFILES\vscode\keybindings.json"
    Link "$env:APPDATA\beets\config.yaml" "$env:DOTFILES\local\beets\config.windows.yaml"
  }
  End {
    Write-Host "Finished installing links" -ForegroundColor 'Green'
  }
}

if ($Link) {
  Install-Links
}

function Install-Profile() {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$true)]
    [string]$useProfile
  )
  Begin {
    if (Test-IsAdmin) { Throw "Do not run as admin" }
    Write-Host "Installing delegated PowerShell profile..." -ForegroundColor 'Blue'
  }
  Process {
    $newProfile=Join-Path -Path "$env:USERPROFILE" -ChildPath ".PowerShell_profile.ps1"
    $profileContent = @"
if ([System.IO.File]::Exists("$newProfile")) { . $newProfile } else { echo "$newProfile not found..." }
"@
    if ([System.IO.File]::Exists($useProfile)) {
      $content = Get-Content $useProfile
      if ($content -ne $profileContent) {
        Throw "$useProfile exists, back it up and then remove it first"
      }
    } else {
      (New-Item -path $useProfile -type file -force) | Out-Null
      echo $profileContent | Out-File $useProfile
    }
  }
  End {
    Write-Host "Finished installing delegated PowerShell profile" -ForegroundColor 'Green'
  }
}

if ($PSProfile) {
  Install-Profile $profile.CurrentUserAllHosts
}
