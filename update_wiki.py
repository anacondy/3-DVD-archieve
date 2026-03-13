import json
import os
from datetime import datetime

def parse_date(date_str):
    try:
        return datetime.strptime(date_str, "%Y-%m-%dT%H:%M:%SZ").strftime("%dth %b, %Y")
    except:
        return date_str

def calculate_date_gap(added_date_str, created_date_str):
    try:
        added_date = datetime.strptime(added_date_str, "%dth %b, %Y")
        created_date = datetime.strptime(created_date_str, "%dth %b, %Y")
        delta = added_date - created_date
        return f"{delta.days} days"
    except:
        return "N/A"

def generate_markdown_table(repos):
    table_rows = []
    for repo in repos:
        name = repo.get("name", "")
        html_url = repo.get("html_url", "")
        created_at = parse_date(repo.get("created_at", ""))
        updated_at = parse_date(repo.get("updated_at", ""))
        date_gap = calculate_date_gap(updated_at, created_at)
        
        table_rows.append(
            f"| {name} | [Link]({html_url}) | {updated_at} | {created_at} | {date_gap} | active | #128 |"
        )
    
    return "\n".join(table_rows)

def update_wiki_page():
    with open("repos.json", "r") as f:
        repos = json.load(f)
    
    table_content = generate_markdown_table(repos)
    
    # Update the wiki page content
    wiki_content = f"""# Repository Status and History

## Workflow #128 ({datetime.now().strftime("%dth %b, %Y")})
- Previous version: {len(repos)} repositories
- New version: {len(repos)} repositories
- Additions: 0 repositories
- Deletions: 0 repositories

| Repository Name | Link | Added Date | Creation Date | Date Gap | Status | Workflow Version |
|-----------------|------|------------|----------------|----------|--------|------------------|
{table_content}
"""
    
    with open("wiki/Repository-Status-and-History.md", "w") as f:
        f.write(wiki_content)

if __name__ == "__main__":
    update_wiki_page()