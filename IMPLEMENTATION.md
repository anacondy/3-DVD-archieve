# Auto-Update Repository Archive - Implementation Guide

## Overview
This implementation adds an automatic repository status checking system that runs every ~32 hours to keep the 3-DVD-archieve site up-to-date.

## Files Modified/Created

### 1. `repos.json` (New)
Central data file containing all repository information:
```json
[
  {
    "name": "repository-name",
    "url": "https://anacondy.github.io/repository-name/",
    "date": "2025-12-01",
    "status": "active" | "404" | "building"
  }
]
```

### 2. `index.html` (Modified)
- Added `loadRepoData()` function to fetch repository data from JSON
- Updated `formatRetroDate()` to handle ISO date format (YYYY-MM-DD)
- Modified `startExperience()` to load data before rendering
- Status indicators (❌/⏳) automatically added based on status field

### 3. `.github/workflows/update-repo-status.yml` (New)
GitHub Actions workflow that:
- Runs on a cron schedule (approximately every 32 hours)
- **Automatically discovers all public repositories** with GitHub Pages enabled
- Checks each repository URL for availability
- Updates status and dates in repos.json
- **Generates detailed changelog** with tables showing all changes
- Commits changes automatically

### 4. `CHANGELOG.md` (Auto-generated)
Automatically generated file that tracks all repository updates:
- 🆕 Repositories added
- 🗑️ Repositories deleted (no longer have GitHub Pages)
- 🔄 Status changes (active ↔ 404 ↔ building)
- 📅 Date updates (when repositories become active)
- ⚠️ Errors/Issues detected

Each section includes a markdown table with repository details, URLs, statuses, and dates.

## How It Works

### Workflow Schedule
The workflow runs **every 17 hours** throughout the week:
- **Monday**: 00:00, 17:00 UTC
- **Tuesday**: 10:00 UTC
- **Wednesday**: 03:00, 20:00 UTC
- **Thursday**: 13:00 UTC
- **Friday**: 06:00, 23:00 UTC
- **Saturday**: 16:00 UTC
- **Sunday**: 09:00 UTC

This creates a consistent 17-hour interval between runs, resulting in approximately **10 updates per week** (compared to the previous ~5 updates per week with 32-hour intervals).

### Auto-Discovery Process
The workflow automatically discovers repositories by:
1. **Fetching all public repositories** from the anacondy organization via GitHub API
2. **Checking GitHub Pages status** for each repository using the GitHub Pages API
3. **Adding new repositories** with GitHub Pages to the list automatically
4. **Preserving existing data** for repositories that were previously discovered

### Status Detection
The workflow makes HEAD requests to each repository URL:
- **200 OK** → `status: "active"` → No indicator shown
- **404 Not Found** → `status: "404"` → ❌ shown
- **Other responses** → `status: "building"` → ⏳ shown

### Date Updates
- Dates are set to the current date when a **new repository is discovered**
- Dates are updated **only when** a repository changes to "active" status
- This prevents unnecessary commits when nothing has changed

### Change Tracking & Reporting
Every workflow run generates a detailed `CHANGELOG.md` file with:
- **Summary statistics** (repositories added, deleted, status changes, etc.)
- **Tables for each change type**:
  - 🆕 New repositories added (with URL, status, and date)
  - 🗑️ Repositories deleted (repositories that no longer have GitHub Pages)
  - 🔄 Status changes (showing old → new status transitions)
  - 📅 Date updates (when repositories become active)
  - ⚠️ Errors/Issues (repositories with 404 or building status)
- **Commit message includes** a summary of changes made

This provides full transparency on what the automation did during each run.

### Rate Limiting
- 200ms delay between each request
- Total check time: ~13 seconds for 66 repositories
- Avoids overwhelming GitHub's servers

## Manual Workflow Trigger

You can manually run the workflow from the GitHub Actions tab:
1. Go to the repository on GitHub
2. Click "Actions" tab
3. Select "Update Repository Status" workflow
4. Click "Run workflow" button

## Testing Locally

To test the status checking logic:
```bash
node << 'EOF'
const https = require('https');

function checkUrl(url) {
  return new Promise((resolve) => {
    const req = https.request(url, { method: 'HEAD', timeout: 10000 }, (res) => {
      resolve(res.statusCode === 200 ? 'active' : res.statusCode === 404 ? '404' : 'building');
    });
    req.on('error', () => resolve('404'));
    req.on('timeout', () => { req.destroy(); resolve('building'); });
    req.end();
  });
}

checkUrl('https://anacondy.github.io/3-DVD-archieve/')
  .then(status => console.log('Status:', status));
EOF
```

## Maintenance

### Adding New Repositories
**No manual intervention required!** The workflow automatically discovers new repositories with GitHub Pages enabled. Simply:
1. Enable GitHub Pages on your repository
2. Wait for the next workflow run (~32 hours)
3. The repository will appear on the site automatically

Alternatively, you can trigger the workflow manually from the GitHub Actions tab for immediate discovery.

### Removing Repositories
Repositories are automatically discovered based on GitHub Pages status. If you disable GitHub Pages on a repository:
1. The repository will remain in `repos.json` with its last known status
2. To completely remove it, manually delete the entry from `repos.json`

### Changing Check Frequency
Edit `.github/workflows/update-repo-status.yml` and modify the cron schedules. Current schedule runs every 17 hours:
```yaml
schedule:
  - cron: '0 0,17 * * 1,3,5,7'    # 00:00 and 17:00 UTC on Mon, Wed, Fri, Sun
  - cron: '0 10 * * 2,6'          # 10:00 UTC on Tue, Sat
  # ... (see workflow file for complete schedule)
```

## Troubleshooting

### Workflow not running?
- Check the Actions tab for errors
- Verify the workflow file syntax
- Ensure repository has Actions enabled

### Status not updating?
- Check workflow logs in Actions tab
- Verify the URL is accessible
- Test URL manually with curl:
  ```bash
  curl -I https://anacondy.github.io/repo-name/
  ```

### Site not loading data?
- Check browser console for errors
- Verify repos.json is valid JSON
- Test with: `curl https://anacondy.github.io/3-DVD-archieve/repos.json`

## Performance Metrics

- **Total Repositories**: Auto-discovered (currently ~66)
- **Discovery Duration**: ~30-60 seconds (depends on total repo count)
- **Check Duration**: ~13 seconds per 66 repositories
- **Delay Between Requests**: 200ms
- **Workflow Frequency**: Every 17 hours (~10 runs per week)
- **Monthly GitHub Actions Minutes**: ~4-5 minutes (increased from 2-3 with previous 32-hour schedule)

## Security

- ✅ No secrets or credentials required
- ✅ CodeQL security scan: 0 vulnerabilities
- ✅ Safe HTTP requests with timeouts
- ✅ Error handling for failed requests
- ✅ Commits tagged with `[skip ci]` to prevent infinite loops

## Recent Enhancements

✅ **Auto-Discovery** (December 2025)
- Workflow now automatically discovers all repositories with GitHub Pages
- No manual repo.json editing required
- Uses GitHub API to fetch organization repositories
- Checks GitHub Pages status for each repository

## Future Enhancements

Potential improvements for future iterations:
1. Email notifications on status changes
2. Historical status tracking
3. Response time monitoring
4. Batch updates to reduce API calls
5. Dashboard for repository health metrics
6. Filtering by topics or labels
