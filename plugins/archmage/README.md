# archmage 🧙‍♂️

> *The architect's grimoire — model in Enterprise Architect, UML, BPMN, ArchiMate, TOGAF, and Mermaid.*

`archmage` turns Claude Code into a capable enterprise-architecture assistant. It pairs the
**mechanics** of driving Sparx Enterprise Architect through its MCP conduit with the **knowledge**
to model correctly in the major notations and frameworks.

## What's inside

### Conduit (MCP) — dormant by default

`.mcp.json.example` wires up the **`enterprise-architect`** MCP server (`MCP3.exe`). It ships
disabled — activate it (see *Setup* below). Install the server itself from
[enterprise-architect-mcp-arm64](https://github.com/klesajos/enterprise-architect-mcp-arm64).

### Spells (skills)

| Spell | What it covers |
| --- | --- |
| `ea-mcp` | Operate the conduit: setup, connection prerequisites, the read+write tool catalog, schema gotchas, troubleshooting. Reach for it when the MCP **misbehaves**. |
| `ea-modeling` | Build **and** read EA models: the create→connect→diagram→place→layout→verify workflow, reading recipes, and notation→EA type mapping. |
| `uml` | UML 2.5.1 — all 14 diagrams, notation rules, worked examples, Mermaid + EA bridges. |
| `bpmn` | BPMN 2.0.2 — events, activities, gateways, flows, pools/lanes, token semantics. |
| `archimate` | ArchiMate 3.2 — layers, elements, relationships, viewpoints, EA bridge. |
| `togaf` | TOGAF Standard 10th Edition — the ADM, content framework, governance, ArchiMate mapping. |
| `mermaid` | Mermaid diagram-as-code across every current diagram type (beta types flagged). |

### Incantation (command)

- `/archmage:ea-doctor` — ordered preflight of the conduit (connection, project open, write tools,
  open diagrams) with the most likely fix per failed step.

### Familiar (agent)

- `ea-modeller` — builds large/multi-diagram EA models in an isolated context, so the dozens of
  create/place/layout/verify calls stay out of the main chat. It owns the verify loop and the
  duplicate-message guard and reports back the created IDs.

### Shared reference

- `shared/reference/ea-type-cheatsheet.md` — the single source of truth for EA diagram/element/
  connector **type strings** and the hard schema rules. Not a skill; the spells point at it.

## Setup

1. **Install the MCP server** per
   [enterprise-architect-mcp-arm64](https://github.com/klesajos/enterprise-architect-mcp-arm64).
2. **Enable the conduit.** Either run, from Claude Code:
   ```bash
   claude mcp add --transport stdio --scope user enterprise-architect -- "C:\Program Files\Sparx Systems\EA\MCP_Server\MCP3.exe" -enableEdit -setTimeout 60
   ```
   …or rename this plugin's `.mcp.json.example` to `.mcp.json` in your project root.
3. **Required for editing:** the `-enableEdit` arg makes the write tools appear, and a running
   server won't re-read its args — **fully restart the client** after any config change.
4. **Required for anything:** EA must be **running with a repository open**, and only **one** EA
   instance may be open. Run `/archmage:ea-doctor` to confirm.

Notes: Claude Code requires `"type": "stdio"` in `.mcp.json` (Claude Desktop omits it). If
`MCP3.exe` isn't on PATH, use its absolute path. Large builds may need a bigger `-setTimeout`; a
timeout mid-build can leave a partial model (each write commits independently).

## How the pieces fit

- Notation question ("how do I draw a valid sequence diagram?") → the notation spell (`uml`,
  `bpmn`, `archimate`, `togaf`, `mermaid`).
- "Build/read it **in EA**" → `ea-modeling` (mechanics) + the notation spell (grammar). They
  co-activate by design.
- "The MCP is broken / how do I set it up?" → `ea-mcp` (+ `/archmage:ea-doctor`).

## License

[MIT](../../LICENSE) © Josef Klesa. Enterprise Architect is a Sparx Systems product; this plugin
only drives its MCP and is not affiliated with Sparx Systems.
