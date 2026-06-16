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
├─ .lsp.json.example              # ⑥ (LSP server)              — dormant
├─ output-styles/
│  └─ terse.md.example            # ⑦ output style              — dormant
├─ themes/
│  └─ grimoire-dark.json          # ⑧ theme                     — LIVE
├─ monitors/
│  └─ monitors.json.example       # ⑨ monitor                   — dormant
└─ bin/
   └─ starter-spell-tool          # ⑩ executable (on PATH)      — LIVE
```

**Live** = loads and works the moment the plugin is enabled (safe; only acts
when invoked). **Dormant** = ships as a `.example` file that Claude Code ignores
until you activate it (these three have side effects on enable, so they're off
by default).

Activate a dormant component by **renaming** it (drop `.example`). Remove any
component by **deleting** its file/folder. Details per component below.

## Component, or just a CLAUDE.md line?

Before building anything, ask whether plain text would do. A `CLAUDE.md` rule is
always-on context the model *should* follow — cheap, but only a request.

- **Instruction components** (skill, command, agent, output style) are, at heart,
  text the model reads — so CLAUDE.md *can* sometimes replace them. Reach for the
  component only when the guidance is long, relevant only sometimes (load it on
  demand instead of bloating every prompt), reusable across projects, or must be
  explicitly triggered.
- **Capability components** (hook, MCP, LSP, monitor, theme, bin) can **never** be
  replaced by CLAUDE.md. They *do* things text can't: run code deterministically,
  connect to external systems, render UI. If you need a guarantee or an external
  action, CLAUDE.md is never enough.

Each section below ends with a **vs CLAUDE.md** note marking where the line falls.

---

## ① Spell — `skills/hello-grimoire/SKILL.md`

**What it is:** a skill. Claude invokes it automatically when its `description`
matches the task, or you run it as `/starter-spell:hello-grimoire`.

- **Use it for:** Productivity — a `weekly-status` skill that turns rough notes
  into your team's status-report format. Coding — a `review-checklist` skill
  Claude auto-applies when reviewing a PR (N+1 queries, error handling, secrets).
- **Setup:** none. Auto-discovered from `skills/`.
- **Make it yours:** edit `SKILL.md`. The `description` frontmatter is what the
  model matches on — make it specific (include trigger phrases). Add supporting
  files (`reference.md`, `scripts/`) in the same folder if needed.
- **To remove:** delete `skills/hello-grimoire/` (or the whole `skills/` folder).
- **vs CLAUDE.md:** A skill wins when the guidance is long, only sometimes
  relevant (loaded on demand, so it doesn't bloat every prompt), reusable across
  projects, or ships scripts/reference files. CLAUDE.md is enough for a short,
  always-true project rule (e.g. "use strict types").

## ② Incantation — `commands/cast.md`

**What it is:** a slash command. Runs only when the user types
`/starter-spell:cast`.

- **Use it for:** Productivity — `/standup`: paste yesterday's notes, get a
  formatted update. Coding — `/scaffold-endpoint Orders`: generate a Laravel
  controller + service + test in your house conventions.
- **Setup:** none. Auto-discovered from `commands/`.
- **Make it yours:** rename the file (the filename becomes the command name) and
  rewrite the body. Use `$ARGUMENTS` for input; declare `argument-hint` /
  `allowed-tools` in frontmatter.
- **To remove:** delete the `.md` file (or the whole `commands/` folder).
- **vs CLAUDE.md:** A command is *triggered on demand* by typing `/x` — CLAUDE.md
  can't be invoked, it's passive context. Use a command for an explicit,
  parameterized, repeatable action; use CLAUDE.md when you just want default
  behavior to always apply.

## ③ Familiar — `agents/familiar.md`

**What it is:** a subagent. Dispatched into its own context window for a focused
task. Safe to ship live — it only runs when invoked.

- **Use it for:** Productivity — a `meeting-notes` familiar that digests a
  transcript into decisions + action items in its own context. Coding — a
  `test-writer` familiar dispatched to write tests while your main thread keeps
  building.
- **Setup:** none. Auto-discovered from `agents/`.
- **Make it yours:** edit the frontmatter (`name`, `description`, `model`, and
  optionally `effort`, `maxTurns`, `tools`, `disallowedTools`, `skills`,
  `isolation: worktree`). Write a sharp system prompt in the body. Note: plugin
  agents may **not** declare `hooks`, `mcpServers`, or `permissionMode`.
- **To remove:** delete the `.md` file (or the whole `agents/` folder).
- **vs CLAUDE.md:** An agent gives you an isolated context, its own model/tools,
  and parallel dispatch. CLAUDE.md can describe a role, but it all runs in one
  context window. Reach for an agent when you need separation or parallelism —
  not just instructions.

## ④ Ward — `hooks/hooks.json.example` + `scripts/ward.sh`

**What it is:** a hook. Runs automatically on a lifecycle event (this example
fires on `SessionStart` and runs `scripts/ward.sh`). **Fires without asking** —
that's the power and the risk.

- **Use it for:** Productivity — a `Stop` hook that appends a one-line session
  summary to your daily journal. Coding — a `PostToolUse` hook on `Write|Edit`
  that auto-runs `ruff`/`php-cs-fixer`, or a `PreToolUse` guard that blocks edits
  to `.env`.
- **Activate:** `mv hooks/hooks.json.example hooks/hooks.json`
- **Setup:** make the script executable — `chmod +x scripts/ward.sh` — or the
  hook silently does nothing. Reference bundled scripts via
  `"${CLAUDE_PLUGIN_ROOT}"` (plugins run from a cache dir, not in place).
- **Make it yours:** change the event (`PreToolUse`, `PostToolUse`,
  `UserPromptSubmit`, `Stop`, …) and `matcher` (e.g. `"Write|Edit"`); rewrite the
  script. Hook types: `command`, `http`, `mcp_tool`, `prompt`, `agent`.
- **To remove:** delete `hooks/` and `scripts/ward.sh`.
- **vs CLAUDE.md:** **Never** CLAUDE.md. A CLAUDE.md rule is a request the model
  may forget or skip; a hook is deterministic harness enforcement that fires
  every time, regardless of the model. If it *must* always happen (format, block,
  log), it's a hook.

## ⑤ Conduit — `.mcp.json.example`

**What it is:** a bundled MCP server — connects Claude to an external tool or
service. The example points at the official `@modelcontextprotocol/server-everything`
demo server (a real, runnable MCP server fetched via `npx`).

- **Use it for:** Productivity — connect Jira/Notion/your CRM so Claude reads
  tickets and logs activity directly. Coding — connect a staging DB so Claude
  can inspect the live schema while writing queries.
- **Activate:** `mv .mcp.json.example .mcp.json`
- **Setup:** the example needs only Node/`npx` (server is fetched on first run).
  A real conduit needs whatever its server needs — bundle a binary under the
  plugin and reference it with `${CLAUDE_PLUGIN_ROOT}`, or point at an installed
  command. Secrets go in `env` / `userConfig`, never hardcoded.
- **Caution:** an active MCP server **spawns a process every session** it's
  enabled. Leave it dormant until you need it.
- **To remove:** delete `.mcp.json.example` (and `.mcp.json` if you renamed it).
- **vs CLAUDE.md:** **Never** CLAUDE.md — text can't connect to anything. An MCP
  server is capability, not instruction. If Claude needs to read or write an
  external system, only an MCP server (or equivalent tool) can do it.

## ⑥ LSP — `.lsp.json.example`

**What it is:** a Language Server config — gives Claude diagnostics, go-to-def,
and find-references while editing. The example wires up
`typescript-language-server`.

- **Use it for:** Coding (only) — real-time type errors and go-to-definition
  while editing TS/Go/Python. Claude sees compiler diagnostics after each edit
  and makes far fewer broken changes. No productivity use — it's purely code
  intelligence.
- **Activate:** `mv .lsp.json.example .lsp.json`
- **Setup (required):** install the language-server binary yourself — it is
  **not** bundled. For the example:
  `npm install -g typescript-language-server typescript`. Without it you'll see
  `Executable not found in $PATH` in the `/plugin` Errors tab.
- **Make it yours:** swap `command` and `extensionToLanguage` for your language
  (e.g. `gopls`, `pyright`, `rust-analyzer`).
- **To remove:** delete `.lsp.json.example` (and `.lsp.json` if you renamed it).
- **vs CLAUDE.md:** **Never** CLAUDE.md — it can't produce compiler diagnostics
  or resolve symbols. Pure capability.

---

## ⑦ Output style — `output-styles/terse.md.example`

**What it is:** an output style. While the plugin is enabled it **auto-applies**
and reshapes how Claude writes (tone, length, format) across the whole session.

- **Use it for:** Productivity — a `brief` style enforcing "minimum necessary
  words" on every reply. Coding — a style that forces conventional-commit
  messages and a fixed PR-description structure across the session.
- **Activate:** `mv output-styles/terse.md.example output-styles/terse.md`
- **Caution:** because it applies automatically on enable, it's shipped dormant —
  an active style changes *every* response, not just invoked ones.
- **Make it yours:** edit the frontmatter (`name`, `description`) and the body,
  which is appended to Claude's system prompt. The filename is the style's id.
- **To remove:** delete the file (or the whole `output-styles/` folder).
- **vs CLAUDE.md:** Biggest overlap of all. Use an output style when you want it
  toggleable and reusable across projects (switch via `/output-style`). CLAUDE.md
  is enough for a fixed, project-specific "write like this" rule.

## ⑧ Theme — `themes/grimoire-dark.json`

**What it is:** a color theme. Shipped **live** — it shows up in `/theme` as an
option but does nothing until *you* select it (safe; passive).

- **Use it for:** Productivity — a red-tinted theme you switch to in
  client/production repos so you never mistake them for a sandbox. Coding — a
  distinct per-stack theme so you instantly know which project's terminal you're
  in.
- **Setup:** none. Auto-discovered from `themes/`. Run `/theme` and pick
  "Grimoire Dark".
- **Make it yours:** set `base` (`dark` / `light`) and a sparse `overrides` map
  of color tokens (`claude`, `success`, `error`, …). Themes are an experimental
  component — schema may shift between releases.
- **To remove:** delete the `.json` (or the whole `themes/` folder).
- **vs CLAUDE.md:** **Never** CLAUDE.md — a theme is pure UI, not an instruction
  at all.

## ⑨ Monitor — `monitors/monitors.json.example`

**What it is:** a background monitor. Runs a shell command for the whole session
and streams each stdout line to Claude as a notification — useful for watching
logs, deploys, or polled status.

- **Use it for:** Coding — `tail -F` the test-watch or dev-server log so Claude
  reacts to failures the moment they appear. Productivity — poll a CI/deploy
  status endpoint and get notified when it finishes.
- **Activate:** `mv monitors/monitors.json.example monitors/monitors.json`
- **Caution:** it **auto-starts a process on enable** and emits notifications, so
  it's shipped dormant. Requires Claude Code v2.1.105+; interactive CLI only;
  runs unsandboxed at hook trust level.
- **Make it yours:** set `name`, `command` (supports `${CLAUDE_PLUGIN_ROOT}` /
  `${CLAUDE_PROJECT_DIR}` / `${user_config.*}`), and `description`. Optional
  `when`: `"always"` (default) or `"on-skill-invoke:<skill>"`.
- **To remove:** delete the file (or the whole `monitors/` folder).
- **vs CLAUDE.md:** **Never** CLAUDE.md — text can't watch a process or poll an
  endpoint over a whole session. Capability, not instruction.

## ⑩ Executable — `bin/starter-spell-tool`

**What it is:** a bundled executable. While the plugin is enabled, `bin/` is
added to the Bash tool's `PATH`, so Claude can call `starter-spell-tool` as a
bare command. Shipped **live** — it only runs when invoked.

- **Use it for:** Coding — bundle a project CLI (codegen, `db-seed`) Claude can
  call as a bare command. Productivity — a `report-export` / `invoice-gen` script
  Claude runs as one step inside a larger workflow.
- **Setup:** make it executable — `chmod +x bin/starter-spell-tool`.
- **Make it yours:** replace with a real helper and give it a **distinctive
  name** so it can't shadow a system command (e.g. `git`, `ls`).
- **To remove:** delete the file (or the whole `bin/` folder).
- **vs CLAUDE.md:** Close call. If the script already lives in the repo, CLAUDE.md
  can just tell Claude to run it. Use `bin/` when you want to *bundle and
  distribute* the tool with the plugin and call it as a clean bare command.

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
