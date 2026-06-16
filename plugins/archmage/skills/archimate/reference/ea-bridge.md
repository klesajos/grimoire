# ArchiMate → Enterprise Architect bridge

How Sparx Enterprise Architect represents ArchiMate, and the mapping from ArchiMate 3.2 elements/relationships to EA's MDG types and stereotypes. This file defines **what to create**; for the **build workflow** (the create→connect→diagram→place→verify loop, subagent delegation, baselines) use the **`ea-modeling`** skill. Canonical EA type strings live once in `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

> **Status legend.** The EA MDG stereotype strings below are authored from EA/ArchiMate MDG documentation and are **not** in the confirmed type list — treat every `«ArchiMate_*»` string as **"verify in live EA"** before relying on it. The *schema gotchas* at the bottom ARE confirmed.

## Contents

- [How EA models ArchiMate](#how-ea-models-archimate)
- [Element → EA stereotype mapping](#element--ea-stereotype-mapping)
- [Relationship → EA connector mapping](#relationship--ea-connector-mapping)
- [Building an ArchiMate view in EA](#building-an-archimate-view-in-ea)
- [Schema gotchas (confirmed)](#schema-gotchas-confirmed)
- [Practical confirmation recipe](#practical-confirmation-recipe)

## How EA models ArchiMate

Enterprise Architect ships an **ArchiMate 3 MDG technology** (Model Driven Generation). Under the hood:

- Every ArchiMate **element** is a UML element (usually a `Class`/`Object`-family element) carrying an ArchiMate **stereotype**, e.g. `«ArchiMate_BusinessProcess»`, `«ArchiMate_ApplicationComponent»`, `«ArchiMate_Node»`. The stereotype drives the icon, the layer color, and which connections EA allows.
- Every ArchiMate **relationship** is a UML connector carrying an ArchiMate stereotype, e.g. `«ArchiMate_Serving»`, `«ArchiMate_Realization»`, `«ArchiMate_Assignment»`, `«ArchiMate_Triggering»`.
- ArchiMate **views** are EA diagrams of an ArchiMate diagram type provided by the MDG.

So via the EA MCP you create ArchiMate by passing a UML base `type` plus the ArchiMate `stereotypes` string. The base type is commonly `Class` for boxes (active/behavior/passive structure) and the matching UML connector type for relationships; **the exact base type per element is MDG-dependent — verify in live EA** (some elements map onto `Object`, `Artifact`, `Node`, or `Action` bases).

## Element → EA stereotype mapping

Pass to `enterprise-architect:create_or_update_elements` as `stereotypes` alongside a base `type` (commonly `Class`; **verify**). Stereotype strings are the EA MDG convention `ArchiMate_<ElementName>` (no spaces) — **all "verify in live EA"**.

### Business layer
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Business Actor | `ArchiMate_BusinessActor` |
| Business Role | `ArchiMate_BusinessRole` |
| Business Collaboration | `ArchiMate_BusinessCollaboration` |
| Business Interface | `ArchiMate_BusinessInterface` |
| Business Process | `ArchiMate_BusinessProcess` |
| Business Function | `ArchiMate_BusinessFunction` |
| Business Interaction | `ArchiMate_BusinessInteraction` |
| Business Event | `ArchiMate_BusinessEvent` |
| Business Service | `ArchiMate_BusinessService` |
| Business Object | `ArchiMate_BusinessObject` |
| Contract | `ArchiMate_Contract` |
| Representation | `ArchiMate_Representation` |
| Product | `ArchiMate_Product` |

### Application layer
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Application Component | `ArchiMate_ApplicationComponent` |
| Application Collaboration | `ArchiMate_ApplicationCollaboration` |
| Application Interface | `ArchiMate_ApplicationInterface` |
| Application Function | `ArchiMate_ApplicationFunction` |
| Application Interaction | `ArchiMate_ApplicationInteraction` |
| Application Process | `ArchiMate_ApplicationProcess` |
| Application Event | `ArchiMate_ApplicationEvent` |
| Application Service | `ArchiMate_ApplicationService` |
| Data Object | `ArchiMate_DataObject` |

### Technology layer
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Node | `ArchiMate_Node` |
| Device | `ArchiMate_Device` |
| System Software | `ArchiMate_SystemSoftware` |
| Technology Collaboration | `ArchiMate_TechnologyCollaboration` |
| Technology Interface | `ArchiMate_TechnologyInterface` |
| Path | `ArchiMate_Path` |
| Communication Network | `ArchiMate_CommunicationNetwork` |
| Technology Function | `ArchiMate_TechnologyFunction` |
| Technology Process | `ArchiMate_TechnologyProcess` |
| Technology Interaction | `ArchiMate_TechnologyInteraction` |
| Technology Event | `ArchiMate_TechnologyEvent` |
| Technology Service | `ArchiMate_TechnologyService` |
| Artifact | `ArchiMate_Artifact` |

### Physical
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Equipment | `ArchiMate_Equipment` |
| Facility | `ArchiMate_Facility` |
| Distribution Network | `ArchiMate_DistributionNetwork` |
| Material | `ArchiMate_Material` |

### Motivation
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Stakeholder | `ArchiMate_Stakeholder` |
| Driver | `ArchiMate_Driver` |
| Assessment | `ArchiMate_Assessment` |
| Goal | `ArchiMate_Goal` |
| Outcome | `ArchiMate_Outcome` |
| Principle | `ArchiMate_Principle` |
| Requirement | `ArchiMate_Requirement` |
| Constraint | `ArchiMate_Constraint` |
| Meaning | `ArchiMate_Meaning` |
| Value | `ArchiMate_Value` |

### Strategy
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Resource | `ArchiMate_Resource` |
| Capability | `ArchiMate_Capability` |
| Course of Action | `ArchiMate_CourseOfAction` |
| Value Stream | `ArchiMate_ValueStream` |

### Implementation & Migration
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Work Package | `ArchiMate_WorkPackage` |
| Deliverable | `ArchiMate_Deliverable` |
| Implementation Event | `ArchiMate_ImplementationEvent` |
| Plateau | `ArchiMate_Plateau` |
| Gap | `ArchiMate_Gap` |

### Composite
| ArchiMate element | EA stereotype (verify) |
|---|---|
| Grouping | `ArchiMate_Grouping` |
| Location | `ArchiMate_Location` |

## Relationship → EA connector mapping

Pass to `enterprise-architect:create_or_update_connectors`. The MDG layers the ArchiMate `stereotypes` over a UML connector base `type`. Best-guess bases below — **all "verify in live EA"**; the stereotype is what makes EA render correct ArchiMate notation. **Set `direction: "Unspecified"`** (the literal `"Source -> Destination"` form FAILS).

| ArchiMate relationship | EA connector base `type` (verify) | EA stereotype (verify) |
|---|---|---|
| Composition | `Aggregation` (composite kind) | `ArchiMate_Composition` |
| Aggregation | `Aggregation` | `ArchiMate_Aggregation` |
| Assignment | `Association` | `ArchiMate_Assignment` |
| Realization | `Realization` | `ArchiMate_Realization` |
| Serving | `Association` / `Dependency` | `ArchiMate_Serving` |
| Access | `Dependency` | `ArchiMate_Access` |
| Influence | `Dependency` | `ArchiMate_Influence` |
| Association | `Association` | `ArchiMate_Association` |
| Triggering | `Association` / `ControlFlow` | `ArchiMate_Triggering` |
| Flow | `Association` | `ArchiMate_Flow` |
| Specialization | `Generalization` | `ArchiMate_Specialization` |
| Junction | (a Junction element, not a connector) | `ArchiMate_Junction` |

Notes:
- **Access mode** (read/write/read-write/access) and **Influence sign** (+/-) are usually set as a connector **property or tagged value** in EA, not as a distinct stereotype — verify the exact `taggedValues` name/value the MDG expects.
- **Junction** in EA is typically a small **element** (the AND/OR connector node) that relationships route through, not a connector type — model it as an `ArchiMate_Junction` element and connect the branches to it.
- Direction/semantics still follow ArchiMate (see `relationships.md`): keep the source/target consistent with the arrowhead conventions even though EA stores `direction: "Unspecified"`.

## Building an ArchiMate view in EA

Follow the canonical order from `ea-modeling` (don't reinvent it here):

```
create_or_update_package        # parent first → capture packageID
  → create_or_update_elements   # base type + ArchiMate stereotype; arrays → capture IDs
  → create_or_update_connectors # ArchiMate relationship stereotypes; direction "Unspecified"
  → create_or_update_diagram    # an ArchiMate-MDG diagram type (verify the type string in live EA)
  → place_elements_on_diagram   # x,y > 10
  → layout_connectors           # auto-route
  → get_diagram_image           # VERIFY the render — colors/icons confirm the stereotypes took
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
7. **Always finish with `get_diagram_image`** — the render is how you confirm the ArchiMate stereotypes actually applied (right icon + layer color) rather than leaving plain UML boxes.

## Practical confirmation recipe

Because the `«ArchiMate_*»` strings are unconfirmed, verify them cheaply before a large build:

1. In live EA, drop one element of the target type (e.g. a Business Process) on an ArchiMate diagram by hand, or create one via `create_or_update_elements` with your best-guess stereotype.
2. Read it back with `enterprise-architect:get_elements_information` and inspect the actual `stereotype` / `type` EA stored.
3. Correct the mapping string if it differs, then batch-create the rest.

This 1-element probe per layer is far cheaper than discovering a wrong stereotype after building 40 elements. Record confirmed strings back into the shared cheatsheet so the next build trusts them.
