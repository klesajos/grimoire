# Notation → EA mapping

How a concept from UML / BPMN / ArchiMate becomes an EA `type` (and which diagram to host it on).
Type strings are the source of truth in
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`; this file is the *translation
guide* from notation to those strings. For the notation rules themselves, use the `uml`, `bpmn`,
and `archimate` spells.

## Contents
- [UML → EA](#uml--ea)
- [BPMN → EA](#bpmn--ea)
- [ArchiMate → EA](#archimate--ea)

## UML → EA

| UML thing | EA diagram `type` | EA element/connector `type` |
| --- | --- | --- |
| Class diagram | `Class` | elements `Class`/`Interface`; connectors `Association`/`Aggregation`/`Generalization`/`Dependency`/`Realization` |
| Class attribute / operation | — | `create_or_update_attributes` / `create_or_update_operations` on the class ID |
| Use case diagram | `Use Case` | elements `UseCase`/`Actor`; `Association`; «include»/«extend» = `Dependency` + `stereotypes:"include"/"extend"` |
| Sequence diagram | `Sequence` | lifeline element `Sequence`; messages via `create_or_update_messages` (open the diagram first!) |
| Activity diagram | `Activity` | `Action`, `Decision` (diamond), initial/final `StateNode`; edges `ControlFlow` |
| State machine diagram | `StateMachine` | `State`, initial/final `StateNode`; transitions `StateFlow` |
| Requirements | `Requirements` (confirmed) | `Requirement` (confirmed — the UML element, distinct from the ArchiMate `ArchiMate3::ArchiMate_Requirement`); realise with `Realization`/`Dependency` |
| Object diagram | `Object` | `Object` instances (slots via `Element.RunState`, COM); `Association`/links |
| Component diagram | `Component` | `Component`, `Interface`, `Artifact`, `Port` (+`owningElementID`); `Realization`/`Dependency` (expanded interfaces), `Assembly` (ball-and-socket), `Manifest` (artifact→component) |
| Deployment diagram | `Deployment` | `Node`, `Device`, `Artifact`, `Component`; `Dependency`+`stereotypes:"deploy"`, `CommunicationPath` (node↔node); deploy-by-containment = nest the artifact rect inside the node (COM z-order) |
| Composite structure diagram | `Composite Structure` | `Part`/`Class`/`Port` (all `Port`/`Part` need `owningElementID`); `Connector` (assembly/delegation); provided/required interfaces render expanded (`Realization`=provided, `Dependency`=required) |
| Profile diagram | `Profile` | `Class`+`stereotypes:"stereotype"`/`"metaclass"` (no `Stereotype` type); `Extension` (stereotype→metaclass, filled triangle), `Generalization` |
| Package diagram | `Package` (confirmed) | packages; `Dependency`+`stereotypes:"import"/"access"/"merge"` for the labelled variants |
| Communication diagram | `Communication` | reuse object/class lifelines; `Association` links carry the numbered messages |
| Timing diagram | `Timing` | state/value lifeline with a state timeline — **verify in live EA** |
| Interaction Overview diagram | `Interaction Overview` | `InteractionOccurrence`/`InteractionFragment` frames + `Decision`/`StateNode`/`Synchronization`; `ControlFlow` edges — **verify in live EA** |

Confirmed diagram `type` strings (all hand-verified live): `Class`, `Use Case`, `Sequence`,
`Activity`, `StateMachine`, `Requirements`, `Object`, `Component`, `Deployment`,
`Composite Structure`, `Profile`, `Package`, `Communication`, `Timing`, `Interaction Overview` — i.e.
every UML diagram type. **Display fixes the MCP can't do** (navigability arrows, headless-connector
heads, composite diamonds, visible initial/final nodes, swimlanes, object slots, PNG export) go
through `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`.

The UML `Requirement` **element** string and the `Package` diagram type are also **confirmed live**
through the MCP. Note that the UML `Requirement` element is distinct from the ArchiMate
`ArchiMate3::ArchiMate_Requirement` (see the `archimate` spell's `ea-bridge.md`) — both are
confirmed, but they are different MDG types.

## BPMN → EA

EA models BPMN via the **BPMN 2.0 MDG technology**: elements are UML elements carrying BPMN
profile stereotypes, hosted on a BPMN business-process diagram rather than a plain Activity diagram.

> **Confirmed limitation: BPMN is NOT creatable via the
> `enterprise-architect:create_or_update_elements` MCP create tool.** A type string like
> `"BPMN2.0::Activity"` errors ("Invalid type"), and passing it in the `stereotypes` field strips
> the `BPMN2.0` profile prefix — you get a plain `«Activity»` UML element, not real BPMN notation.
> This is a settled dead-end, not an unverified string: don't probe it on a throwaway. To author
> BPMN in EA, place the elements from the **EA GUI toolbox** for now; the MCP MDG strings for BPMN
> are unresolved. When the goal is just a diagram in the repo, ship the **labelled Mermaid
> approximation** the `bpmn` spell produces. This matches
> `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md` and the `bpmn` spell.

The table below names the EA MDG concepts for reference only — it is **not** a create recipe:
| BPMN thing | EA MDG host | Note |
| --- | --- | --- |
| Process diagram | BPMN business-process diagram | created in the EA GUI |
| Task / Sub-Process | `«BPMN2.0::Activity»` element | task type via a tagged value |
| Gateway (XOR/AND/OR/event-based) | `«BPMN2.0::Gateway»` element | gateway kind via a tagged value |
| Start/Intermediate/End event | `«BPMN2.0::Event»` element | trigger via a tagged value |
| Sequence Flow / Message Flow | BPMN connector stereotypes | direction `"Unspecified"` |
| Pool / Lane | BPMN swimlane constructs | placed in the EA GUI |

## ArchiMate → EA

EA ships an **ArchiMate 3 MDG technology**. Through the MCP, ArchiMate is created with
**fully-qualified `type` strings** passed directly in the `type` field — **no** UML base type plus a
stereotype. Elements use `ArchiMate3::ArchiMate_<Name>` and connectors use
`ArchiMate3::ArchiMate_<Rel>` — note the casing **`ArchiMate3`** (capital M). The type drives the
icon, layer colour, and allowed connections. The catalog below is **confirmed live** through the MCP
against a real repository (this is the single home for it; the `archimate` spell describes the
*notation*, this file the *EA types*). For the build workflow see `build-workflow.md`; for the
display/export COM fixes see `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md`.

**Host the view on a `Class` diagram** (`create_or_update_diagram` with `type:"Class"`). The
ArchiMate view diagram-type FQN is **unresolved**: the bare `ArchiMate3::Layered` was not recognised
in testing and silently fell back to `Class` (the live schema's example is `Archimate3::Application`,
lowercase `m`, so the real view FQN is probably `Archimate3::<ViewName>` — unconfirmed). Use `Class`
directly — the `ArchiMate3::ArchiMate_*` elements still render full ArchiMate notation on it. This is
the **only** ArchiMate EA string not confirmed live; every element/relationship string below is.

**Element types** — pass in the `type` field of `create_or_update_elements`. Form
`ArchiMate3::ArchiMate_<ElementName>` (no spaces); all **confirmed**:

| Layer | ArchiMate elements (suffix after `ArchiMate3::ArchiMate_`) |
|---|---|
| **Business** | `BusinessActor`, `BusinessRole`, `BusinessCollaboration`, `BusinessInterface`, `BusinessProcess`, `BusinessFunction`, `BusinessInteraction`, `BusinessEvent`, `BusinessService`, `BusinessObject`, `Contract`, `Representation`, `Product` |
| **Application** | `ApplicationComponent`, `ApplicationCollaboration`, `ApplicationInterface`, `ApplicationFunction`, `ApplicationInteraction`, `ApplicationProcess`, `ApplicationEvent`, `ApplicationService`, `DataObject` |
| **Technology** | `Node`, `Device`, `SystemSoftware`, `TechnologyCollaboration`, `TechnologyInterface`, `Path`, `CommunicationNetwork`, `TechnologyFunction`, `TechnologyProcess`, `TechnologyInteraction`, `TechnologyEvent`, `TechnologyService`, `Artifact` |
| **Physical** | `Equipment`, `Facility`, `DistributionNetwork`, `Material` |
| **Motivation** | `Stakeholder`, `Driver`, `Assessment`, `Goal`, `Outcome`, `Principle`, `Requirement`, `Constraint`, `Meaning`, `Value` |
| **Strategy** | `Resource`, `Capability`, `CourseOfAction`, `ValueStream` |
| **Implementation & Migration** | `WorkPackage`, `Deliverable`, `ImplementationEvent`, `Plateau`, `Gap` |
| **Composite** | `Grouping`, `Location` |

> The Motivation `ArchiMate3::ArchiMate_Requirement` is a **different MDG type** from the UML
> `Requirement` element (used on a `Requirements` diagram) — don't confuse them.

**Relationship types** — pass in the `type` field of `create_or_update_connectors` with
`direction:"Unspecified"`. All **confirmed**:

`ArchiMate3::ArchiMate_` + `Composition` · `Aggregation` · `Assignment` · `Realization` · `Serving` ·
`Access` · `Influence` · `Association` · `Triggering` · `Flow` · `Specialization`.

Notes:
- **Junction** is an **element** (`ArchiMate3::ArchiMate_Junction`, the AND/OR node), **not** a
  connector — model it as an element and route the branches through it.
- **Access mode** (read/write/read-write) and **Influence sign** (+/−) are set as a connector
  **tagged value**, not a distinct type — verify the exact `taggedValues` name the MDG expects.
- **Serving and the other open-arrow relationships render HEADLESS** (the MCP leaves direction
  unspecified). Set the connector's `Direction` via the COM bridge to draw the arrowhead.
  **Assignment** (ball+arrow) and **Realization** (hollow triangle) render their heads intrinsically.
- Lay layers top-to-bottom (Business high, Technology low) so the Serving/Realization spine reads
  vertically, matching the Layered Viewpoint. A one-element smoke-test (create + read back / render)
  before a 40-element build catches a typo or MDG-version mismatch cheaply.
