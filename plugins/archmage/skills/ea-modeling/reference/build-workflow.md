# EA build workflow — step by step

The repeatable recipe for turning a design into EA elements. Worked end-to-end on a tiny class
model; the same shape applies to every diagram kind (per-kind quirks are in
`diagram-type-playbooks.md`).

## Contents
- [Step 0 — confirm the target package](#step-0--confirm-the-target-package)
- [Step 1 — package](#step-1--package)
- [Step 2 — elements](#step-2--elements)
- [Step 3 — members (attributes/operations)](#step-3--members-attributesoperations)
- [Step 4 — connectors](#step-4--connectors)
- [Step 5 — diagram](#step-5--diagram)
- [Step 6 — open, place, layout](#step-6--open-place-layout)
- [Step 7 — verify](#step-7--verify)
- [The gotcha list (memorize)](#the-gotcha-list-memorize)

## Step 0 — confirm the target package

```
enterprise-architect:get_root_packages
enterprise-architect:get_packages_information   # confirm name + ID of the intended parent
```
Two projects can both have a "Model" root at packageID 1. **Verify before writing.**

## Step 1 — package

Create the container first; capture the returned `packageID`.

```
enterprise-architect:create_or_update_package
  [{ "name": "Ordering", "parentPackageID": <modelRootId> }]
→ returns packageID, e.g. 7
```

## Step 2 — elements

Elements take an **array** and return IDs in order. Use the exact `type` strings from the
cheatsheet.

```
enterprise-architect:create_or_update_elements
  [
    { "type": "Class", "name": "Order",    "packageID": 7 },
    { "type": "Class", "name": "Customer", "packageID": 7 }
  ]
→ returns [ {id: 101}, {id: 102} ]
```

Optional per element: `stereotypes`, `notes`, and `taggedValues` as an **array**:
```json
"taggedValues": [ { "name": "owner", "value": "Sales" } ]
```

## Step 3 — members (attributes/operations)

Attach class members by owning element ID.

```
enterprise-architect:create_or_update_attributes
  [ { "elementID": 101, "name": "total", "type": "Money", "visibility": "Private" } ]

enterprise-architect:create_or_update_operations
  [ { "elementID": 101, "name": "submit", "returnType": "void" } ]
```

## Step 4 — connectors

Reference the element IDs from step 2. **`direction: "Unspecified"`.**

```
enterprise-architect:create_or_update_connectors
  [ { "type": "Association",
      "sourceElementID": 102, "targetElementID": 101,
      "direction": "Unspecified",
      "sourceCardinality": "1", "targetCardinality": "0..*" } ]
```

For use-case «include»/«extend»: `type:"Dependency"`, `stereotypes:"include"` (or `"extend"`).
For activity edges: `type:"ControlFlow"`. For state transitions: `type:"StateFlow"`.

## Step 5 — diagram

```
enterprise-architect:create_or_update_diagram
  [ { "name": "Domain", "type": "Class", "packageID": 7 } ]
→ returns diagramID, e.g. 20
```

## Step 6 — open, place, layout

Open the diagram (mandatory before creating sequence messages; harmless otherwise and lets layout
behave). Place each element with geometry — **x and y must be > 10** — then auto-route.

```
enterprise-architect:open_diagrams [20]

enterprise-architect:place_elements_on_diagram
  [ { "diagramID": 20, "elementID": 101, "x": 60,  "y": 40, "width": 160, "height": 90 },
    { "diagramID": 20, "elementID": 102, "x": 320, "y": 40, "width": 160, "height": 90 } ]

enterprise-architect:layout_connectors [20]
```

## Step 7 — verify

```
enterprise-architect:get_diagram_image [20]   # render PNG, then LOOK at it
```
If something is wrong, fix and re-render. Because creates are idempotent on ID, re-running a
corrected create updates rather than duplicates — **except** sequence messages (see playbooks).

## The gotcha list (memorize)

1. `taggedValues` = **array of `{name,value}`**, never a map.
2. Connector `direction: "Source -> Destination"` **fails** → `"Unspecified"`.
3. `create_*` take **arrays**, **return IDs** → create the parent package first.
4. `place_elements_on_diagram` needs **x/y > 10**.
5. **Sequence messages require `open_diagrams` first** or they error-but-create → duplicates.
6. **No delete** for packages/elements → name throwaways `ZZ_*`, remove in EA.
7. No transaction — a timeout leaves a partial model. `create_baseline` before big builds.
8. Type strings are exact/case-sensitive (`Use Case`, `StateMachine`, `ControlFlow`).
