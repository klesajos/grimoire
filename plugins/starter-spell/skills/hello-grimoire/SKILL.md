---
name: hello-grimoire
description: Smoke-test spell that confirms a freshly installed grimoire plugin is wired up correctly. Trigger when the user says "test the grimoire", "hello grimoire", or wants to verify that a just-installed plugin actually works.
---

# Hello, Grimoire 🪄

This is a **spell** — a skill packaged inside a plugin. Its only job is to prove,
end to end, that your marketplace → plugin → skill chain works.

When this spell is invoked:

1. Tell the user the `starter-spell` plugin loaded successfully and report which
   marketplace it came from (`grimoire` or `grimoire-arcana`).
2. Confirm the skill, the plugin manifest, and the marketplace entry are all
   resolving — if you can read this file, all three are correct.
3. Point them at `plugins/starter-spell/README.md` for how to copy this folder
   into a real plugin of their own.

Keep the reply short and celebratory. This spell does no real work — it is the
"it's alive" signal for a new plugin.
