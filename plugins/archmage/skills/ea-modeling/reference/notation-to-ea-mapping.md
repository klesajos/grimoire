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
| Requirements | `Requirements` | `Requirement` (verify in live EA); realise with `Realization`/`Dependency` |
| Object diagram | `Object` (verify) | `Object` instances; `Association`/links |
| Component diagram | `Component` (verify) | `Component`, `Interface`; `Dependency`/`Realization` |
| Deployment diagram | `Deployment` (verify) | `Node`, `Component`, `Artifact`; `Dependency` |
| Package diagram | `Package` (verify) | packages; `Dependency`/«import» |

Confirmed diagram `type` strings: `Class`, `Use Case`, `Sequence`, `Activity`, `StateMachine`,
`Requirements`. The rest are EA's standard names — **verify in live EA** before relying on them.

## BPMN → EA

EA models BPMN via the **BPMN 2.0 MDG technology**. Elements are UML elements carrying BPMN
stereotypes; the diagram is a BPMN business-process diagram, not a plain Activity diagram. The
exact EA MDG `type`/stereotype strings (e.g. for Task, Gateway, Pool/Lane, Sequence Flow, Message
Flow, the event triggers) are **not yet hand-confirmed** — treat every BPMN-in-EA string as
**"verify in live EA"**. Author the model from the `bpmn` spell's rules, then confirm the
stereotype strings against a live repository (create one of each on a `ZZ_` throwaway and read it
back with `get_elements_information`).

General shape (verify strings):
| BPMN thing | EA host | Note |
| --- | --- | --- |
| Process diagram | BPMN business-process diagram | verify the diagram `type` string |
| Task / Sub-Process | element with BPMN Activity stereotype | task type via a tagged value |
| Gateway (XOR/AND/OR/event-based) | element with BPMN Gateway stereotype | gateway kind via a tagged value |
| Start/Intermediate/End event | element with BPMN Event stereotype | trigger via a tagged value |
| Sequence Flow / Message Flow | BPMN connector stereotypes | direction `"Unspecified"` |
| Pool / Lane | BPMN swimlane constructs | verify how EA represents these |

## ArchiMate → EA

EA models ArchiMate via the **ArchiMate 3 MDG technology**. Elements/relationships are UML
elements carrying ArchiMate stereotypes (e.g. `«ArchiMate_BusinessProcess»`,
`«ArchiMate_ApplicationComponent»`, `«ArchiMate_Serving»`). These stereotype strings are
**"verify in live EA"** — confirm them against a live repo. Build from the `archimate` spell's
layer/element/relationship catalog; its `ea-bridge.md` carries the candidate strings.

## What "verify in live EA" means here

The confirmed UML strings were hand-verified through the MCP against a real repository. The MDG
strings (BPMN, ArchiMate) and the less-common UML diagram types were not. To verify one:
1. On a `ZZ_Verify` throwaway package, create one element/connector/diagram of the kind in question.
2. Read it back with `get_elements_information` / `get_connectors_information` /
   `get_diagrams_information` and note the exact `type`/stereotype EA stored.
3. Update `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md` with the confirmed string.
4. Delete the `ZZ_Verify` package manually in EA (no MCP delete for packages).
