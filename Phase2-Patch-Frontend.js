#!/usr/bin/env node
/**
 * Phase 2 Frontend Security Patch
 * Hardens index.html without changing visual behavior.
 * Fixes:
 *   1. Tabnapping: adds rel="noopener noreferrer" to target="_blank" links
 *   2. DOM XSS defense: replaces innerHTML with safe DOM construction
 * Usage: node Phase2-Patch-Frontend.js
 */
const fs = require('fs');
const path = 'index.html';

if (!fs.existsSync(path)) {
  console.error('ERROR: index.html not found in current directory.');
  process.exit(1);
}

let text = fs.readFileSync(path, 'utf8');

// Fix 1: Add rel="noopener noreferrer" after target="_blank"
// This prevents the opened tab from accessing window.opener (tabnapping).
text = text.replace(
  'link.target = "_blank"; // Open in new tab',
  'link.target = "_blank";\n                link.rel = "noopener noreferrer"; // Security: prevent tabnapping'
);

// Fix 2: Replace innerHTML with safe DOM construction (textContent)
// This ensures repo names cannot inject HTML/JS even if GitHub API is compromised.
const oldBlock = `                link.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items: center;">
                        <span class="truncate pr-4">${idxStr}. ${repo.name}</span>
                        <span class="dim-text text-xs whitespace-nowrap">${formatRetroDate(repo.date)}</span>
                    </div>
                `;`;

const newBlock = `                // Phase 2: safe DOM construction (prevents XSS injection)
                const div = document.createElement('div');
                div.style.display = 'flex';
                div.style.justifyContent = 'space-between';
                div.style.alignItems = 'center';

                const nameSpan = document.createElement('span');
                nameSpan.className = 'truncate pr-4';
                nameSpan.textContent = \`\${idxStr}. \${repo.name}\`;

                const dateSpan = document.createElement('span');
                dateSpan.className = 'dim-text text-xs whitespace-nowrap';
                dateSpan.textContent = formatRetroDate(repo.date);

                div.appendChild(nameSpan);
                div.appendChild(dateSpan);
                link.appendChild(div);`;

if (!text.includes(oldBlock)) {
  console.log('WARNING: Could not find exact innerHTML block to replace.');
  console.log('It may have already been patched, or formatting differs slightly.');
  console.log('Please check index.html manually.');
} else {
  text = text.replace(oldBlock, newBlock);
  console.log('✅ Patched innerHTML → safe DOM construction');
}

fs.writeFileSync(path, text);
console.log('✅ Frontend patch applied to index.html');
console.log('Changes: rel="noopener noreferrer" added, innerHTML replaced with createElement/textContent.');
