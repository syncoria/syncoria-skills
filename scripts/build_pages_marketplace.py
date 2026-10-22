#!/usr/bin/env python3
"""Build the GitHub Pages site: onboarding pages + a Claude plugin marketplace.

Claude Desktop auto-installs plugins marked "auto_install" in a marketplace.json
served from the same origin as bootstrapUrl, so every push to main republishes the
Syncoria skills and devices pick them up on their next periodic sync.
"""
import hashlib, json, os, shutil, subprocess, sys, zipfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
site = root / "_site"
base = os.environ.get("PAGES_BASE_URL", "https://syncoria.github.io/syncoria-skills").rstrip("/")
FIXED_TIME = (2026, 1, 1, 0, 0, 0)

if site.exists():
    shutil.rmtree(site)
shutil.copytree(root / "docs", site)
plugins = site / "plugins"
plugins.mkdir()

def sha256(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

# 1. Syncoria skills plugin (reuses the existing, verified builder)
subprocess.run([sys.executable, str(root / "scripts/build_claude_org_plugin.py")], check=True, cwd=root)
meta = json.loads((root / "dist/latest.json").read_text())
skills_zip = plugins / f"syncoria-skills-{meta['version']}.zip"
shutil.copy(root / "dist/syncoria-skills.zip", skills_zip)

# 2. Optional technical connectors plugin (local MCP servers that need Node.js)
dev_name, dev_version = "syncoria-dev-connectors", "1.0.0"
dev_files = {
    ".claude-plugin/plugin.json": {
        "name": dev_name, "version": dev_version,
        "description": "Playwright browser automation for technical staff (requires Node.js LTS)",
        "author": {"name": "Syncoria"},
    },
    ".mcp.json": {"mcpServers": {"playwright": {"command": "npx", "args": ["-y", "@playwright/mcp@latest"]}}},
}
dev_zip = plugins / f"{dev_name}-{dev_version}.zip"
with zipfile.ZipFile(dev_zip, "w", zipfile.ZIP_DEFLATED) as z:
    for rel, body in sorted(dev_files.items()):
        info = zipfile.ZipInfo(f"{dev_name}/{rel}", FIXED_TIME)
        info.compress_type = zipfile.ZIP_DEFLATED
        z.writestr(info, json.dumps(body, indent=2) + "\n")

# 3. Marketplace manifest (archives must share the manifest's origin)
marketplace = {
    "name": "syncoria-org",
    "owner": {"name": "Syncoria"},
    "plugins": [
        {
            "name": "syncoria-skills",
            "version": meta["version"],
            "description": f"Syncoria's {meta['skillCount']} company skills: Odoo method, estimation, discovery, design and code review",
            "installationPreference": "auto_install",
            "source": {"source": "archive", "url": f"{base}/plugins/{skills_zip.name}", "sha256": sha256(skills_zip)},
        },
        {
            "name": dev_name,
            "version": dev_version,
            "description": "Optional: Playwright browser automation connector for technical staff. Requires Node.js LTS on your computer.",
            "source": {"source": "archive", "url": f"{base}/plugins/{dev_zip.name}", "sha256": sha256(dev_zip)},
        },
    ],
}
(plugins / "marketplace.json").write_text(json.dumps(marketplace, indent=2) + "\n", encoding="utf-8")
(plugins / "latest.json").write_text(json.dumps({**meta, "file": skills_zip.name, "sha256": sha256(skills_zip)}, indent=2) + "\n")

# 4. Cross-check: bootstrap must point at this marketplace
boot = json.loads((site / "bootstrap.json").read_text(encoding="utf-8"))
urls = [m.get("url") for m in boot.get("allowedPluginMarketplaces", [])]
assert f"{base}/plugins/marketplace.json" in urls, "bootstrap.json does not reference the Pages marketplace"
(site / ".nojekyll").touch()
print("Site built:", skills_zip.name, "with", meta["skillCount"], "skills;", dev_zip.name)
