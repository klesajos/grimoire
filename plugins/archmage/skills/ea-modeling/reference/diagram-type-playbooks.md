# Per-diagram playbooks

The build workflow is the same shape for every diagram, but each kind has quirks. These are the
ones that cause rework. General workflow: `build-workflow.md`. Type strings:
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

## Contents
- [Class diagram](#class-diagram)
- [Use case diagram](#use-case-diagram)
- [Sequence diagram (the duplicate trap)](#sequence-diagram-the-duplicate-trap)
- [Activity diagram](#activity-diagram)
- [State machine diagram](#state-machine-diagram)
- [Requirements diagram](#requirements-diagram)

![The sequence-message duplicate trap — always open the diagram first](images/ea-sequence-trap.png)

<details>
<summary>Mermaid source</summary>

<!-- render: images/ea-sequence-trap.png -->

```mermaid
flowchart TD
    A["Create sequence diagram"]
    Q{"open_diagrams first?"}
    B["Create messages once"]
    C["Verify with get_diagram_image"]
    D["Done"]
    E["Hidden diagram: errors BUT still creates connectors"]
    F["Naive retry"]
    G["Duplicates (warn)"]
    A --> Q
    Q -->|yes| B
    B --> C
    C --> D
    Q -->|no| E
    E --> F
    F --> G
```

</details>

## Class diagram

- Diagram `type: "Class"`. Elements `Class`/`Interface`.
- Add **attributes** (`create_or_update_attributes`) and **operations** (`create_or_update_operations`) by owning element ID, after the class exists.
- Connectors: `Association` (set multiplicity via `sourceEnd.multiplicity` / `targetEnd.multiplicity`;
  the MCP leaves the line plain with no navigability arrow — set `Direction` on the connector via the
  EA COM bridge to draw it),
  `Aggregation` (for composition, set the aggregate end's `Aggregation=2` via the EA COM bridge to get the
  filled diamond — the MCP exposes no aggregation-kind field; the EA GUI also works), `Generalization` (child→parent),
  `Realization` (class→interface), `Dependency`.
  COM-bridge recipes: `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`.
- Place classes in a grid (x/y > 10), `layout_connectors`, render.

## Use case diagram

- Diagram `type: "Use Case"` (note the space). Elements `Actor`, `UseCase`.
- Actor↔use case is `Association`. Use-case relationships:
  - «include» → `Dependency` + `stereotypes:"include"`.
  - «extend» → `Dependency` + `stereotypes:"extend"`.
  - actor generalisation → `Generalization`.
- Typical layout: actors down the left, use cases in a system boundary to the right.

## Sequence diagram (the duplicate trap)

This is the highest-risk build. Read this before doing it.

1. Lifelines are **elements of `type: "Sequence"`** (stored as Objects). Create them first.
2. Create the diagram `type: "Sequence"`, then **`enterprise-architect:open_diagrams`** it.
3. **Only now** create messages with `create_or_update_messages`.
4. If you skip the open, the tool errors *"Selection information is unavailable on hidden
   diagrams"* **but still creates the message connectors**. So a naive retry **duplicates** them
   (dupes get the higher connector IDs).
5. **Verify with `get_diagram_image` BEFORE retrying anything.**
6. If duplicates exist, find them via `get_connectors_information` over a *narrow* ID range and
   remove with `delete_connectors_or_messages` (the only delete tool).

Order messages top-to-bottom by their sequence position. Synchronous calls vs returns vs async are
set on the message; render to confirm arrowheads.

**Watch the field names — messages are the one exception.** `create_or_update_messages` uses flat
`sourceElementID` / `targetElementID`, **NOT** the `sourceEnd.relatedElementID` /
`targetEnd.relatedElementID` you use for connectors. Carrying the connector rule over here is the
classic mistake. The payload:

```
create_or_update_messages {
  "diagramID": 20,
  "messageInfo": [
    { "connectorID": 0, "name": "submit()", "sourceElementID": 101, "targetElementID": 102, "order": 1 },
    { "connectorID": 0, "name": "ack",       "sourceElementID": 102, "targetElementID": 101, "order": 2,
      "isReturnMessage": true },
    { "connectorID": 0, "name": "notify()",  "sourceElementID": 102, "targetElementID": 103, "order": 3,
      "isAsynchronousMessage": true }
  ]
}
```

`connectorID: 0` creates; `order` sequences the arrows; `isReturnMessage: true` draws a dashed
return arrow and `isAsynchronousMessage: true` an open-arrowhead async call (a plain synchronous
call needs neither).

## Activity diagram

- Diagram `type: "Activity"`. Nodes: `Action`, `Decision` (diamond, for branch **and** merge),
  initial/final as `StateNode`. The MCP creates `StateNode` with `Subtype=0`, so initial/final render
  **invisibly** (control flows point at empty space) — set `Subtype=100` (initial) / `101` (final) via
  the EA COM bridge (`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`) to make them visible.
- Edges are `ControlFlow`. Put the **guard** on the control flow leaving a `Decision`.
- For object/data flow, use object nodes (verify type) with `ObjectFlow` (verify).
- Forks/joins: element `type: "Synchronization"` (the synchronization bar) — or model parallelism with
  multiple outgoing/incoming control flows on a fork node.

## State machine diagram

- Diagram `type: "StateMachine"` (no space). Nodes: `State`, initial/final `StateNode`. As on activity
  diagrams, the MCP creates `StateNode` with `Subtype=0` so initial/final render **invisibly** — set
  `Subtype=100` (initial) / `101` (final) via the EA COM bridge
  (`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`) to make them visible.
- Transitions are `StateFlow`. Put `trigger [guard] / effect` on the transition.
- Composite/nested states: create child states inside the composite (verify nesting via the parent
  element ID).

## Requirements diagram

- Diagram `type: "Requirements"` (confirmed). Elements `Requirement` (confirmed). This UML
  `Requirement` is **not** the confirmed ArchiMate `ArchiMate3::ArchiMate_Requirement` — a
  different MDG type; see the `archimate` spell.
- Link requirements to design elements with `Realization` (element realises requirement) or
  `Dependency`/«trace». Hierarchy via `Aggregation`/nesting.
