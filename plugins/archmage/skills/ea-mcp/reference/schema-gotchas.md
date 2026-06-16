# EA MCP — schema gotchas (the load-bearing traps)

These are non-obvious payload rules. Several cause **silent corruption** (the tool "succeeds" but
the model is wrong) rather than a clean error, so they are worth memorizing. The same list is
mirrored in the `ea-modeling` build workflow because it is that important.

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
`create_or_update_package`, `create_or_update_elements`, `create_or_update_connectors`,
`create_or_update_attributes`, `create_or_update_operations` all take **arrays** and **return new
IDs**. You cannot attach a child until its parent exists, so:
1. Create the **package** → get `packageID`.
2. Create **elements** under it → get element IDs.
3. Create **connectors** referencing those element IDs.
4. Create the **diagram**, then **place** the elements (by ID).

## 4. No transaction — partial models are real
Each `create_or_update_*` commits on its own. A timeout or error half-way leaves everything
created so far. For big builds, take a `create_baseline` first and verify with `get_diagram_image`
as you go.

## 5. Placement coordinates must exceed 10
`place_elements_on_diagram` rejects/clips `x` or `y` ≤ 10. Start layouts around `x:30, y:30` and space elements out.

## 6. Sequence messages: open the diagram FIRST
`create_or_update_messages` requires the target Sequence diagram to be **open**
(`enterprise-architect:open_diagrams`). On a hidden diagram it raises *"Selection information is
unavailable on hidden diagrams"* **but still creates the message connectors**. A naive retry then
makes **duplicates** (the dupes have the higher connector IDs). Always:
1. `open_diagrams` the Sequence diagram.
2. Create messages once.
3. `get_diagram_image` to verify **before** any retry.
4. If duplicates exist, remove them with `delete_connectors_or_messages`.

## 7. No delete for packages/elements
The only delete tool is `delete_connectors_or_messages`. There is **no** way to delete a package or
element via the MCP. Name experiments `ZZ_*` so they sort to the bottom of the browser, and delete
them by hand in EA afterward.

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
