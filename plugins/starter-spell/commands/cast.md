---
description: Demo incantation — confirms the starter-spell plugin's slash commands are working.
argument-hint: "[optional message to echo back]"
---

You were invoked via the `/starter-spell:cast` slash command — this is an
**incantation** (a command shipped by a plugin).

Do this:

1. Confirm to the user that plugin-provided commands are resolving correctly.
2. If the user passed arguments after the command, echo them back so they can
   see argument passing works: `$ARGUMENTS`.
3. Remind them that commands live in `commands/*.md` and are namespaced as
   `/<plugin-name>:<command-file-name>`.

Keep it to two or three sentences.
