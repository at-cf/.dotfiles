param (
  [switch]$Link = $false,
  [switch]$PSProfile = $false,
  [switch]$Chocolatey = $false
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
      Link "$env:USERPROFILE\vimfiles\CustomSnippets" "$env:DOTFILES\neovim\CustomSnippets"
    }
    if (Get-Command nvim.exe -ErrorAction SilentlyContinue | Test-Path) {
      Link "$env:LOCALAPPDATA\nvim\init.vim" "$env:DOTFILES\neovim\init.vim"
      Link "$env:LOCALAPPDATA\nvim\spell\en.utf-8.add" "$env:DOTFILES\neovim\spell\en.utf-8.add"
      Link "$env:LOCALAPPDATA\nvim\CustomSnippets" "$env:DOTFILES\neovim\CustomSnippets"
    }
    Link "$env:APPDATA\Code\User\settings.json" "$env:DOTFILES\vscode\settings.json"
    Link "$env:APPDATA\Code\User\keybindings.json" "$env:DOTFILES\vscode\keybindings.json"
    Link "$env:APPDATA\beets\config.yaml" "$env:DOTFILES\local\beets.config.yaml"
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

function Install-Chocolatey() {
  [CmdletBinding()]
  Param ($installDir)
  Begin {
    if ([string]::IsNullOrEmpty($installDir)) {
      if (!(Test-IsAdmin)) { Throw "Run as admin" }
    } else {
      if (Test-IsAdmin) { Throw "Do not run as admin" }
    }
    Write-Host "Installing Chocolatey..." -ForegroundColor 'Blue'
  }
  Process {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    if (![string]::IsNullOrEmpty($installDir)) {
      Write-Host "Installing as non-admin to $installDir" -ForegroundColor 'Yellow'
      $env:ChocolateyInstall="$installDir"
    }
    [Net.WebRequest]::DefaultWebProxy.Credentials = [Net.CredentialCache]::DefaultCredentials
    iex ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    if (![string]::IsNullOrEmpty($installDir)) {
      [Environment]::SetEnvironmentVariable('ChocolateyInstall', $installDir, "User")
    }
  }
  End {
    Write-Host "Finished installing Chocolatey" -ForegroundColor 'Green'
  }
}

if ($Chocolatey) {
  Install-Chocolatey
  # For local (non-admin) install:
  # Install-Chocolatey $(Join-Path $env:USERPROFILE chocolatey)
}

# pip packages
# pip install --user --upgrade proselint
# pip install --user --upgrade pynvim
# pip install --user --upgrade yamllint
# pip install --user --upgrade awscli
# pip install --user --upgrade beets pylast beets-follow

# npm packages
# npm outdated -g --depth=0
# npm update -g
# npm install -g npm@latest
# npm install -g rimraf
# npm install -g editorconfig
# npm install -g neovim
# npm install -g prettier
# npm install -g typescript typescript-language-server

# chocolatey packages
# choco install -y --limit-output curl
# choco install -y --limit-output ripgrep
# choco install -y --limit-output git.install --params "/GitOnlyOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration /NoGitLfs /SChannel"
# choco install -y --limit-output nodejs.install
# choco install -y --limit-output python
# choco install -y --limit-output 7zip
# choco install -y --limit-output vim-tux
# choco install -y --limit-output notepadplusplus.install
# choco install -y --limit-output greenshot
# choco install -y --limit-output screentogif
# choco install -y --limit-output paint.net
# choco install -y --limit-output sumatrapdf
# choco install -y --limit-output keepass
# choco install -y --limit-output veracrypt
# choco install -y --limit-output eraser
# choco install -y --limit-output freefilesync
# choco install -y --limit-output openvpn
# choco install -y --limit-output firefox
# choco install -y --limit-output chromium
# choco install -y --limit-output qbittorrent
# choco install -y --limit-output skype
# choco install -y --limit-output zoom
# choco install -y --limit-output calibre
# choco install -y --limit-output vlc
# choco install -y --limit-output musicbee
# choco install -y --limit-output coretemp
