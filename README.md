# grimoire 🪄

> *A grimoire of leverage — spells that move the work.*

A personal [Claude Code](https://code.claude.com/docs) **plugin marketplace**: a
curated book of skills, commands, agents, hooks, and MCP servers — both original
and forked. Platform-agnostic in spirit, Claude-native in practice.

This is the **public** grimoire. Its private counterpart,
[`grimoire-arcana`](https://github.com/klesajos/grimoire-arcana) — *the restricted
section* — holds personal and internal spells. (It's private: that link returns a
404 unless you have access.)

## The lexicon

| In this grimoire | In Claude Code | What it is |
| ---------------- | -------------- | ---------- |
| spell            | skill          | model-invoked capability (`SKILL.md`) |
| incantation      | command        | a `/slash` command |
| familiar         | agent          | a subagent you can dispatch |
| ward / ritual    | hook           | automation that fires on events |
| conduit          | MCP server     | connection to an external tool/service |

## Add this marketplace

```bash
# inside Claude Code
/plugin marketplace add klesajos/grimoire
/plugin install <plugin>@grimoire
```

Or from the terminal:

```bash
claude plugin marketplace add klesajos/grimoire
claude plugin install <plugin>@grimoire
```

Refresh after new plugins are added: `/plugin marketplace update grimoire`.

## The book of spells

| Plugin | What it does | Status |
| ------ | ------------ | ------ |
| [`starter-spell`](plugins/starter-spell) | Reference template — copy it to conjure a new plugin | template |
| [`archmage`](plugins/archmage) | Model in Sparx Enterprise Architect via MCP, plus UML / BPMN / ArchiMate / TOGAF / Mermaid reference spells | active |
| [`hermes-tweet`](https://github.com/Xquik-dev/hermes-tweet) | Native Hermes Agent X/Twitter plugin for read-first social monitoring and approval-gated actions | external |

## Add your own

The marketplace index lives in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).
Copy [`plugins/starter-spell`](plugins/starter-spell), edit its manifest, and add an
entry to the index. Full walkthrough in the
[starter-spell README](plugins/starter-spell/README.md).

Forked plugins don't need to be vendored — list them with a GitHub `source` so
they're pulled from upstream and stay in sync:

```json
{
  "name": "superpowers",
  "source": { "source": "github", "repo": "obra/superpowers", "ref": "main" },
  "description": "Forked — pulled from upstream"
}
```

## Validate

```bash
claude plugin validate .          # validate the marketplace catalog
claude plugin validate ./plugins/<name>   # validate a single plugin
```

## License

[MIT](LICENSE) © Josef Klesa. Forked plugins retain their original licenses.
