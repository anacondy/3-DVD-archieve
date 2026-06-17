#Requires -Version 5.1
<#
.SYNOPSIS
    Phase 2 Data Cleanup for anacondy/3-DVD-archieve.
    Removes dead 404 entries from repos.json, archives them to repos-archive.json,
    and normalizes the workflow_version field.

.USAGE
    PS C:\Users\iassh\3-DVD-archieve> .\Phase2-Data-Cleanup.ps1
#>
param(
    [string]$RepoRoot = $PSScriptRoot
)

$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path $RepoRoot
Push-Location $RepoRoot

try {
    $reposJson = Join-Path $RepoRoot "repos.json"
    if (-not (Test-Path $reposJson)) {
        Write-Host "ERROR: repos.json not found in $RepoRoot" -ForegroundColor Red
        exit 1
    }

    $repos = Get-Content $reposJson -Raw | ConvertFrom-Json
    Write-Host "[cleanup] Loaded repos.json: $($repos.Count) total entries" -ForegroundColor Cyan

    # Split active/building vs dead 404s
    $alive = $repos | Where-Object { $_.status -ne '404' }
    $dead = $repos | Where-Object { $_.status -eq '404' }

    Write-Host "[cleanup] Active/building: $($alive.Count)" -ForegroundColor Green
    Write-Host "[cleanup] Dead 404s:       $($dead.Count)" -ForegroundColor Yellow

    # Write clean repos.json (only active + building)
    $alive | ConvertTo-Json -Depth 10 | Set-Content $reposJson -Encoding UTF8
    Write-Host "[cleanup] Wrote clean repos.json ($($alive.Count) entries)" -ForegroundColor Green

    # Archive dead repos to repos-archive.json (append if exists)
    $archivePath = Join-Path $RepoRoot "repos-archive.json"
    $archive = @()
    if (Test-Path $archivePath) {
        $archive = Get-Content $archivePath -Raw | ConvertFrom-Json
        Write-Host "[cleanup] Existing archive: $($archive.Count) entries" -ForegroundColor DarkCyan
    }

    # Add new dead entries, deduplicate by name
    $archiveLookup = @{}
    $archive | ForEach-Object { $archiveLookup[$_.name] = $_ }
    $dead | ForEach-Object { $archiveLookup[$_.name] = $_ }
    $archive = $archiveLookup.Values | Sort-Object name

    $archive | ConvertTo-Json -Depth 10 | Set-Content $archivePath -Encoding UTF8
    Write-Host "[cleanup] Wrote repos-archive.json ($($archive.Count) entries)" -ForegroundColor Green

    # Stage changes if inside a git repo
    if (Test-Path (Join-Path $RepoRoot ".git")) {
        git add -f "repos.json" "repos-archive.json" 2>$null
        Write-Host "[cleanup] Staged repos.json and repos-archive.json for commit" -ForegroundColor Cyan
        Write-Host "[cleanup] Next: git commit -m 'Phase 2: purge 404s from repos.json, archive dead entries'" -ForegroundColor Yellow
    }

} finally {
    Pop-Location
}
