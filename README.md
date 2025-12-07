# 3-DVD-archieve

A retro DVD-style interface for browsing the Anacondy archive collection.

**Live Site:** https://anacondy.github.io/3-DVD-archieve/

## Screenshots

### Desktop View
![Desktop Archive View](https://github.com/user-attachments/assets/f336b951-561a-42ce-ba84-5a20ff6ade4a)

### Mobile View (16:9 / 20:9 optimized)
![Mobile Archive View](https://github.com/user-attachments/assets/8ac9edb2-7202-4e59-948a-359402bbcc82)

## Features

- 🎮 Retro CRT-style visual effects with scanlines and vignette
- ✨ Interactive particle system with smooth 60fps animations
- 🔊 Immersive audio effects with Web Audio API
- 📱 Fully responsive design optimized for mobile devices (16:9 and 20:9 aspect ratios)
- 🎨 Animated ANACONDY signature with glowing pulse effect
- 📅 Archive entries with proper date formatting
- 🖱️ Touch-friendly scrolling and interactions
- 🤖 **Automated repository discovery** - updates every ~17 hours (10x per week)
- 📊 **Change tracking** - see what's new in [CHANGELOG.md](CHANGELOG.md)
- 🔄 **Automated workflow** - GitHub Actions workflow automatically manages repository status

## Documentation

- **[WORKFLOW_OVERVIEW.md](WORKFLOW_OVERVIEW.md)** - Complete workflow diagram and data flow documentation
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Technical implementation details
- **[GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)** - Educational guide to GitHub Actions
- **[CHANGELOG.md](CHANGELOG.md)** - Auto-generated change log

## How It Works

The site is powered by an automated GitHub Actions workflow that:

1. **Discovers repositories** from the anacondy organization via GitHub API
2. **Filters** to only include repositories with GitHub Pages enabled
3. **Checks status** of each repository URL (active, 404, or building)
4. **Updates** the repository list automatically every ~17 hours
5. **Tracks changes** and generates detailed changelog reports
6. **Commits changes** back to the repository automatically

See [WORKFLOW_OVERVIEW.md](WORKFLOW_OVERVIEW.md) for detailed workflow diagrams and technical flow.

## Author

**ANACONDY** - System Architect
