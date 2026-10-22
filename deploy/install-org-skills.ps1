#requires -Version 5.1
<#
IT-managed Claude Desktop Syncoria plugin deployer. Run via Intune/RMM
as Administrator or SYSTEM, never on an employee's terminal.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$ZipPath,
  [Parameter(Mandatory=$true)][string]$ReleaseJsonPath,
  [string]$OrgPluginRoot = 'C:\Program Files\Claude\org-plugins'
)
$ErrorActionPreference='Stop'
$zip=(Resolve-Path -LiteralPath $ZipPath).Path
$release=(Get-Content -LiteralPath $ReleaseJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json)
if ($release.sha256 -notmatch '^[a-fA-F0-9]{64}$') {throw 'Release checksum missing or invalid'}
$hash=(Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash
if ($hash -ine $release.sha256) {throw 'Plugin package checksum mismatch'}
New-Item -ItemType Directory -Force -Path $OrgPluginRoot | Out-Null
$target=Join-Path $OrgPluginRoot 'syncoria-skills'
$stage=Join-Path $OrgPluginRoot ('syncoria-stage-'+[Guid]::NewGuid().ToString('N'))
$backup=Join-Path $OrgPluginRoot ('syncoria-backup-'+[Guid]::NewGuid().ToString('N'))
$success=$false
try {
  New-Item -ItemType Directory -Path $stage -Force | Out-Null
  Expand-Archive -LiteralPath $zip -DestinationPath $stage -Force
  $candidate=Join-Path $stage 'syncoria-skills'
  if (-not (Test-Path (Join-Path $candidate '.claude-plugin\plugin.json'))) {throw 'Plugin manifest missing'}
  $count=@(Get-ChildItem (Join-Path $candidate 'skills') -Filter SKILL.md -File -Recurse).Count
  if ($count -ne [int]$release.skillCount -or $count -eq 0) {throw "Package has $count skills, expected $($release.skillCount)"}
  @{sha=$release.sha;sha256=$release.sha256;skillCount=$count;installedAt=(Get-Date).ToUniversalTime().ToString('o')} |
    ConvertTo-Json | Set-Content (Join-Path $candidate 'managed-install.json') -Encoding UTF8
  if (Test-Path $target) {Move-Item -LiteralPath $target -Destination $backup}
  Move-Item -LiteralPath $candidate -Destination $target
  $success=$true
  if (Test-Path $backup) {Remove-Item -LiteralPath $backup -Force -Recurse}
  Write-Host "Installed Syncoria Skills ($count skills); restart Claude Desktop."
} catch {
  if (-not $success -and (Test-Path $backup)) {
    if (Test-Path $target) {Remove-Item -LiteralPath $target -Force -Recurse}
    Move-Item -LiteralPath $backup -Destination $target
  }
  throw
} finally {
  if (Test-Path $stage) {Remove-Item -LiteralPath $stage -Force -Recurse}
}
