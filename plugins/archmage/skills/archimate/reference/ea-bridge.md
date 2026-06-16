# ArchiMate → Enterprise Architect bridge

How Sparx Enterprise Architect represents ArchiMate, and the mapping from ArchiMate 3.2 elements/relationships to EA's MDG types. This file defines **what to create**; for the **build workflow** (the create→connect→diagram→place→verify loop, subagent delegation, baselines) use the **`ea-modeling`** skill. Canonical EA type strings live once in `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

> **Status legend.** The EA MDG type strings below are **CONFIRMED** working against live EA: you pass the fully-qualified `ArchiMate3::ArchiMate_<Name>` string directly as the `type` field (capital **M** in `ArchiMate3`). The *schema gotchas* at the bottom are also confirmed.

## Contents

- [How EA models ArchiMate](#how-ea-models-archimate)
- [Element → EA type mapping](#element--ea-type-mapping)
- [Relationship → EA type mapping](#relationship--ea-type-mapping)
- [Building an ArchiMate view in EA](#building-an-archimate-view-in-ea)
- [Schema gotchas (confirmed)](#schema-gotchas-confirmed)
- [Smoke-test before a large build](#smoke-test-before-a-large-build)

## How EA models ArchiMate

Enterprise Architect ships an **ArchiMate 3 MDG technology** (Model Driven Generation). Through the MCP it exposes ArchiMate as **first-class fully-qualified types**:

- Every ArchiMate **element** is created by passing the MDG type `ArchiMate3::ArchiMate_<Name>` directly in the `type` field, e.g. `ArchiMate3::ArchiMate_BusinessProcess`, `ArchiMate3::ArchiMate_ApplicationComponent`, `ArchiMate3::ArchiMate_Node`. The type drives the icon, the layer color, and which connections EA allows. (You do **not** pass a separate UML base type plus a stereotype.)
- Every ArchiMate **relationship** is a connector created the same way: `ArchiMate3::ArchiMate_<Relationship>` in the `type` field, e.g. `ArchiMate3::ArchiMate_Serving`, `ArchiMate3::ArchiMate_Realization`, `ArchiMate3::ArchiMate_Assignment`, `ArchiMate3::ArchiMate_Triggering`.
- ArchiMate **views** render on a plain `Class` diagram — the ArchiMate diagram-type string is unresolved via the MCP, but ArchiMate elements still draw with full ArchiMate notation on a `Class` diagram, so just use `type: "Class"` for the diagram (see the cheatsheet).

So via the EA MCP you create ArchiMate by passing the fully-qualified `ArchiMate3::ArchiMate_<Name>` string as `type` — no UML base type, no stereotype layering. Note the casing **`ArchiMate3`** (capital M).

## Element → EA type mapping

Pass to `enterprise-architect:create_or_update_elements` in the `type` field. The type strings are the fully-qualified MDG form `ArchiMate3::ArchiMate_<ElementName>` (no spaces) — **all CONFIRMED** against live EA.

### Business layer
| ArchiMate element | EA type (confirmed) |
|---|---|
| Business Actor | `ArchiMate3::ArchiMate_BusinessActor` |
| Business Role | `ArchiMate3::ArchiMate_BusinessRole` |
| Business Collaboration | `ArchiMate3::ArchiMate_BusinessCollaboration` |
| Business Interface | `ArchiMate3::ArchiMate_BusinessInterface` |
| Business Process | `ArchiMate3::ArchiMate_BusinessProcess` |
| Business Function | `ArchiMate3::ArchiMate_BusinessFunction` |
| Business Interaction | `ArchiMate3::ArchiMate_BusinessInteraction` |
| Business Event | `ArchiMate3::ArchiMate_BusinessEvent` |
| Business Service | `ArchiMate3::ArchiMate_BusinessService` |
| Business Object | `ArchiMate3::ArchiMate_BusinessObject` |
| Contract | `ArchiMate3::ArchiMate_Contract` |
| Representation | `ArchiMate3::ArchiMate_Representation` |
| Product | `ArchiMate3::ArchiMate_Product` |

### Application layer
| ArchiMate element | EA type (confirmed) |
|---|---|
| Application Component | `ArchiMate3::ArchiMate_ApplicationComponent` |
| Application Collaboration | `ArchiMate3::ArchiMate_ApplicationCollaboration` |
| Application Interface | `ArchiMate3::ArchiMate_ApplicationInterface` |
| Application Function | `ArchiMate3::ArchiMate_ApplicationFunction` |
| Application Interaction | `ArchiMate3::ArchiMate_ApplicationInteraction` |
| Application Process | `ArchiMate3::ArchiMate_ApplicationProcess` |
| Application Event | `ArchiMate3::ArchiMate_ApplicationEvent` |
| Application Service | `ArchiMate3::ArchiMate_ApplicationService` |
| Data Object | `ArchiMate3::ArchiMate_DataObject` |

### Technology layer
| ArchiMate element | EA type (confirmed) |
|---|---|
| Node | `ArchiMate3::ArchiMate_Node` |
| Device | `ArchiMate3::ArchiMate_Device` |
| System Software | `ArchiMate3::ArchiMate_SystemSoftware` |
| Technology Collaboration | `ArchiMate3::ArchiMate_TechnologyCollaboration` |
| Technology Interface | `ArchiMate3::ArchiMate_TechnologyInterface` |
| Path | `ArchiMate3::ArchiMate_Path` |
| Communication Network | `ArchiMate3::ArchiMate_CommunicationNetwork` |
| Technology Function | `ArchiMate3::ArchiMate_TechnologyFunction` |
| Technology Process | `ArchiMate3::ArchiMate_TechnologyProcess` |
| Technology Interaction | `ArchiMate3::ArchiMate_TechnologyInteraction` |
| Technology Event | `ArchiMate3::ArchiMate_TechnologyEvent` |
| Technology Service | `ArchiMate3::ArchiMate_TechnologyService` |
| Artifact | `ArchiMate3::ArchiMate_Artifact` |

### Physical
| ArchiMate element | EA type (confirmed) |
|---|---|
| Equipment | `ArchiMate3::ArchiMate_Equipment` |
| Facility | `ArchiMate3::ArchiMate_Facility` |
| Distribution Network | `ArchiMate3::ArchiMate_DistributionNetwork` |
| Material | `ArchiMate3::ArchiMate_Material` |

### Motivation
| ArchiMate element | EA type (confirmed) |
|---|---|
| Stakeholder | `ArchiMate3::ArchiMate_Stakeholder` |
| Driver | `ArchiMate3::ArchiMate_Driver` |
| Assessment | `ArchiMate3::ArchiMate_Assessment` |
| Goal | `ArchiMate3::ArchiMate_Goal` |
| Outcome | `ArchiMate3::ArchiMate_Outcome` |
| Principle | `ArchiMate3::ArchiMate_Principle` |
| Requirement | `ArchiMate3::ArchiMate_Requirement` |
| Constraint | `ArchiMate3::ArchiMate_Constraint` |
| Meaning | `ArchiMate3::ArchiMate_Meaning` |
| Value | `ArchiMate3::ArchiMate_Value` |

### Strategy
| ArchiMate element | EA type (confirmed) |
|---|---|
| Resource | `ArchiMate3::ArchiMate_Resource` |
| Capability | `ArchiMate3::ArchiMate_Capability` |
| Course of Action | `ArchiMate3::ArchiMate_CourseOfAction` |
| Value Stream | `ArchiMate3::ArchiMate_ValueStream` |

### Implementation & Migration
| ArchiMate element | EA type (confirmed) |
|---|---|
| Work Package | `ArchiMate3::ArchiMate_WorkPackage` |
| Deliverable | `ArchiMate3::ArchiMate_Deliverable` |
| Implementation Event | `ArchiMate3::ArchiMate_ImplementationEvent` |
| Plateau | `ArchiMate3::ArchiMate_Plateau` |
| Gap | `ArchiMate3::ArchiMate_Gap` |

### Composite
| ArchiMate element | EA type (confirmed) |
|---|---|
| Grouping | `ArchiMate3::ArchiMate_Grouping` |
| Location | `ArchiMate3::ArchiMate_Location` |

## Relationship → EA type mapping

Pass the fully-qualified MDG type directly to `enterprise-architect:create_or_update_connectors` in the `type` field — no UML base type, no stereotype layering. The type strings below are **CONFIRMED**. **Set `direction: "Unspecified"`** (the literal `"Source -> Destination"` form FAILS).

| ArchiMate relationship | EA connector `type` (confirmed) |
|---|---|
| Composition | `ArchiMate3::ArchiMate_Composition` |
| Aggregation | `ArchiMate3::ArchiMate_Aggregation` |
| Assignment | `ArchiMate3::ArchiMate_Assignment` |
| Realization | `ArchiMate3::ArchiMate_Realization` |
| Serving | `ArchiMate3::ArchiMate_Serving` |
| Access | `ArchiMate3::ArchiMate_Access` |
| Influence | `ArchiMate3::ArchiMate_Influence` |
| Association | `ArchiMate3::ArchiMate_Association` |
| Triggering | `ArchiMate3::ArchiMate_Triggering` |
| Flow | `ArchiMate3::ArchiMate_Flow` |
| Specialization | `ArchiMate3::ArchiMate_Specialization` |
| Junction | (a Junction element, not a connector) — `ArchiMate3::ArchiMate_Junction` |

Notes:
- **Access mode** (read/write/read-write/access) and **Influence sign** (+/-) are usually set as a connector **property or tagged value** in EA, not as a distinct type — verify the exact `taggedValues` name/value the MDG expects.
- **Junction** in EA is typically a small **element** (the AND/OR connector node) that relationships route through, not a connector type — model it as an `ArchiMate3::ArchiMate_Junction` element and connect the branches to it.
- Direction/semantics still follow ArchiMate (see `relationships.md`): keep the source/target consistent with the arrowhead conventions even though EA stores `direction: "Unspecified"`.

## Building an ArchiMate view in EA

![Built in Enterprise Architect via the ArchiMate 3 MDG (element/relationship types confirmed)](images/archimate-layered-view.png)

*Rendered in Sparx Enterprise Architect.*

Follow the canonical order from `ea-modeling` (don't reinvent it here):

```
create_or_update_package        # parent first → capture packageID
  → create_or_update_elements   # type "ArchiMate3::ArchiMate_*"; arrays → capture IDs
  → create_or_update_connectors # type "ArchiMate3::ArchiMate_*"; direction "Unspecified"
  → create_or_update_diagram    # type "Class" (ArchiMate diagram-type string is unresolved; Class still renders ArchiMate notation)
  → place_elements_on_diagram   # x,y > 10
  → layout_connectors           # auto-route
  → get_diagram_image           # VERIFY the render — colors/icons confirm the types took
```

Lay layers top-to-bottom (Business high, Technology low) so the Serving/Realization spine reads vertically, matching the Layered Viewpoint (see `viewpoints.md` and the `worked-example.md` insurance model).

## Schema gotchas (confirmed)

These are confirmed against live EA (restated from the shared cheatsheet and `ea-modeling`):

1. **`taggedValues` is an ARRAY of `{name, value}` objects** — never a `{key: value}` map (a map errors). Use this for Access-mode and Influence-sign properties.
2. **Connector `direction: "Source -> Destination"` FAILS** — use `"Unspecified"` (or omit).
3. **`create_*` tools take ARRAYS and RETURN the new IDs** — create the **package first**, capture its `packageID`, then create elements under it and capture element IDs before connecting.
4. **`place_elements_on_diagram` needs x and y > 10** — smaller coordinates are rejected/clipped.
5. **No transaction / no rollback** — a timeout mid-build leaves a partial model; `create_baseline` before a big ArchiMate build.
6. **No delete tool for elements/packages** — name throwaways `ZZ_*` and clean up in EA by hand.
7. **Always finish with `get_diagram_image`** — the render is how you confirm the ArchiMate types actually applied (right icon + layer color) rather than leaving plain UML boxes.

## Smoke-test before a large build

The `ArchiMate3::ArchiMate_*` type strings are confirmed, so no probing is needed to discover them. A one-element smoke-test is still a cheap habit before a 40-element build, to catch a typo or a different EA/MDG version early:

1. Create one element of the target type (e.g. a Business Process) via `create_or_update_elements` with `type: "ArchiMate3::ArchiMate_BusinessProcess"`.
2. Read it back with `enterprise-architect:get_elements_information` and confirm the `type` EA stored, or place it and check the render with `get_diagram_image`.
3. Then batch-create the rest with confidence.
