---
name: ea-mcp
description: Operates the Enterprise Architect MCP conduit (server "enterprise-architect", MCP3.exe). Covers connection prerequisites, the read and write tool catalog, schema gotchas (taggedValues arrays, connector direction "Unspecified", EA type strings), and troubleshooting. Use when the EA MCP fails or misbehaves, when "Failed to connect to Enterprise Architect" or timeouts appear, when write/edit tools are missing (-enableEdit, restart), when a tool errors or returns unexpected IDs, or when setting up, configuring, or learning the EA MCP tools. Synonyms: Sparx EA, Enterprise Architect MCP, EA conduit, MCP3.
---

# ea-mcp — operate the Enterprise Architect conduit

This spell is the **operator's manual** for the `enterprise-architect` MCP server (Sparx Systems'
"MCP Server for Enterprise Architect", `MCP3.exe`). It is the spell to reach for when the conduit
needs **setting up, understanding, or fixing** — not for building a model (that is `ea-modeling`).

## When to use this spell

- The EA MCP is being **configured or installed**, or you need to know which tools exist.
- A tool **errors, times out, or returns surprising results** ("Failed to connect to Enterprise Architect", "Selection information is unavailable on hidden diagrams", missing write tools).
- You need to confirm **prerequisites** before any EA work.

**When NOT to use:** to actually create/read a model, use `ea-modeling` (the build & read
workflow). For notation rules, use `uml` / `bpmn` / `archimate` / `togaf` / `mermaid`.

## How the conduit works (one-line mental model)

```
Claude Code  ──stdio──▶  MCP3.exe (server)  ──named pipe──▶  MCP_EA add-in (inside EA.exe)  ──COM──▶  EA repository
```

The server never touches EA's COM directly; the add-in inside a **running EA with a project open**
does. So **EA must be running with a repository open** for anything to work, and only **one** EA
instance may be open (two → COM ambiguity → timeouts).

## Prerequisites checklist (read this first when something is off)

1. **EA is running** and a **project/repository is open** (`.eapx` / `.qea` / `.feap`). A timeout
   or "Failed to connect" almost always means this is not true.
2. **Exactly one** EA instance is open.
3. For **editing**, `MCP3.exe` was launched with **`-enableEdit`**, and the client was **fully
   restarted** afterwards (a running server does not re-read its args). Until then only read tools appear.
4. The install is correct — see https://github.com/klesajos/enterprise-architect-mcp-arm64 .

Run the `/archmage:ea-doctor` command for an automated pass through this checklist.

## Reference files (open on demand)

| File | Open it when… |
| --- | --- |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-mcp/reference/setup-and-connection.md` | Installing/configuring the server, writing `.mcp.json`, enabling write tools. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-mcp/reference/tool-catalog-read.md` | You need to know which **read** tool to call and its purpose. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-mcp/reference/tool-catalog-write.md` | You need a **write** tool and its array-in / IDs-out contract. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-mcp/reference/schema-gotchas.md` | A tool errors on its payload, or before writing anything (the load-bearing traps). |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-mcp/reference/troubleshooting.md` | A tool failed and you need the cause→fix table. |

The canonical EA **type strings** (diagram/element/connector) live once in
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

## The five rules that prevent most damage

1. `taggedValues` is an **array of `{name,value}`**, never a map.
2. Connector `direction: "Source -> Destination"` **fails** → use `"Unspecified"`.
3. `create_or_update_*` take **arrays** and **return IDs** → create the parent package first.
4. `place_elements_on_diagram` needs **x/y > 10**.
5. There is **no delete tool for packages/elements** → name throwaways `ZZ_*`.

Always use **fully-qualified** tool names (`enterprise-architect:get_root_packages`,
`enterprise-architect:create_or_update_elements`, …) so the right server is targeted.
