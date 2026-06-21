---
name: uml
description: Reference for UML 2.5.1 (OMG formal/17-12-05) covering all 14 diagram types - structure (class, object, package, composite structure, component, deployment, profile) and behavior (use case, activity, state machine, and the sequence, communication, timing, and interaction overview interaction diagrams) - with notation rules, well-formedness constraints, worked examples, and a Mermaid bridge; building each in Enterprise Architect is covered by the ea-modeling skill. Use when the user asks about UML, a class/object/package/composite-structure/component/deployment/profile/use-case/activity/state-machine/sequence/communication/timing/interaction-overview diagram, UML notation, relationships, multiplicity, stereotypes, or how to model something in UML.
---

# UML 2.5.1

Authoritative reference for the Unified Modeling Language **2.5.1** (OMG document **formal/17-12-05**, December 2017). Covers all **14** canonical diagram types, their notation rules and well-formedness constraints, with a small worked example per type. Each reference file also carries a **Mermaid** rendering where Mermaid has a native equivalent (class, sequence, state, activity-as-flowchart). Building any of them in Enterprise Architect is a one-line pointer to the **`ea-modeling`** skill, which owns the EA `type` strings and the build workflow.

## When to use this skill

- The user asks *what* a UML diagram is, *when* to use it, or *how to notate* something (relationships, multiplicity, visibility, stereotypes, profiles, combined fragments, etc.).
- The user wants a UML diagram authored as text/Mermaid, or wants the modeling decisions behind one.
- The user asks "how do I model X in UML" and needs to pick the right diagram type.

## When NOT to use this skill

- **Building the diagram inside Enterprise Architect** (the actual `enterprise-architect:*` MCP call sequence, packaging, layout, message ordering) → use the **`ea-modeling`** skill. This skill only names the EA `type` strings per diagram; `ea-modeling` owns the build workflow.
- **A quick throwaway text diagram** with no need for UML rigor → use the **`mermaid`** skill directly.
- EA tool gotchas in depth (taggedValues array shape, connector direction, message ordering) live in `ea-modeling` and the shared cheatsheet below.

**Tie-breaks (when a request is ambiguous):**

- An **unqualified** "draw a class/sequence/state diagram" with no tool named → default to **`uml`** (notation-correct) over `mermaid`; only route to `mermaid` when the user asks for "diagram as text/code", a throwaway sketch, or names Mermaid/Markdown explicitly.
- "Model a **workflow / process**" splits by intent: a **business process** (lanes, actors, business-level steps) → **`bpmn`**; an **algorithmic / system control flow** (decisions, fork/join, the step-by-step logic of an operation) → **`uml`** Activity.

## Reference inventory

Open `overview-and-rules.md` first when the question is cross-cutting or you need to pick a diagram type. Otherwise jump straight to the one file for the diagram in question.

| Open this file | When |
| --- | --- |
| `reference/overview-and-rules.md` | Picking a diagram type; the structure-vs-behavior taxonomy; the 14-types table; cross-cutting notation (visibility `+ - # ~`, multiplicity, stereotypes/profiles, notes & `{constraints}`, packages/namespaces); version note. |
| `reference/class-diagram.md` | Classes, attributes, operations, association/aggregation/composition, generalization, realization, dependency, association classes. **Has Mermaid.** |
| `reference/object-diagram.md` | Instance-level snapshot: instance specifications, slots, links. **No native Mermaid.** |
| `reference/package-diagram.md` | Grouping namespaces; `«import»`/`«access»`/`«merge»`; package nesting and dependencies. **No native Mermaid.** |
| `reference/composite-structure-diagram.md` | Internal structure: parts, ports, connectors, provided/required interfaces (lollipop/socket), collaborations. **No native Mermaid.** |
| `reference/component-diagram.md` | Components, provided/required interfaces, assembly & delegation connectors, artifacts. **No native Mermaid.** |
| `reference/deployment-diagram.md` | Nodes, devices, execution environments, artifacts, `«deploy»`, communication paths. **No native Mermaid.** |
| `reference/profile-diagram.md` | Extending UML: stereotypes, `«metaclass»`, `«extension»`, tagged values, applying a profile. **No native Mermaid.** |
| `reference/use-case-diagram.md` | Actors, use cases, system boundary, `«include»`/`«extend»`, actor generalization. **No native Mermaid.** |
| `reference/activity-diagram.md` | Actions, control/object flow, decision/merge, fork/join, partitions (swimlanes), initial/final nodes. **Mermaid via flowchart.** |
| `reference/state-machine-diagram.md` | States, transitions, events/guards/effects, composite & submachine states, pseudostates, regions. **Has Mermaid.** |
| `reference/interaction-diagrams.md` | The four interaction diagrams in one file: **Sequence** (lifelines, messages, combined fragments), **Communication**, **Timing**, **Interaction Overview**. Sequence **has Mermaid**; the other three have **no native Mermaid**. |

## Building in Enterprise Architect

Building any of these diagrams in EA is a **tool** task, not a notation one. The **`ea-modeling`** skill owns the build workflow and per-diagram quirks; `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md` is the canonical type-string + hard-rule reference; `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-com-bridge.md` holds the COM display/export fixes. This skill does not restate them.
