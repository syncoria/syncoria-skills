#!/usr/bin/env python3
import json, pathlib, sys
p=pathlib.Path("docs/bootstrap.json")
d=json.loads(p.read_text(encoding="utf-8"))
pinned={
  "inferenceProvider":"bedrock",
  "inferenceBedrockRegion":"ca-central-1",
  "inferenceBedrockSsoStartUrl":"https://d-9d674bb3b9.awsapps.com/start",
  "inferenceBedrockSsoRegion":"ca-central-1",
  "inferenceBedrockSsoAccountId":"537124957474",
  "inferenceBedrockSsoRoleName":"ClaudeCodeDeveloper",
}
for k,v in pinned.items():
  assert d.get(k)==v, "Blocked: protected SSO or Bedrock field "+k
assert len(d.get("inferenceModels",[]))>0, "At least one model required"
assert not d.get("isClaudeCodeForDesktopEnabled"), "Business profile must not enable Claude Code"
assert not d.get("developerModeEnabled"), "Business profile must not enable Developer Mode"
assert not d.get("isLocalDevMcpEnabled"), "Business profile must not enable local dev MCP"
assert not d.get("mcpPersistentAlwaysAllowEnabled"), "Persistent MCP tool approval disallowed"
def walk(v):
  if isinstance(v,dict):
    for k,x in v.items():
      if any(y in k.lower() for y in ("password","secret","apikey","privatekey","bearertoken")):raise AssertionError("Secret-like field not allowed: "+k)
      walk(x)
  elif isinstance(v,list):
    for x in v:walk(x)
walk(d)
print("Validation passed. Models:",len(d["inferenceModels"]),"connectors:",len(d.get("managedMcpServers",[])))
