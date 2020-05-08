Write-Host "Installing .dotfiles..." -ForegroundColor 'Green'
$location=Get-Location
try {
  Set-Location $env:USERPROFILE
  $dotfiles = Join-Path $env:USERPROFILE '.dotfiles'
  if (-Not (Test-Path $dotfiles)) {
    [Environment]::SetEnvironmentVariable('DOTFILES', $dotfiles, "User")
    git clone --recurse-submodules https://github.com/at-cf/.dotfiles.git
    if (Test-Path $dotfiles) {
      Set-Location $dotfiles
      & .\Install.ps1 -PSProfile -Link
      Write-Host "Finished installing .dotfiles" -ForegroundColor 'Green'
    }
  } else {
   Throw "$dotfiles already exists"
  }
} finally {
  Set-Location $location
}
