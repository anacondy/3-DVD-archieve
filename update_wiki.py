import json
import os
from datetime import datetime


def load_repositories(path):
    with open(path, "r", encoding="utf-8") as f:
        payload = json.load(f)

    if isinstance(payload, dict):
        message = payload.get("message", "Unexpected JSON object in repos file")
        raise ValueError(f"Invalid repositories payload: {message}")

    if not isinstance(payload, list):
        raise ValueError("Invalid repositories payload: expected a JSON array")

    return payload

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
    run_number = os.environ.get("GITHUB_RUN_NUMBER", "Unknown")
    for repo in repos:
        if not isinstance(repo, dict):
            continue

        name = repo.get("name", "")
        html_url = repo.get("html_url", "")
        created_at = parse_date(repo.get("created_at", ""))
        updated_at = parse_date(repo.get("updated_at", ""))
        date_gap = calculate_date_gap(updated_at, created_at)

        table_rows.append(
            f"| {name} | [Link]({html_url}) | {updated_at} | {created_at} | {date_gap} | active | #{run_number} |"
        )

    return "\n".join(table_rows)

def update_wiki_page():
    # Read repos.json from the current directory
    repos = load_repositories("repos.json")

    table_content = generate_markdown_table(repos)
    run_number = os.environ.get("GITHUB_RUN_NUMBER", "Unknown")

    # Update the wiki page content
    wiki_content = f"""# Repository Status and History

## Workflow #{run_number} ({datetime.now().strftime("%dth %b, %Y")})
- Previous version: {len(repos)} repositories
- New version: {len(repos)} repositories
- Additions: 0 repositories
- Deletions: 0 repositories

| Repository Name | Link | Added Date | Creation Date | Date Gap | Status | Workflow Version |
|-----------------|------|------------|----------------|----------|--------|------------------|
{table_content}
"""
    
    # Ensure the wiki directory exists
    os.makedirs("wiki", exist_ok=True)
    with open("wiki/Repository-Status-and-History.md", "w") as f:
        f.write(wiki_content)

if __name__ == "__main__":
    update_wiki_page()