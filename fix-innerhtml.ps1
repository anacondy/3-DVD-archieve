#Requires -Version 5.1
<#
.SYNOPSIS
    Safely replaces the innerHTML block in index.html with DOM-safe construction.
    Creates a backup first. If the replacement fails, the backup is restored.
#>
param([string]$RepoRoot = $PSScriptRoot)
$ErrorActionPreference = "Stop"
Push-Location (Resolve-Path $RepoRoot)

try {
    $file = "index.html"
    $backup = "index.html.bak"

    # 1. Backup
    Copy-Item $file $backup -Force
    Write-Host "[fix] Backup created: $backup" -ForegroundColor Cyan

    $html = Get-Content $file -Raw

    # 2. The exact innerHTML block to replace (with leading spaces as they appear in the file)
    $oldBlock = @'
                link.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items: center;">
                        <span class="truncate pr-4">${idxStr}. ${repo.name}</span>
                        <span class="dim-text text-xs whitespace-nowrap">${formatRetroDate(repo.date)}</span>
                    </div>
                `;
'@

    $newBlock = @'
                // Phase 2: Safe DOM construction (prevents XSS injection)
                const div = document.createElement('div');
                div.style.display = 'flex';
                div.style.justifyContent = 'space-between';
                div.style.alignItems = 'center';
                const nameSpan = document.createElement('span');
                nameSpan.className = 'truncate pr-4';
                nameSpan.textContent = `${idxStr}. ${repo.name}`;
                const dateSpan = document.createElement('span');
                dateSpan.className = 'dim-text text-xs whitespace-nowrap';
                dateSpan.textContent = formatRetroDate(repo.date);
                div.appendChild(nameSpan);
                div.appendChild(dateSpan);
                link.appendChild(div);
'@

    if ($html.Contains($oldBlock)) {
        $html = $html.Replace($oldBlock, $newBlock)
        $html | Set-Content $file -Encoding UTF8
        Write-Host "[fix] ✅ innerHTML replaced with safe DOM construction" -ForegroundColor Green
    } else {
        Write-Host "[fix] ⚠️ Could not find exact innerHTML block. Checking for variations..." -ForegroundColor Yellow

        # Fallback: use a looser regex to find the innerHTML assignment and everything after it up to the next `;
        if ($html -match 'link\.innerHTML\s*=\s*`[\s\S]*?`\s*;') {
            $match = $Matches[0]
            Write-Host "[fix] Found match via regex. Replacing..." -ForegroundColor Cyan
            $html = $html.Replace($match, $newBlock)
            $html | Set-Content $file -Encoding UTF8
            Write-Host "[fix] ✅ innerHTML replaced via regex fallback" -ForegroundColor Green
        } else {
            Write-Host "[fix] ❌ Could not find innerHTML block. No changes made." -ForegroundColor Red
            Write-Host "[fix] The backup $backup is untouched. You can restore it manually if needed." -ForegroundColor Yellow
            exit 1
        }
    }

    # 3. Verify the file still has the rel fix (should not have been touched)
    if ($html -match 'rel\s*=\s*"noopener noreferrer"') {
        Write-Host "[fix] ✅ rel='noopener noreferrer' is still present" -ForegroundColor Green
    } else {
        Write-Host "[fix] ⚠️ Warning: rel='noopener noreferrer' not found" -ForegroundColor Yellow
    }

    # 4. Verify no syntax errors (basic check: count of { and } match in the script section)
    # This is a crude check, but it's better than nothing
    $scriptStart = $html.IndexOf('<script>')
    $scriptEnd = $html.IndexOf('</script>')
    if ($scriptStart -ne -1 -and $scriptEnd -ne -1) {
        $scriptBlock = $html.Substring($scriptStart, $scriptEnd - $scriptStart)
        $openBraces = ($scriptBlock -split '{').Count - 1
        $closeBraces = ($scriptBlock -split '}').Count - 1
        if ($openBraces -eq $closeBraces) {
            Write-Host "[fix] ✅ Brace balance check passed (basic syntax sanity)" -ForegroundColor Green
        } else {
            Write-Host "[fix] ⚠️ Brace mismatch detected: {=$openBraces }=$closeBraces" -ForegroundColor Red
            Write-Host "[fix] Restoring backup..." -ForegroundColor Yellow
            Copy-Item $backup $file -Force
            exit 1
        }
    }

} finally {
    Pop-Location
}
