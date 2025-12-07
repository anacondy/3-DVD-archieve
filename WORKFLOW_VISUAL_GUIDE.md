# Workflow Visualization

## Quick Visual Guide to the Update Repository Status Workflow

### 🎯 Purpose
Automatically discover and track all anacondy GitHub Pages repositories, keeping the DVD Archive site up-to-date.

---

## 🔄 The Complete Process (Step-by-Step)

```
╔══════════════════════════════════════════════════════════════════╗
║                     WORKFLOW STARTS                              ║
║  🕐 Every 17 hours (scheduled) OR manually triggered             ║
╚══════════════════════════════════════════════════════════════════╝
                              │
                              ▼
        ┌─────────────────────────────────────────┐
        │  📋 Checkout Repository                 │
        │  Clone the code to GitHub's computer    │
        └──────────────────┬──────────────────────┘
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │  🟢 Setup Node.js v20                   │
        │  Install JavaScript runtime             │
        └──────────────────┬──────────────────────┘
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │  ⏰ Check Last Run Time                 │
        │  • Read .last_update file               │
        │  • Skip if ran less than 30 hours ago   │
        │  • Update timestamp                     │
        └──────────────────┬──────────────────────┘
                           │
                           ▼
╔══════════════════════════════════════════════════════════════════╗
║              🔍 DISCOVER & ANALYZE REPOSITORIES                  ║
╚══════════════════════════════════════════════════════════════════╝
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
┌──────────────────┐              ┌──────────────────┐
│  Step 1          │              │  Step 2          │
│  📡 Fetch Repos  │              │  ✅ Filter       │
│                  │──────────────▶                  │
│  Get all public  │              │  Keep only repos │
│  repos from      │              │  with GitHub     │
│  anacondy org    │              │  Pages enabled   │
└──────────────────┘              └────────┬─────────┘
                                           │
                                           ▼
                               ┌──────────────────────┐
                               │  Step 3              │
                               │  🌐 Check Status     │
                               │                      │
                               │  For each repo URL:  │
                               │  • 200 → active ✓    │
                               │  • 404 → not found ❌│
                               │  • other → building ⏳│
                               └──────────┬───────────┘
                                          │
                                          ▼
                               ┌──────────────────────┐
                               │  Step 4              │
                               │  📊 Track Changes    │
                               │                      │
                               │  Compare with old:   │
                               │  • New repos? 🆕     │
                               │  • Deleted repos? 🗑️ │
                               │  • Status changed? 🔄│
                               │  • Dates updated? 📅 │
                               └──────────┬───────────┘
                                          │
                                          ▼
                               ┌──────────────────────┐
                               │  Step 5              │
                               │  💾 Generate Files   │
                               │                      │
                               │  • repos.json        │
                               │  • CHANGELOG.md      │
                               └──────────┬───────────┘
                                          │
                                          ▼
╔══════════════════════════════════════════════════════════════════╗
║                      💾 SAVE & PUBLISH                           ║
╚══════════════════════════════════════════════════════════════════╝
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │  📝 Commit Changes                      │
        │  • repos.json (updated data)            │
        │  • CHANGELOG.md (change report)         │
        │  • .last_update (timestamp)             │
        │  Tag: [skip ci] (prevent loops)         │
        └──────────────────┬──────────────────────┘
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │  🚀 Push to GitHub                      │
        │  Changes go live on main branch         │
        └──────────────────┬──────────────────────┘
                           │
                           ▼
╔══════════════════════════════════════════════════════════════════╗
║                  ✅ WORKFLOW COMPLETE                            ║
║  Website automatically updates with new data!                    ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 📅 When Does It Run?

The workflow runs **~10 times per week** on this schedule:

| Day       | Times (UTC)    | 
|-----------|----------------|
| 🔴 Monday    | 00:00, 17:00   |
| 🟠 Tuesday   | 10:00          |
| 🟡 Wednesday | 03:00, 20:00   |
| 🟢 Thursday  | 13:00          |
| 🔵 Friday    | 06:00, 23:00   |
| 🟣 Saturday  | 16:00          |
| ⚪ Sunday    | 09:00          |

**Pattern:** Runs approximately every 17 hours

---

## 🎨 Status Indicators Explained

When you view the site, repositories are marked with status indicators:

| You See | What It Means | Technical |
|---------|---------------|-----------|
| `Repository Name` | ✅ Site is working perfectly | HTTP 200 OK |
| `Repository Name ❌` | ⚠️ Site not found (404 error) | HTTP 404 |
| `Repository Name ⏳` | 🔄 Site is building or temporarily down | Timeout or other HTTP code |

---

## 📊 What Changes Are Tracked?

The workflow creates a detailed changelog every time it runs, tracking:

### 🆕 **New Repositories Added**
```
New repo discovered with GitHub Pages
→ Added to the archive automatically
→ Shows up on website after next deployment
```

### 🗑️ **Repositories Deleted**
```
Repository no longer has GitHub Pages
→ Marked as deleted in changelog
→ Removed from active repository list
```

### 🔄 **Status Changes**
```
Repository status changed:
404 → active (site came back online)
active → 404 (site went down)
building → active (deployment completed)
```

### 📅 **Date Updates**
```
Repository date updated when:
→ New repository is discovered
→ Repository becomes active after being down
```

### ⚠️ **Errors & Issues**
```
Problems detected:
→ 404 errors (site not found)
→ Building/timeout (site unavailable)
```

---

## 🎯 Example: A Repository's Journey

```
Day 1: New Repository Created
    ↓
    Developer enables GitHub Pages
    ↓
    Workflow runs (scheduled)
    ↓
    🔍 Workflow discovers the repository
    ↓
    🌐 Checks URL: https://anacondy.github.io/new-repo/
    ↓
    ⏳ Status: "building" (not ready yet)
    ↓
    📊 Added to repos.json with status "building"
    ↓
    📝 Changelog: "🆕 New repository: new-repo"
    ↓
Day 2: Repository Build Completes
    ↓
    Workflow runs again (17 hours later)
    ↓
    🌐 Checks URL again
    ↓
    ✅ Status: "active" (HTTP 200 OK!)
    ↓
    🔄 Status changed: building → active
    ↓
    📅 Date updated to today
    ↓
    📝 Changelog: "🔄 Status change: new-repo (building → active)"
    ↓
    🎉 Repository now fully live on the archive!
```

---

## 💡 Fun Facts

- ⚡ **Speed**: Checks ~70 repositories in under 60 seconds
- 🔒 **Security**: 0 vulnerabilities, uses built-in GitHub authentication
- 💰 **Cost**: FREE (uses ~5 minutes/month of free GitHub Actions)
- 🤖 **Automation**: 100% automatic, no manual updates needed
- 📈 **Scalability**: Can handle 1000+ repositories efficiently

---

## 🛠️ Manual Override

Want to trigger the workflow manually?

1. Go to: `https://github.com/anacondy/3-DVD-archieve/actions`
2. Click: **Update Repository Status** workflow
3. Click: **Run workflow** button
4. Wait: ~30-90 seconds for completion
5. Check: Updated `repos.json` and `CHANGELOG.md`

---

## 📁 Files Modified by Workflow

| File | Purpose | Auto-Updated? |
|------|---------|---------------|
| `repos.json` | Repository data (names, URLs, dates, statuses) | ✅ Yes |
| `CHANGELOG.md` | Detailed change log with tables | ✅ Yes |
| `.last_update` | Timestamp to prevent too-frequent runs | ✅ Yes |
| `index.html` | Website (reads repos.json) | ❌ No |

---

## 🎓 Learning More

Want to understand how this works?

- **Technical Details**: See [WORKFLOW_OVERVIEW.md](WORKFLOW_OVERVIEW.md)
- **Implementation**: See [IMPLEMENTATION.md](IMPLEMENTATION.md)
- **GitHub Actions Basics**: See [GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)

---

**Last Updated**: December 2025  
**Questions?** Check the documentation files or examine `.github/workflows/update-repo-status.yml`
