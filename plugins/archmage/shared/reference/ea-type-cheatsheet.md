# EA type cheatsheet — the canonical type strings for the `enterprise-architect` MCP

> Single source of truth for the string values the EA MCP write tools expect. This is a plain
> reference (not a skill). The `ea-modeling`, `uml`, `archimate`, and `bpmn` spells point here so
> the type strings live in exactly one place.
>
> **Confirmed** = verified working against a live EA repository. **Verify in live EA** = taken
> from EA/MDG documentation but not yet hand-confirmed through the MCP; check before relying on it.

## Contents
- [Diagram `type` strings](#diagram-type-strings)
- [Element `type` strings](#element-type-strings)
- [Connector `type` strings](#connector-type-strings)
- [Stereotypes that change meaning](#stereotypes-that-change-meaning)
- [Schema shapes & hard rules](#schema-shapes--hard-rules)
- [The canonical build order](#the-canonical-build-order)

---

## Diagram `type` strings

Passed to `enterprise-architect:create_or_update_diagram` as `type`.

| Notation diagram | EA diagram `type` | Status |
| --- | --- | --- |
| UML Class | `Class` | Confirmed |
| UML Use Case | `Use Case` | Confirmed |
| UML Sequence | `Sequence` | Confirmed |
| UML Activity | `Activity` | Confirmed |
| UML State Machine | `StateMachine` | Confirmed |
| Requirements (SysML-style requirement) | `Requirements` | Confirmed |
| UML Object | `Object` | Verify in live EA |
| UML Package | `Package` | Verify in live EA |
| UML Component | `Component` | Verify in live EA |
| UML Deployment | `Deployment` | Verify in live EA |
| UML Composite Structure | `Composite Structure` | Verify in live EA |
| UML Communication | `Communication` | Verify in live EA |
| UML Timing | `Timing` | Verify in live EA |
| BPMN 2.0 process | (BPMN MDG diagram) | Verify in live EA — see the `bpmn` spell |
| ArchiMate 3 view | (ArchiMate MDG diagram) | Verify in live EA — see the `archimate` spell |

EA accepts these case-sensitively; copy them exactly (note the space in `Use Case`, no space in `StateMachine`).

## Element `type` strings

Passed to `enterprise-architect:create_or_update_elements` as `type`.

| Concept | EA element `type` | Notes |
| --- | --- | --- |
| Class | `Class` | Add attributes via `create_or_update_attributes`, operations via `create_or_update_operations`. |
| Interface | `Interface` | |
| Use case | `UseCase` | |
| Actor | `Actor` | |
| Sequence lifeline | `Sequence` | Stored internally as an Object; this is the lifeline on a Sequence diagram. |
| Activity action | `Action` | |
| Decision / merge | `Decision` | Diamond — used for both branch and merge. |
| State | `State` | State Machine states. |
| Initial / final node | `StateNode` | Naming it (e.g. "start"/"end") may auto-retype to `Pseudostate`. Used for both Activity initial/final and State initial/final. |
| Component | `Component` | Verify in live EA. |
| Node (deployment) | `Node` | Verify in live EA. |
| Object / instance | `Object` | Verify in live EA. |
| Requirement | `Requirement` | Verify in live EA. |
| Package | — | Use `enterprise-architect:create_or_update_package`, not `create_or_update_elements`. |

ArchiMate and BPMN elements are UML elements carrying an MDG **stereotype** (e.g. `«ArchiMate_BusinessProcess»`, `«BPMN2.0::Activity»`). Those exact stereotype strings are **verify in live EA** — see the `archimate` and `bpmn` spells.

## Connector `type` strings

Passed to `enterprise-architect:create_or_update_connectors` as `type`.

| Relationship | EA connector `type` | Notes |
| --- | --- | --- |
| Association | `Association` | Plain line; add multiplicity via source/target role ends. |
| Aggregation | `Aggregation` | Hollow diamond. |
| Composition | `Aggregation` | Set the aggregation kind to composite (strong) — verify the exact flag in live EA. |
| Generalization (inheritance) | `Generalization` | Hollow triangle, child → parent. |
| Dependency | `Dependency` | Dashed arrow. |
| «include» (use case) | `Dependency` | + `stereotypes: "include"`. |
| «extend» (use case) | `Dependency` | + `stereotypes: "extend"`. |
| Realization / implements | `Realization` | Verify in live EA. |
| Activity control flow | `ControlFlow` | Edges between `Action`/`Decision`/`StateNode` on Activity diagrams. |
| State transition | `StateFlow` | Edges between `State`/`StateNode` on State Machine diagrams. |
| Sequence message | — | Use `enterprise-architect:create_or_update_messages` (diagram must be OPEN first). |

## Stereotypes that change meaning

- `stereotypes: "include"` / `"extend"` on a `Dependency` → renders «include»/«extend» on a Use Case diagram.
- ArchiMate/BPMN MDG stereotypes drive the element shape/notation — verify exact strings in live EA.

## Schema shapes & hard rules

These are the traps that cause **silent corruption or tool errors**. They are restated in the
`ea-mcp` and `ea-modeling` spells because they are load-bearing.

1. **`taggedValues` is an ARRAY of `{name, value}` objects** — never a `{key: value}` map. A map makes the tool error.
2. **Connector `direction: "Source -> Destination"` FAILS.** Use `"Unspecified"` (or omit). `"Bi-Directional"` is untested.
3. **`create_or_update_*` take ARRAYS and RETURN the new IDs.** Create the parent **package first**, capture its `packageID`, then create children under it.
4. **Each `create_or_update_*` call commits independently.** A timeout mid-build leaves a **partial** model — no transaction/rollback.
5. **`place_elements_on_diagram` needs x and y > 10.** Smaller coordinates are rejected/clipped.
6. **Sequence messages require the diagram OPEN.** Call `enterprise-architect:open_diagrams` first. If you call `create_or_update_messages` on a hidden diagram it errors ("Selection information is unavailable on hidden diagrams") **but still creates the connectors** — a naive retry DUPLICATES. Verify with `get_diagram_image` before retrying; delete dupes with `delete_connectors_or_messages`.
7. **There is NO delete tool for packages or elements** (only `delete_connectors_or_messages`). Name throwaways `ZZ_*` and delete them manually in EA.

## The canonical build order

```
create_or_update_package        # parent first → capture packageID
  → create_or_update_elements   # arrays → capture element IDs
  → create_or_update_attributes / create_or_update_operations   # class members
  → create_or_update_connectors # relationships (direction "Unspecified")
  → create_or_update_diagram    # the view (correct `type` string)
  → open_diagrams               # REQUIRED before create_or_update_messages
  → place_elements_on_diagram   # x,y,width,height ; x/y > 10
  → layout_connectors           # auto-route
  → get_diagram_image           # VERIFY (render PNG and check)
```

Full mechanics, per-diagram playbooks, and reading recipes live in the `ea-modeling` spell.
Setup/connection/troubleshooting lives in the `ea-mcp` spell.
