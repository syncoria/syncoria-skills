#!/usr/bin/env python3
"""Guardrails for docs/bootstrap.json. Runs in CI before every GitHub Pages deploy."""
import json, pathlib
from urllib.parse import urlparse

PAGES_ORIGIN = "https://syncoria.github.io"
p = pathlib.Path("docs/bootstrap.json")
d = json.loads(p.read_text(encoding="utf-8"))

pinned = {
    "inferenceProvider": "bedrock",
    "inferenceBedrockRegion": "ca-central-1",
    "inferenceCredentialKind": "interactive",
    "inferenceBedrockSsoStartUrl": "https://d-9d674bb3b9.awsapps.com/start",
    "inferenceBedrockSsoRegion": "ca-central-1",
    "inferenceBedrockSsoAccountId": "537124957474",
    "inferenceBedrockSsoRoleName": "ClaudeCodeDeveloper",
}
for k, v in pinned.items():
    assert d.get(k) == v, "Blocked: protected SSO or Bedrock field " + k
assert d.get("inferenceModels"), "At least one model required"
assert d.get("disableDeploymentModeChooser") is True, "Devices must stay on the Syncoria profile"
assert d.get("disableBypassPermissionsMode") is True, "Bypass-permissions mode must stay disabled"
assert not d.get("mcpPersistentAlwaysAllowEnabled"), "Persistent MCP tool approval disallowed"

for m in d.get("allowedPluginMarketplaces", []):
    assert m.get("source") in ("github", "git", "url"), "Bad marketplace source"
    if m["source"] == "url":
        u = urlparse(m["url"])
        assert u.scheme == "https" and not u.query, "Marketplace URL must be bare https"
        assert f"{u.scheme}://{u.netloc}" == PAGES_ORIGIN, "Syncoria marketplace must share the bootstrap origin"

names = set()
for s in d.get("managedMcpServers", []):
    assert s.get("name") and s["name"] not in names, "Connector names must be unique"
    names.add(s["name"])
    if "server" in s:
        assert not ({"url", "transport", "command"} & s.keys()), "Built-in entries cannot mix fields"
    else:
        assert s.get("transport") in ("http", "sse", "stdio"), "Connector needs a transport: " + s["name"]
        if s["transport"] != "stdio":
            assert s["url"].startswith("https://"), "Remote connectors must be https: " + s["name"]

assert len(d.get("organizationInstructions", "")) <= 3000, "organizationInstructions over 3,000 chars"

def walk(v):
    if isinstance(v, dict):
        for k, x in v.items():
            if any(y in k.lower() for y in ("password", "secret", "apikey", "privatekey", "bearertoken")):
                raise AssertionError("Secret-like field not allowed in a public bootstrap: " + k)
            walk(x)
    elif isinstance(v, list):
        for x in v:
            walk(x)
walk(d)
print("Validation passed. Models:", len(d["inferenceModels"]), "connectors:", len(names),
      "marketplaces:", len(d.get("allowedPluginMarketplaces", [])))
