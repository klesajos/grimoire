# starter-spell 🪄

The **copy-me template**. This plugin does nothing useful on purpose — it is the
smallest correct, complete plugin, so you can clone it and fill in real magic.

## What's inside

```
starter-spell/
├─ .claude-plugin/
│  └─ plugin.json                     # the plugin manifest (name, version, author)
├─ skills/
│  └─ hello-grimoire/
│     └─ SKILL.md                     # a "spell" — model-invoked skill
└─ commands/
   └─ cast.md                         # an "incantation" — a /slash command
```

A plugin can also carry `agents/` ("familiars"), `hooks/`, `.mcp.json`, and LSP
servers — see https://code.claude.com/docs/en/plugins for the full list.

## Conjure a new plugin from this template

1. **Copy** the folder:
   ```bash
   cp -r plugins/starter-spell plugins/<your-plugin>
   ```
2. **Rename** it: edit `<your-plugin>/.claude-plugin/plugin.json` → set `name`,
   `description`, bump `version`.
3. **Write the magic**: replace `skills/hello-grimoire/SKILL.md` with your real
   skill (keep the `description` sharp — that's what the model matches on to
   decide when to use it). Add/rename commands under `commands/`.
4. **List it** in the marketplace: add an entry to `.claude-plugin/marketplace.json`
   pointing `source` at `./plugins/<your-plugin>`.
5. **Validate**:
   ```bash
   claude plugin validate .                       # checks marketplace.json
   claude plugin validate ./plugins/<your-plugin> # checks the plugin + frontmatter
   ```
6. **Test locally** before pushing:
   ```bash
   claude plugin marketplace add ./        # add this repo as a local marketplace
   claude plugin install <your-plugin>@grimoire
   ```

## Vendor vs. fork

- **Original plugins** live here as folders (relative `source`).
- **Forked plugins** you don't want to copy: list them in `marketplace.json`
  with a GitHub source instead of vendoring the code —
  `"source": { "source": "github", "repo": "owner/repo", "ref": "main" }`.
