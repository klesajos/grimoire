# starter-spell 🪄

The **copy-me template**. It ships one example of every Claude Code plugin
component, so you can see each format and keep only the ones you need.

## What's inside

```
starter-spell/
├─ .claude-plugin/
│  └─ plugin.json                 # manifest (name, version, author) — REQUIRED
├─ skills/
│  └─ hello-grimoire/SKILL.md     # ① spell      (skill)        — LIVE
├─ commands/
│  └─ cast.md                     # ② incantation (command)     — LIVE
├─ agents/
│  └─ familiar.md                 # ③ familiar   (agent)        — LIVE
├─ hooks/
│  └─ hooks.json.example          # ④ ward       (hook)         — dormant
├─ scripts/
│  └─ ward.sh                     # the hook's shell script
├─ .mcp.json.example              # ⑤ conduit    (MCP server)   — dormant
└─ .lsp.json.example              # ⑥ (LSP server)              — dormant
```

**Live** = loads and works the moment the plugin is enabled (safe; only acts
when invoked). **Dormant** = ships as a `.example` file that Claude Code ignores
until you activate it (these three have side effects on enable, so they're off
by default).

Activate a dormant component by **renaming** it (drop `.example`). Remove any
component by **deleting** its file/folder. Details per component below.

---

## ① Spell — `skills/hello-grimoire/SKILL.md`

**What it is:** a skill. Claude invokes it automatically when its `description`
matches the task, or you run it as `/starter-spell:hello-grimoire`.

- **Setup:** none. Auto-discovered from `skills/`.
- **Make it yours:** edit `SKILL.md`. The `description` frontmatter is what the
  model matches on — make it specific (include trigger phrases). Add supporting
  files (`reference.md`, `scripts/`) in the same folder if needed.
- **To remove:** delete `skills/hello-grimoire/` (or the whole `skills/` folder).

## ② Incantation — `commands/cast.md`

**What it is:** a slash command. Runs only when the user types
`/starter-spell:cast`.

- **Setup:** none. Auto-discovered from `commands/`.
- **Make it yours:** rename the file (the filename becomes the command name) and
  rewrite the body. Use `$ARGUMENTS` for input; declare `argument-hint` /
  `allowed-tools` in frontmatter.
- **To remove:** delete the `.md` file (or the whole `commands/` folder).

## ③ Familiar — `agents/familiar.md`

**What it is:** a subagent. Dispatched into its own context window for a focused
task. Safe to ship live — it only runs when invoked.

- **Setup:** none. Auto-discovered from `agents/`.
- **Make it yours:** edit the frontmatter (`name`, `description`, `model`, and
  optionally `effort`, `maxTurns`, `tools`, `disallowedTools`, `skills`,
  `isolation: worktree`). Write a sharp system prompt in the body. Note: plugin
  agents may **not** declare `hooks`, `mcpServers`, or `permissionMode`.
- **To remove:** delete the `.md` file (or the whole `agents/` folder).

## ④ Ward — `hooks/hooks.json.example` + `scripts/ward.sh`

**What it is:** a hook. Runs automatically on a lifecycle event (this example
fires on `SessionStart` and runs `scripts/ward.sh`). **Fires without asking** —
that's the power and the risk.

- **Activate:** `mv hooks/hooks.json.example hooks/hooks.json`
- **Setup:** make the script executable — `chmod +x scripts/ward.sh` — or the
  hook silently does nothing. Reference bundled scripts via
  `"${CLAUDE_PLUGIN_ROOT}"` (plugins run from a cache dir, not in place).
- **Make it yours:** change the event (`PreToolUse`, `PostToolUse`,
  `UserPromptSubmit`, `Stop`, …) and `matcher` (e.g. `"Write|Edit"`); rewrite the
  script. Hook types: `command`, `http`, `mcp_tool`, `prompt`, `agent`.
- **To remove:** delete `hooks/` and `scripts/ward.sh`.

## ⑤ Conduit — `.mcp.json.example`

**What it is:** a bundled MCP server — connects Claude to an external tool or
service. The example points at the official `@modelcontextprotocol/server-everything`
demo server (a real, runnable MCP server fetched via `npx`).

- **Activate:** `mv .mcp.json.example .mcp.json`
- **Setup:** the example needs only Node/`npx` (server is fetched on first run).
  A real conduit needs whatever its server needs — bundle a binary under the
  plugin and reference it with `${CLAUDE_PLUGIN_ROOT}`, or point at an installed
  command. Secrets go in `env` / `userConfig`, never hardcoded.
- **Caution:** an active MCP server **spawns a process every session** it's
  enabled. Leave it dormant until you need it.
- **To remove:** delete `.mcp.json.example` (and `.mcp.json` if you renamed it).

## ⑥ LSP — `.lsp.json.example`

**What it is:** a Language Server config — gives Claude diagnostics, go-to-def,
and find-references while editing. The example wires up
`typescript-language-server`.

- **Activate:** `mv .lsp.json.example .lsp.json`
- **Setup (required):** install the language-server binary yourself — it is
  **not** bundled. For the example:
  `npm install -g typescript-language-server typescript`. Without it you'll see
  `Executable not found in $PATH` in the `/plugin` Errors tab.
- **Make it yours:** swap `command` and `extensionToLanguage` for your language
  (e.g. `gopls`, `pyright`, `rust-analyzer`).
- **To remove:** delete `.lsp.json.example` (and `.lsp.json` if you renamed it).

---

## Other components (not scaffolded here)

Plugins can also ship: **output styles** (`output-styles/`), **themes**
(`themes/*.json`), **background monitors** (`monitors/monitors.json`), and
**executables** (`bin/`, added to the Bash `PATH`). See
https://code.claude.com/docs/en/plugins-reference for those.

## Conjure a new plugin from this template

1. `cp -r plugins/starter-spell plugins/<your-plugin>`
2. Edit `<your-plugin>/.claude-plugin/plugin.json` → set `name`, `description`,
   bump `version` (or omit `version` to track every commit).
3. Keep the components you want, delete the rest (table above).
4. Add an entry to `.claude-plugin/marketplace.json` with
   `"source": "./plugins/<your-plugin>"`.
5. Validate, then test locally:
   ```bash
   claude plugin validate .
   claude plugin validate ./plugins/<your-plugin>
   claude plugin marketplace add ./
   claude plugin install <your-plugin>@grimoire
   ```

**Forks** you don't want to vendor: list them in `marketplace.json` with a
GitHub source — `"source": { "source": "github", "repo": "owner/repo", "ref": "main" }`.
