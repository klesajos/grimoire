# EA MCP — schema gotchas (the load-bearing traps)

These are non-obvious payload rules. Several cause **silent corruption** (the tool "succeeds" but
the model is wrong) rather than a clean error, so they are worth memorizing. The same list is
mirrored in the `ea-modeling` build workflow because it is that important.

Tools are named in prose as `enterprise-architect:<tool>`; that colon form is documentation
shorthand for the invokable `mcp__enterprise-architect__<tool>`. See the tool-name convention in
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

## 1. `taggedValues` is an array, not a map
```json
// RIGHT
"taggedValues": [ { "name": "owner", "value": "Sales" }, { "name": "status", "value": "draft" } ]
// WRONG — tool error
"taggedValues": { "owner": "Sales", "status": "draft" }
```

## 2. Connector `direction` — avoid "Source -> Destination"
`"Source -> Destination"` **fails**. Use `"Unspecified"` (or omit `direction`). `"Bi-Directional"`
is untested. The visual arrowhead comes from the connector **type** (e.g. Generalization,
Dependency), not from `direction`.

## 3. Arrays in, IDs out — sequence your creates
`enterprise-architect:create_or_update_package`, `enterprise-architect:create_or_update_elements`,
`enterprise-architect:create_or_update_connectors`, `enterprise-architect:create_or_update_attributes`,
`enterprise-architect:create_or_update_operations` all take **arrays** and **return new IDs**. You
cannot attach a child until its parent exists, so:
1. Create the **package** → get `packageID`.
2. Create **elements** under it → get element IDs.
3. Create **connectors** referencing those element IDs.
4. Create the **diagram**, then **place** the elements (by ID).

## 4. No transaction — partial models are real
Each `create_or_update_*` commits on its own. A timeout or error half-way leaves everything
created so far. For big builds, take an `enterprise-architect:create_baseline` first and verify with
`enterprise-architect:get_diagram_image` as you go.

**Recovering from a half-built model is not just "re-run idempotently".** `create_or_update_*` only
*updates* (instead of duplicating) when you feed back the **returned IDs** of the rows it already
created. On a mid-build timeout the IDs of the last-created elements may never have been captured —
a blind re-run from scratch then **duplicates** them, and duplicates **cannot be deleted via the
MCP** (see #7). So before re-running:
1. Recover the IDs that already exist with `enterprise-architect:get_packages_information` /
   `enterprise-architect:find_elements_by_name` / `enterprise-architect:find_packages_by_name`, and
   feed them back so those steps update.
2. Or restore the `enterprise-architect:create_baseline` snapshot with
   `enterprise-architect:apply_baseline` to roll back to a clean state, then re-run from scratch.
3. Only re-run a step blindly if you still hold its returned IDs (or it created nothing yet).

## 5. Placement coordinates must exceed 10
`enterprise-architect:place_elements_on_diagram` rejects/clips `x` or `y` ≤ 10. Start layouts around
`x:30, y:30` and space elements out.

## 6. Sequence messages: open the diagram FIRST
`enterprise-architect:create_or_update_messages` requires the target Sequence diagram to be **open**
(`enterprise-architect:open_diagrams`). On a hidden diagram it raises *"Selection information is
unavailable on hidden diagrams"* **but still creates the message connectors**. A naive retry then
makes **duplicates** (the dupes have the higher connector IDs). Always:
1. `enterprise-architect:open_diagrams` the Sequence diagram.
2. Create messages once.
3. `enterprise-architect:get_diagram_image` to verify **before** any retry.
4. If duplicates exist, remove them with `enterprise-architect:delete_connectors_or_messages`.

## 7. No delete for packages/elements
The only delete tool is `enterprise-architect:delete_connectors_or_messages`. There is **no** way to
delete a package or element via the MCP. Name experiments `ZZ_*` so they sort to the bottom of the
browser, and delete them by hand in EA afterward. The closest thing to **undo** is an
`enterprise-architect:create_baseline` taken *before* the edit + `enterprise-architect:apply_baseline`
to restore it — that is the only MCP-side way to walk back accidental creations (e.g. duplicates from
a half-built re-run, see #4), complementing the `ZZ_*` convention.

## 8. Type strings are exact and case-sensitive
`Use Case` (with a space), `StateMachine` (no space), `ControlFlow`, `StateFlow`. Copy from
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

## 9. Activity/State initial & final nodes auto-retype
Create initial/final nodes as `type: "StateNode"`. Giving one a name (e.g. "start") may cause EA to
auto-retype it to `Pseudostate`. That is usually fine — just don't be surprised when a later read
shows a different type than you wrote.

## 10. IDs vs GUIDs
Tools return numeric IDs for the session; GUIDs are stable across sessions. When you persist
references (e.g. in notes for a later run), prefer GUIDs where the tool exposes them.
