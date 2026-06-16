---
description: Health-check the Enterprise Architect MCP conduit — runs an ordered preflight (connection, project open, write tools, working diagrams) and reports the most likely fix per failed step.
argument-hint: "(no arguments)"
---

You were invoked via `/archmage:ea-doctor`. Run a **deterministic, ordered preflight** of the
`enterprise-architect` MCP conduit and report a concise pass/fail per step with the most likely
fix. Do **not** create, modify, or delete anything — this is read-only diagnostics. Use
fully-qualified tool names.

Run these checks in order; stop early only if a step makes later steps impossible, and say so:

**1. Conduit + project-open check.**
Call `enterprise-architect:get_root_packages`.
- ✅ Returns packages → the server is up and a project is open. List the root package names.
- ❌ Errors / times out → report the cause ladder, most-likely first:
  1. No project open in EA (open a repository — most common cause).
  2. EA not running (launch it).
  3. Two EA instances open → COM ambiguity (close all but one).
  4. Server started before EA / stale (fully restart the client so MCP3.exe re-spawns).
  5. EA blocked on a modal dialog, or genuinely slow under ARM64 emulation (raise `-setTimeout`).

**2. Write-tools check.**
This is an **operator-side** check — a command can't reliably introspect its own live tool
catalog, so frame it as guidance rather than a verdict you derive. Tell the operator:
> If you do **not** see `enterprise-architect:create_or_update_*` tools in my catalog, then
> `-enableEdit` is off or the client was not restarted.
- ✅ If those write tools are present → editing is enabled.
- ❌ If they are absent → `-enableEdit` did not take effect. Fixes: ensure `-enableEdit` is in the
  server args (`claude mcp list` / `.mcp.json`), then **fully restart the client** (a running
  server ignores new args).

**3. Working-context check.**
Call `enterprise-architect:get_opened_diagrams`.
- Report which diagrams are open. Note: a diagram must be **open** before creating sequence
  messages, or they silently duplicate.

**4. Config echo.**
Show the expected Claude Code `.mcp.json` shape so the user can compare:
```json
{ "mcpServers": { "enterprise-architect": { "type": "stdio", "command": "MCP3.exe", "args": ["-enableEdit", "-setTimeout", "60"] } } }
```
Remind them `"type":"stdio"` is required and the absolute path to `MCP3.exe` may be needed if it
isn't on PATH. Link the install/troubleshooting source:
https://github.com/klesajos/enterprise-architect-mcp-arm64 .

Finish with a one-line verdict: **READY** (steps 1–3 green) or **NOT READY** with the single most
important next action. Keep the whole report compact — a checklist, not an essay. For deeper
diagnostics, point to the `ea-mcp` spell's `troubleshooting.md`.
