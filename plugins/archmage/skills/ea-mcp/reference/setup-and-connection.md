# EA MCP — setup & connection

## Contents
- [Install](#install)
- [Configure for Claude Code](#configure-for-claude-code)
- [Enabling write/edit tools](#enabling-writeedit-tools)
- [Confirming the connection](#confirming-the-connection)

## Install

The server is Sparx Systems' "MCP Server for Enterprise Architect" (`MCP3.exe`), an apphost that
talks to an EA add-in (`MCP_EA.dll`) loaded inside `EA.exe`. On native Windows ARM64 the official
x64/x86 MSIs will not install natively — use the repackaged Arm64 build and follow its README:

> https://github.com/klesajos/enterprise-architect-mcp-arm64

That repo's README covers the MSI, the registry-view/bitness gotchas, and a full client-setup
section (Desktop, Code, and `.mcp.json`).

## Configure for Claude Code

Two equivalent ways:

**A. One-shot CLI (registers for all projects):**

```bash
claude mcp add --transport stdio --scope user enterprise-architect -- "C:\Program Files\Sparx Systems\EA\MCP_Server\MCP3.exe" -enableEdit -setTimeout 60
```

Verify with `claude mcp list` (it should show `enterprise-architect`).

**B. Project-scoped `.mcp.json`** (commit it for a team). This plugin ships a ready copy as
`.mcp.json.example` — rename it to `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "enterprise-architect": {
      "type": "stdio",
      "command": "MCP3.exe",
      "args": ["-enableEdit", "-setTimeout", "60"]
    }
  }
}
```

Notes:
- **`"type": "stdio"` is required by Claude Code** — the Claude Desktop config omits it, so don't copy that form verbatim.
- If `MCP3.exe` is **not on PATH**, put its absolute path in `command`, e.g.
  `"C:\\Program Files\\Sparx Systems\\EA\\MCP_Server\\MCP3.exe"` (escape backslashes in JSON).
- The first time Claude Code sees a project `.mcp.json` it asks for approval before spawning the server.

## Enabling write/edit tools

The write tools (`create_or_update_*`, `place_elements_on_diagram`, `layout_connectors`,
`delete_connectors_or_messages`, clone/baseline) **only load when `MCP3.exe` is launched with
`-enableEdit`**. Two consequences:

1. The `-enableEdit` arg must be present in your config (it is in the example above).
2. A **running server will not re-read its args**. After changing the config you must **fully
   restart the client** (in Claude Desktop: tray → Quit, not just close the window) so the server
   re-spawns. Only then do the write tools appear in the tool list.

`-setTimeout 60` raises the per-call timeout to 60s. EA under ARM64 emulation (32-bit EA) is slow;
**large model builds may need a larger value** (e.g. `-setTimeout 120`). A timeout mid-build can
leave a partial model because each write commits independently.

## Confirming the connection

The cheapest liveness probe is a read with no side effects:

```
enterprise-architect:get_root_packages
```

- Returns root packages → the conduit is healthy and a project is open.
- Errors / times out → see `troubleshooting.md` (usually: no project open, EA not running, or two
  EA instances).

To confirm write tools are active, check whether `enterprise-architect:create_or_update_package`
is present in the tool list. If it is absent, `-enableEdit` did not take effect (config or
restart). The `/archmage:ea-doctor` command automates this whole sequence.
