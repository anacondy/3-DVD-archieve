#Requires -Version 5.1
<#
.SYNOPSIS
    Diagnoses which public repos are missing from repos.json.
    Also flags any 404 dead entries still in repos.json.

.USAGE
    PS C:\Users\iassh\3-DVD-archieve> .\diagnose-missing-repo.ps1
#>
param(
    [string]$RepoRoot = $PSScriptRoot,
    [string]$Username = "anacondy"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path $RepoRoot
Push-Location $RepoRoot

try {
    Write-Host "[diag] Scanning GitHub API for public repos of $Username..." -ForegroundColor Cyan

    # Load local repos.json
    $local = @()
    $reposJsonPath = Join-Path $RepoRoot "repos.json"
    if (Test-Path $reposJsonPath) {
        $local = Get-Content $reposJsonPath -Raw | ConvertFrom-Json
        Write-Host "[diag] repos.json loaded: $($local.Count) entries" -ForegroundColor Cyan
    } else {
        Write-Host "[diag] repos.json NOT FOUND in $RepoRoot" -ForegroundColor Red
    }

    # Fetch all public repos from GitHub API (paginated)
    $all = @()
    $page = 1
    while ($true) {
        try {
            $uri = "https://api.github.com/users/$Username/repos?type=public&per_page=100&page=$page"
            $resp = Invoke-RestMethod -Uri $uri -Method GET -Headers @{ "User-Agent" = "anacondy-diag" } -ErrorAction Stop
            if ($resp.Count -eq 0) { break }
            $all += $resp
            if ($resp.Count -lt 100) { break }
            $page++
            Start-Sleep -Seconds 1  # polite rate-limiting
        } catch {
            Write-Host "[diag] API ERROR: $_" -ForegroundColor Red
            break
        }
    }

    Write-Host "[diag] GitHub API returned: $($all.Count) public repos" -ForegroundColor Cyan

    # Find missing repos
    $missing = @()
    foreach ($repo in $all) {
        $found = $local | Where-Object { $_.name -eq $repo.name }
        if (-not $found) {
            $missing += [PSCustomObject]@{
                Name = $repo.name
                Created = $repo.created_at
                HtmlUrl = $repo.html_url
                PagesUrl = "https://$Username.github.io/$($repo.name)/"
                Reason = "Not in repos.json"
            }
        }
    }

    if ($missing.Count -gt 0) {
        Write-Host "`n⚠️ MISSING FROM repos.json ($($missing.Count) repos):" -ForegroundColor Yellow
        $missing | Format-Table -AutoSize

        # Quick check: which ones likely have Pages?
        Write-Host "[diag] Spot-checking Pages URLs for missing repos (first 10)..." -ForegroundColor DarkCyan
        foreach ($m in $missing | Select-Object -First 10) {
            try {
                $r = Invoke-WebRequest -Uri $m.PagesUrl -Method HEAD -TimeoutSec 10 -ErrorAction Stop
                Write-Host "  $($m.Name): $($r.StatusCode) → likely HAS Pages" -ForegroundColor Green
            } catch {
                $code = $_.Exception.Response.StatusCode.value__
                if ($code -eq 404) {
                    Write-Host "  $($m.Name): 404 → likely NO Pages" -ForegroundColor DarkGray
                } else {
                    Write-Host "  $($m.Name): $code → ambiguous" -ForegroundColor DarkYellow
                }
            }
        }
    } else {
        Write-Host "`n✅ All public repos are already in repos.json" -ForegroundColor Green
    }

    # Find 404 dead entries still in repos.json
    $dead = $local | Where-Object { $_.status -eq '404' }
    if ($dead.Count -gt 0) {
        Write-Host "`n❌ DEAD ENTRIES (404) still in repos.json ($($dead.Count)):" -ForegroundColor Red
        $dead | Select-Object name, url, status | Format-Table -AutoSize
    } else {
        Write-Host "`n✅ No 404 entries in repos.json" -ForegroundColor Green
    }

    # Summary comparison
    Write-Host "`n--- Summary ---" -ForegroundColor Cyan
    Write-Host "GitHub public repos:  $($all.Count)"
    Write-Host "repos.json entries:    $($local.Count)"
    Write-Host "Missing from JSON:     $($missing.Count)"
    Write-Host "Dead 404s in JSON:     $($dead.Count)"

    # Export to CSV for easy review
    $csvPath = Join-Path $RepoRoot "diag-missing-repos.csv"
    $missing | Export-Csv -Path $csvPath -NoTypeInformation -Force
    Write-Host "`n[diag] Missing repo list exported to: $csvPath" -ForegroundColor Cyan

} finally {
    Pop-Location
}
