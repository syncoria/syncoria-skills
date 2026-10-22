#requires -Version 5.1
# Intune/RMM detection: exit 0 when the managed package is intact, else 1.
$root='C:\Program Files\Claude\org-plugins\syncoria-skills'
$marker=Join-Path $root 'managed-install.json'
$manifest=Join-Path $root '.claude-plugin\plugin.json'
if (-not ((Test-Path $marker) -and (Test-Path $manifest))) {exit 1}
try {
 $meta=Get-Content -LiteralPath $marker -Raw | ConvertFrom-Json
 $count=@(Get-ChildItem (Join-Path $root 'skills') -Recurse -File -Filter SKILL.md).Count
 if ($count -gt 0 -and $count -eq [int]$meta.skillCount) {Write-Host "Syncoria Skills present: $count"; exit 0}
} catch {}
exit 1
