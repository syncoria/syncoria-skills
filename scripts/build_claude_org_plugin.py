#!/usr/bin/env python3
"""Build the Syncoria organization-managed Claude Desktop plugin from root skills."""
import hashlib, json, os, re, shutil, tempfile, zipfile
from datetime import datetime, timezone
from pathlib import Path

root=Path(__file__).resolve().parents[1]
dest=root/"dist"
excluded={".git",".github",".claude-plugin","scripts","dist","node_modules"}
skills=[p for p in sorted(root.iterdir()) if p.is_dir() and p.name not in excluded and (p/"SKILL.md").is_file()]
if not skills: raise SystemExit("No skills with SKILL.md detected.")
for skill in skills:
    if not re.fullmatch(r"[a-z][a-z0-9_-]*",skill.name): raise SystemExit("Bad skill name: "+skill.name)
if dest.exists(): shutil.rmtree(dest)
dest.mkdir()
with tempfile.TemporaryDirectory() as tmp:
    plugin=Path(tmp)/"syncoria-skills"
    plugin.mkdir()
    for skill in skills:
        for item in skill.rglob("*"):
            if item.is_symlink(): raise SystemExit("Symlink in skill: "+str(item))
            if item.is_file() and item.stat().st_size > 8000000: raise SystemExit("Oversized skill asset: "+str(item))
        shutil.copytree(skill,plugin/"skills"/skill.name,ignore=shutil.ignore_patterns(".git","__pycache__","node_modules"))
    manifest_dir=plugin/".claude-plugin"
    manifest_dir.mkdir()
    version="1.0."+str(int(os.environ.get("GITHUB_RUN_NUMBER","0")))
    manifest={"name":"syncoria-skills","version":version,"description":"Organization managed Syncoria skills","author":{"name":"Syncoria"}}
    (manifest_dir/"plugin.json").write_text(json.dumps(manifest,indent=2)+"\n",encoding="utf-8")
    (plugin/"release.json").write_text(json.dumps({"sha":os.environ.get("GITHUB_SHA","local"),"skills":[s.name for s in skills]},indent=2)+"\n",encoding="utf-8")
    archive=dest/"syncoria-skills.zip"
    with zipfile.ZipFile(archive,"w",compression=zipfile.ZIP_DEFLATED) as z:
        for file in sorted(plugin.rglob("*")):
            if file.is_file(): z.write(file,file.relative_to(Path(tmp)).as_posix())
    with zipfile.ZipFile(archive) as z:
        if z.testzip(): raise SystemExit("Archive checksum error")
        for skill in skills:
            if "syncoria-skills/skills/"+skill.name+"/SKILL.md" not in z.namelist(): raise SystemExit("Missing skill: "+skill.name)
sha=hashlib.sha256(archive.read_bytes()).hexdigest()
commit=os.environ.get("GITHUB_SHA","local")
meta={"schemaVersion":1,"sha":commit,"sha256":sha,"file":"syncoria-skills.zip","version":version,"skillCount":len(skills),"skillNames":[s.name for s in skills],"publishedAt":datetime.now(timezone.utc).isoformat(),"s3Key":"releases/"+commit+"/syncoria-skills.zip"}
(dest/"latest.json").write_text(json.dumps(meta,indent=2)+"\n",encoding="utf-8")
(dest/"syncoria-skills.zip.sha256").write_text(sha+"  syncoria-skills.zip\n",encoding="utf-8")
print("Built",len(skills),"skills. sha256:",sha)
