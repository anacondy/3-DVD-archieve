# GitHub Actions Workflow Overview

## Update Repository Status Workflow

This document provides a comprehensive overview of the automated repository discovery and status tracking workflow implemented in this project.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     WORKFLOW TRIGGER                             │
│  • Schedule: Every 17 hours (10x per week)                      │
│  • Manual: workflow_dispatch from GitHub Actions tab            │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STEP 1: Checkout Repository                   │
│  • Clone the repository to GitHub Actions runner                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STEP 2: Setup Node.js                          │
│  • Install Node.js v20                                           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 3: Check Last Update Time                      │
│  • Read .last_update timestamp file                             │
│  • Calculate hours since last run                               │
│  • Skip if < 30 hours (prevent too frequent runs)               │
│  • Update .last_update with current timestamp                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│          STEP 4: Discover and Update Repositories                │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4.1: Fetch All Public Repositories                       │   │
│  │  • GitHub API: /orgs/anacondy/repos                      │   │
│  │  • Pagination: Up to 50 pages, 100 repos per page        │   │
│  │  • Rate limiting: 200ms between requests                 │   │
│  └──────────────────────┬──────────────────────────────────┘   │
│                          │                                        │
│                          ▼                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4.2: Check GitHub Pages Status                           │   │
│  │  • For each repo: GitHub API /repos/{owner}/{repo}/pages │   │
│  │  • Filter repos with Pages enabled                       │   │
│  │  • Handle 404 (no pages) and 403 (rate limit) responses │   │
│  │  • Retry with 2s delay on rate limiting                  │   │
│  └──────────────────────┬──────────────────────────────────┘   │
│                          │                                        │
│                          ▼                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4.3: Verify URL Accessibility                            │   │
│  │  • HEAD request to https://anacondy.github.io/{repo}/   │   │
│  │  • Status 200 → "active"                                 │   │
│  │  • Status 404 → "404"                                    │   │
│  │  • Other/timeout → "building"                            │   │
│  │  • Timeout: 10 seconds                                   │   │
│  └──────────────────────┬──────────────────────────────────┘   │
│                          │                                        │
│                          ▼                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4.4: Track Changes                                       │   │
│  │  • Compare with existing repos.json                      │   │
│  │  • Identify:                                             │   │
│  │    - New repositories (added)                            │   │
│  │    - Missing repositories (deleted)                      │   │
│  │    - Status changes (active ↔ 404 ↔ building)          │   │
│  │    - Date updates (when becoming active)                 │   │
│  │    - Errors (404 or building status)                     │   │
│  └──────────────────────┬──────────────────────────────────┘   │
│                          │                                        │
│                          ▼                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4.5: Generate Output Files                               │   │
│  │  • repos.json: Updated repository data (sorted by date)  │   │
│  │  • CHANGELOG.md: Detailed change report with tables      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 5: Commit and Push Changes                     │
│  • Configure git user as github-actions[bot]                    │
│  • Stage: repos.json, CHANGELOG.md, .last_update                │
│  • Create commit with summary from CHANGELOG                    │
│  • Tag commit with [skip ci] to prevent workflow loop           │
│  • Push to main branch                                           │
└─────────────────────────────────────────────────────────────────┘
```

## Workflow Schedule

The workflow runs on a staggered schedule to achieve approximately 17-hour intervals:

| Day | Run Times (UTC) | Hours Since Previous |
|-----|----------------|---------------------|
| Monday | 00:00, 17:00 | 17h, 17h |
| Tuesday | 10:00 | 17h |
| Wednesday | 03:00, 20:00 | 17h, 17h |
| Thursday | 13:00 | 17h |
| Friday | 06:00, 23:00 | 17h, 17h |
| Saturday | 16:00 | 17h |
| Sunday | 09:00 | 17h |

**Total: ~10 runs per week**

## Data Flow

```
GitHub Organization
        │
        │ GitHub API
        ▼
  All Public Repos ──────┐
        │                │
        │                │
        ▼                │
   Filter by            │
  Pages Enabled         │
        │                │
        ▼                │
 Check URL Status        │
        │                │
        ▼                │
  Update repos.json ◀────┘
        │
        ├──► CHANGELOG.md (change report)
        │
        └──► index.html (via fetch API)
                  │
                  ▼
            User's Browser
```

## File Structure

```
3-DVD-archieve/
├── .github/
│   └── workflows/
│       └── update-repo-status.yml    # Main workflow file
├── .last_update                       # Timestamp to prevent frequent runs
├── repos.json                         # Repository data (auto-updated)
├── CHANGELOG.md                       # Change log (auto-generated)
├── index.html                         # Main site (reads repos.json)
├── IMPLEMENTATION.md                  # Technical documentation
├── GITHUB_ACTIONS_GUIDE.md           # Educational guide
└── README.md                          # Project readme
```

## Status Indicators

The workflow assigns one of three statuses to each repository:

| Status | Meaning | Display | Trigger |
|--------|---------|---------|---------|
| `active` | Site is live and accessible | _(no indicator)_ | HTTP 200 OK |
| `404` | Site not found | ❌ | HTTP 404 |
| `building` | Site is being built or temporarily unavailable | ⏳ | Other HTTP codes or timeout |

## Change Tracking

The workflow generates a detailed changelog with the following categories:

### 🆕 Repositories Added
New repositories discovered with GitHub Pages enabled.

**Includes:** Name, URL, Status, Date Added

### 🗑️ Repositories Deleted
Repositories that no longer have GitHub Pages enabled or were removed.

**Includes:** Name, URL, Previous Status, Last Known Date

### 🔄 Status Changes
Repositories whose accessibility status changed.

**Includes:** Name, URL, Old Status, New Status, Date

### 📅 Date Updates
Repositories whose date was updated (typically when transitioning to active).

**Includes:** Name, URL, Old Date, New Date, Current Status

### ⚠️ Errors/Issues
Repositories currently experiencing issues (404 or building status).

**Includes:** Name, URL, Issue Type, Date

## Performance Metrics

- **Average Runtime**: 30-90 seconds (varies with repo count)
- **API Requests**: ~3 per repository (org list + pages check + status check)
- **Rate Limiting**: 200ms between requests, 2s on retry
- **Monthly Actions Minutes**: ~5-7 minutes (well within 2,000 min free tier)

## Error Handling

The workflow includes robust error handling:

1. **Rate Limiting**: Automatic retry with 2-second delay on HTTP 403
2. **Timeouts**: 10-second timeout on URL checks
3. **JSON Parsing**: Try-catch blocks with error truncation
4. **API Failures**: Graceful degradation - skip problem repos instead of failing
5. **Duplicate Runs**: Timestamp check prevents runs closer than 30 hours

## Manual Triggering

To manually trigger the workflow:

1. Navigate to repository on GitHub
2. Click **Actions** tab
3. Select **Update Repository Status** workflow
4. Click **Run workflow** button
5. Select branch (usually `main`)
6. Click **Run workflow** to confirm

## Recent Changes (PR History)

### PR #5: Fix Invalid Cron Syntax
- Fixed malformed YAML with concatenated cron entries
- Separated multiple cron schedules onto individual lines
- Ensured workflow file passes GitHub Actions validation

### PR #4: Auto-discover Repositories
- Implemented automatic repository discovery via GitHub API
- Added changelog generation with detailed tables
- Increased update frequency to every 17 hours (10x per week)
- Added comprehensive change tracking

### PR #3: Automated Repository Status Tracking
- Created initial workflow for status checking
- Implemented repos.json data file
- Added status indicators to index.html

## Security

✅ **No vulnerabilities detected**

- Uses built-in `GITHUB_TOKEN` (no custom secrets)
- CodeQL scan: 0 alerts
- Safe HTTP requests with timeouts
- Commits tagged with `[skip ci]` prevent infinite loops
- Read-only API access (discovery only)

## Future Enhancements

Potential improvements:

1. **Historical Tracking**: Store status history over time
2. **Notifications**: Email/Slack alerts on status changes
3. **Performance Metrics**: Response time monitoring
4. **Filtering**: Support for filtering by topics/labels
5. **Batch Updates**: Optimize API calls with batching
6. **Dashboard**: Visual health dashboard for all repos

---

**Last Updated**: December 2025  
**Maintained By**: GitHub Actions (automated)  
**Questions?** See [IMPLEMENTATION.md](IMPLEMENTATION.md) or [GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)
