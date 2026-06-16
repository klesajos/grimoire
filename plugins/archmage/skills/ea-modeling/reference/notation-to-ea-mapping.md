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
- [What "verify in live EA" means here](#what-verify-in-live-ea-means-here)

## UML → EA

| UML thing | EA diagram `type` | EA element/connector `type` |
| --- | --- | --- |
| Class diagram | `Class` | elements `Class`/`Interface`; connectors `Association`/`Aggregation`/`Generalization`/`Dependency`/`Realization` |
| Class attribute / operation | — | `create_or_update_attributes` / `create_or_update_operations` on the class ID |
| Use case diagram | `Use Case` | elements `UseCase`/`Actor`; `Association`; «include»/«extend» = `Dependency` + `stereotypes:"include"/"extend"` |
| Sequence diagram | `Sequence` | lifeline element `Sequence`; messages via `create_or_update_messages` (open the diagram first!) |
| Activity diagram | `Activity` | `Action`, `Decision` (diamond), initial/final `StateNode`; edges `ControlFlow` |
| State machine diagram | `StateMachine` | `State`, initial/final `StateNode`; transitions `StateFlow` |
| Requirements | `Requirements` (confirmed) | `Requirement` (verify in live EA — the UML element is unconfirmed even though the diagram type is; not the ArchiMate `ArchiMate3::ArchiMate_Requirement`); realise with `Realization`/`Dependency` |
| Object diagram | `Object` | `Object` instances; `Association`/links |
| Component diagram | `Component` | `Component`, `Interface`; `Dependency`/`Realization` |
| Deployment diagram | `Deployment` | `Node`, `Device`, `Artifact`, `Component`; `Dependency` |
| Package diagram | `Package` (verify) | packages; `Dependency`/«import» |

Confirmed diagram `type` strings (all hand-verified live): `Class`, `Use Case`, `Sequence`,
`Activity`, `StateMachine`, `Requirements`, `Object`, `Component`, `Deployment`,
`Composite Structure`, `Profile`, `Package`, `Communication`, `Timing` — i.e. every UML diagram type.

Two **element** strings on otherwise-confirmed diagrams are still unconfirmed: the UML `Requirement`
element (hosted on the confirmed `Requirements` diagram) and EA's package-on-diagram constructs.
The confirmed `Requirements` *diagram* type does **not** imply its `Requirement` element string is
confirmed — they were verified separately, and only the diagram was. Note also that the UML
`Requirement` element is distinct from the confirmed ArchiMate `ArchiMate3::ArchiMate_Requirement`
(see the `archimate` spell's `ea-bridge.md`); one being confirmed says nothing about the other.

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

EA models ArchiMate via the **ArchiMate 3 MDG technology**. Elements and relationships are created
with **fully-qualified `type` strings** (not a bare stereotype field): elements use
`ArchiMate3::ArchiMate_<Name>` (capital M — e.g. `ArchiMate3::ArchiMate_BusinessProcess`,
`ArchiMate3::ArchiMate_ApplicationComponent`, `ArchiMate3::ArchiMate_Node`) and connectors use
`ArchiMate3::ArchiMate_<Rel>` (e.g. `ArchiMate3::ArchiMate_Serving`,
`ArchiMate3::ArchiMate_Assignment`, `ArchiMate3::ArchiMate_Realization`). These strings are
**confirmed live** through the MCP against a real repository. Build from the `archimate` spell's
layer/element/relationship catalog; its `ea-bridge.md` carries the confirmed strings.

**Host the view on a `Class` diagram** (`create_or_update_diagram` with `type:"Class"`). The
ArchiMate view diagram-type string is unresolved: the bare `ArchiMate3::Layered` was not recognised
in testing and silently fell back to `Class` (the live schema's example is `Archimate3::Application`,
lowercase `m`, so the real view FQN is probably `Archimate3::<ViewName>` — unconfirmed). Use `Class`
directly; the `ArchiMate3::ArchiMate_*` elements above still render with full ArchiMate notation on
it. See the diagram-`type` table in `ea-type-cheatsheet.md`.

## What "verify in live EA" means here

The confirmed UML strings and the ArchiMate 3 MDG strings were hand-verified through the MCP
against a real repository. Two UML strings were not: the `Package` diagram type and the
`Requirement` element type (BPMN is a separate, *settled* case — see the BPMN section above — and
is not creatable via the MCP, so there is nothing to verify there). To verify them, run the
standard `ZZ_` smoke test:
1. On a `ZZ_Verify` throwaway package, create a diagram with `type:"Package"`, and create an
   element with `type:"Requirement"` (host it on a `Requirements` diagram, which is already
   confirmed).
2. Read them back with `get_diagrams_information` / `get_elements_information` and note the exact
   `type` EA stored.
3. Update `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md` with the confirmed
   string(s), and flip the rows here to Confirmed.
4. Delete the `ZZ_Verify` package manually in EA (no MCP delete for packages or elements).
