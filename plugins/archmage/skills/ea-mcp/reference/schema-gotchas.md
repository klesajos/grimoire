# EA MCP — recovery & deep procedures (appendix to the cheatsheet)

The **canonical list** of payload hard rules — `taggedValues` is an array; connector
`direction:"Unspecified"` (`"Source -> Destination"` fails); `create_*` take arrays and return IDs
(parent first); `place_elements_on_diagram` needs x/y > 10; the **sequence-message duplicate trap**
(`open_diagrams` first); **no element/package delete** → name throwaways `ZZ_*`; type strings are
exact and case-sensitive — lives **once** in
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md` › "Schema shapes & hard rules". Read it
before your first write.

This file carries only the **deeper procedures** that the summary can't: recovering from a partial
build, walking back accidental creations, and two non-obvious behaviours. (Tools are named in prose
as `enterprise-architect:<tool>`, documentation shorthand for `mcp__enterprise-architect__<tool>`.)

## Recovering from a half-built model

`create_or_update_*` only *updates* (instead of duplicating) when you feed back the **returned IDs**
of the rows it already created. On a mid-build timeout the IDs of the last-created elements may never
have been captured — a blind re-run from scratch then **duplicates** them, and duplicates **cannot be
deleted via the MCP**. So before re-running:

1. Recover the IDs that already exist with `enterprise-architect:get_packages_information` /
   `enterprise-architect:find_elements_by_name` / `enterprise-architect:find_packages_by_name`, and
   feed them back so those steps update rather than duplicate.
2. Or restore the `enterprise-architect:create_baseline` snapshot with
   `enterprise-architect:apply_baseline` to roll back to a clean state, then re-run from scratch.
3. Only re-run a step blindly if you still hold its returned IDs (or it created nothing yet).

This is why the canonical rules say `create_baseline` **before** a big build and verify with
`get_diagram_image` as you go.

## Walking back accidental creations (there is no element delete)

The only delete tool is `enterprise-architect:delete_connectors_or_messages` — there is **no** way to
delete a package or element through the MCP. The closest thing to **undo** is an
`enterprise-architect:create_baseline` taken *before* the edit + `enterprise-architect:apply_baseline`
to restore it. That is the only MCP-side way to remove accidental creations (e.g. duplicates from a
half-built re-run, above), complementing the `ZZ_*`-name-and-delete-in-EA-by-hand convention.

## Activity/State initial & final nodes auto-retype

Create initial/final nodes as `type: "StateNode"`. Giving one a name (e.g. "start") may cause EA to
auto-retype it to `Pseudostate`. That is usually fine — just don't be surprised when a later read
shows a different type than you wrote. (To make them *visible*, set `Subtype=100/101` via the COM
bridge — see `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`.)

## IDs vs GUIDs

Tools return numeric IDs for the session; GUIDs are stable across sessions. When you persist
references (e.g. in notes for a later run), prefer GUIDs where the tool exposes them.
