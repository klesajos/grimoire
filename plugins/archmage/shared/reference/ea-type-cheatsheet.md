# EA type cheatsheet — the canonical type strings for the `enterprise-architect` MCP

> Single source of truth for the string values the EA MCP write tools expect. This is a plain
> reference (not a skill). The `ea-modeling`, `uml`, `archimate`, and `bpmn` spells point here so
> the type strings live in exactly one place.
>
> **Confirmed** = verified working against a live EA repository. **Verify in live EA** = taken
> from EA/MDG documentation but not yet hand-confirmed through the MCP; check before relying on it.
> **Falls back to Class** = the string was not resolved as its own diagram type in testing and EA
> silently created a `Class` diagram instead; use `Class` directly.

## Contents
- [Tool-name convention](#tool-name-convention)
- [Diagram `type` strings](#diagram-type-strings)
- [Element `type` strings](#element-type-strings)
- [Connector `type` strings](#connector-type-strings)
- [Stereotypes that change meaning](#stereotypes-that-change-meaning)
- [Schema shapes & hard rules](#schema-shapes--hard-rules)
- [Exact payload field names](#exact-payload-field-names-confirmed-from-the-live-tool-schemas)
- [The canonical build order](#the-canonical-build-order)

---

## Tool-name convention

The single rule for how EA MCP tools are written across this plugin:

- **In prose**, qualify the server: write tools as **`enterprise-architect:<tool>`** (e.g.
  `enterprise-architect:create_or_update_elements`) so the right server is unambiguous.
- **Inside flow diagrams, pseudo-code/recipe blocks, and tool-catalog tables**, bare names
  (`create_or_update_elements`) are fine — but the document must declare the qualification **once**
  near its top (as the read/write catalogs and the recipe files do). The bare form is shorthand
  *within* that block, not a second convention.
- **`enterprise-architect:<tool>` is documentation shorthand.** The actually-registered,
  invokable names are **`mcp__enterprise-architect__<tool>`** (e.g.
  `mcp__enterprise-architect__create_or_update_elements`). Tool calls resolve against that
  `mcp__<server>__<tool>` form; the `enterprise-architect:` colon form is only for readability in
  these docs.

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
| UML Object | `Object` | Confirmed |
| UML Component | `Component` | Confirmed |
| UML Deployment | `Deployment` | Confirmed |
| UML Composite Structure | `Composite Structure` | Confirmed |
| UML Profile | `Profile` | Confirmed |
| UML Package | `Package` | Confirmed |
| UML Communication | `Communication` | Confirmed |
| UML Timing | `Timing` | Confirmed |
| ArchiMate 3 view | `Class` (use this) | **Falls back to Class** — the view FQN appears to be `Archimate3::<ViewName>` (the live `create_or_update_diagram` schema gives `Archimate3::Application` as its example, lowercase `m`), but only the bare layer name `ArchiMate3::Layered` was tried in testing and it silently created a `Class` diagram. The resolving view string is unconfirmed, so use `Class` directly — ArchiMate elements still render with full ArchiMate notation on it. To probe the FQN, retry `Archimate3::Application`/`Business`/`Technology` on a `ZZ_` throwaway and read it back. |
| BPMN 2.0 process | (BPMN MDG diagram) | Verify in live EA — see the `bpmn` spell |

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
| Component | `Component` | Confirmed. |
| Node (deployment) | `Node` | Confirmed. |
| Device (deployment) | `Device` | Confirmed. Renders «device». |
| Artifact | `Artifact` | Confirmed. |
| Object / instance | `Object` | Confirmed. Name as `instance : Classifier` to show the classifier. |
| Part (composite structure) | `Part` | Confirmed. Set `owningElementID` to the structured class so the part nests inside it on the diagram. |
| Stereotype (profile) | `Class` + `stereotypes:"stereotype"` | Confirmed. A profile stereotype is a `Class` stereotyped «stereotype»; the extended metaclass is a `Class` stereotyped «metaclass». There is **no** `Stereotype` element type (it errors). |
| Requirement | `Requirement` | Confirmed (the **UML** Requirement element, goes on a `Requirements` diagram). Do **not** confuse it with the ArchiMate `ArchiMate3::ArchiMate_Requirement` (a different MDG type). |
| Package | — | Use `enterprise-architect:create_or_update_package`, not `create_or_update_elements`. |

**ArchiMate 3 (confirmed):** pass the fully-qualified MDG type directly as `type`, form
`ArchiMate3::ArchiMate_<Element>` — note the casing **`ArchiMate3`** (capital M), not `Archimate3`.
Confirmed element types: `ArchiMate3::ArchiMate_BusinessRole`, `…_BusinessProcess`,
`…_BusinessService`, `…_ApplicationComponent`, `…_ApplicationService`, `…_Node` (and the rest of
the `ArchiMate_*` element names follow the same pattern). See the `archimate` spell.

**BPMN 2.0 (not resolved via the MCP):** the `BPMN2.0` MDG technology is loaded, but the create
tool **rejects** the fully-qualified `type:"BPMN2.0::Activity"` ("Invalid type"), and passing it in
the `stereotypes` field strips the profile prefix (you get a plain `«Activity»`, not BPMN
notation). Author BPMN diagrams in the **EA GUI toolbox** for now; the MCP MDG strings for BPMN are
still unresolved. See the `bpmn` spell.

## Connector `type` strings

Passed to `enterprise-architect:create_or_update_connectors` as `type`.

| Relationship | EA connector `type` | Notes |
| --- | --- | --- |
| Association | `Association` | Plain line; add multiplicity via source/target role ends. |
| Aggregation | `Aggregation` | Hollow diamond. |
| Composition | `Aggregation` | Use `Aggregation` for the line; the filled (composite) diamond is **GUI-only** — the MCP create tool exposes no aggregation-kind field (a passed `aggregation` value on the end is ignored), so set composite in the EA GUI (or accept a shared/hollow diamond). |
| Generalization (inheritance) | `Generalization` | Hollow triangle, child → parent. |
| Dependency | `Dependency` | Dashed arrow. |
| «include» (use case) | `Dependency` | + `stereotypes:"include"`. Confirmed. |
| «extend» (use case) | `Dependency` | + `stereotypes:"extend"`. Confirmed. |
| «deploy» (deployment) | `Dependency` | + `stereotypes:"deploy"` (artifact → node). Confirmed. |
| Realization / implements | `Realization` | Confirmed (component→interface, class→interface). |
| Extension (profile) | `Extension` | Confirmed. Stereotype-class → metaclass-class. |
| Part connector (composite structure) | `Connector` | Confirmed. Assembly/delegation line between parts. |
| Activity control flow | `ControlFlow` | Edges between `Action`/`Decision`/`StateNode` on Activity diagrams. |
| State transition | `StateFlow` | Edges between `State`/`StateNode` on State Machine diagrams. |
| Sequence message | — | Use `enterprise-architect:create_or_update_messages` (diagram must be OPEN first). |

**ArchiMate 3 relationships (confirmed):** pass the FQN as `type`, form
`ArchiMate3::ArchiMate_<Relationship>` — e.g. `ArchiMate3::ArchiMate_Assignment`,
`…_Realization`, `…_Serving` (and `…_Composition`, `…_Aggregation`, `…_Triggering`, `…_Flow`,
`…_Access`, `…_Specialization`, `…_Influence`, `…_Association` follow the same pattern).

## Stereotypes that change meaning

- `stereotypes:"include"` / `"extend"` on a `Dependency` → «include»/«extend» on a Use Case diagram.
- `stereotypes:"deploy"` on a `Dependency` → «deploy» on a Deployment diagram.
- `stereotypes:"metaclass"` / `"stereotype"` on a `Class` → profile metaclass / stereotype boxes.
- ArchiMate MDG types (`ArchiMate3::…`) drive the element shape/colour/icon. BPMN MDG types are **not** applyable via the MCP create tool (see the element table).

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

## Exact payload field names (confirmed from the live tool schemas)

The fields are NOT what you might guess — these are the real ones:

- **`create_or_update_package`** → `{ packageInfo: { packageID: 0, name, owningPackageID } }`
  (parent is **`owningPackageID`**, not `parentPackageID`; `packageID: 0` means create).
- **`create_or_update_elements`** → `{ elementInfo: [ { elementID: 0, type, name, owningPackageID, owningElementID, stereotypes, taggedValues } ] }`
  (container is **`owningPackageID`**; to nest an element inside another element set **`owningElementID`**).
- **`create_or_update_attributes`** → `{ elementID, attributeInfo: [ { attributeID: 0, name, type, scope } ] }`
  (owning class is the **top-level `elementID`**; members go in **`attributeInfo`**; `attributeID: 0` means create; the visibility field is **`scope`** with values `Private`/`Protected`/`Package`/`Public` — NOT `visibility`).
- **`create_or_update_operations`** → `{ elementID, operationInfo: [ { operationID: 0, name, returnType } ] }`
  (owning class is the **top-level `elementID`**; members go in **`operationInfo`**; `operationID: 0` means create; same `scope` field as attributes for visibility).
- **`create_or_update_connectors`** → `{ connectorInfo: [ { connectorID: 0, type, direction:"Unspecified", sourceEnd: { relatedElementID }, targetEnd: { relatedElementID }, stereotypes } ] }`
  (the ends are **`sourceEnd.relatedElementID`** / **`targetEnd.relatedElementID`** — NOT `sourceElementID`/`targetElementID`. Multiplicity goes in `sourceEnd.multiplicity` / `targetEnd.multiplicity`.)
- **`create_or_update_messages`** → `{ diagramID, messageInfo: [ { connectorID: 0, name, sourceElementID, targetElementID, order, isReturnMessage, isAsynchronousMessage } ] }`
  (**the one tool whose ends DIFFER from connectors**: a sequence message uses flat **`sourceElementID`** / **`targetElementID`** — NOT `sourceEnd.relatedElementID`. `connectorID: 0` means create; `order` sequences the arrows top-to-bottom; set `isReturnMessage: true` for a dashed return arrow and `isAsynchronousMessage: true` for an open-arrowhead async call. The diagram must be **OPEN** first — see rule 6.)
- **`create_or_update_diagram`** → `{ diagramInfo: { diagramID: 0, name, type, owningPackageID, owningElementID } }`
  (set `owningElementID: 0` when the diagram is owned by a package).
- **`place_elements_on_diagram`** → `{ diagramID, placements: [ { elementID, x, y, width, height } ] }` (x/y > 10).
- **`layout_connectors`** / **`open_diagrams`** → `{ diagramID }` / `{ diagramIDs: [ ] }`.
- **`get_packages_information`** → `{ packageIDs: [ ] }` (array, even for one).

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
