---
name: archimate
description: Reference for ArchiMate 3.2 (The Open Group C226) enterprise-architecture modeling - the layered framework (Strategy, Business, Application, Technology, Physical) and aspects, the full element catalog, the relationship set with derivation rules, and viewpoints, plus a bridge to building ArchiMate models in Enterprise Architect. Use when the user asks about ArchiMate, enterprise architecture modeling, application/business/technology layers, ArchiMate elements or relationships, viewpoints, or how to model an enterprise architecture. For the TOGAF method/ADM, togaf applies instead.
---

# ArchiMate 3.2 modeling

ArchiMate is The Open Group's open, vendor-neutral modeling language for enterprise architecture. This skill is a reference for **ArchiMate 3.2** (The Open Group Standard, document **C226**, published 2022 — a minor revision of 3.1/3.0). It covers the layered framework and aspects, the complete element catalog, the relationship set and derivation rules, and the viewpoint mechanism, plus a bridge for building ArchiMate models in Enterprise Architect.

ArchiMate answers "what concepts exist and how do they relate"; it is the **notation/metamodel**. It is deliberately complementary to a method.

## When to use this skill

- The user asks what an ArchiMate element, relationship, layer, aspect, or viewpoint *is* or *means*.
- The user wants to model an enterprise (or part of it) — a business process, an application landscape, a technology stack, a motivation/requirements model — in ArchiMate.
- The user needs to pick the right element or relationship, or asks whether a relationship is valid between two elements.
- The user wants a layered view spanning Business → Application → Technology.

## When NOT to use this skill (route elsewhere)

- **TOGAF method / ADM phases / architecture governance / the content framework as a *process***: that is method, not notation — use the **`togaf`** skill. (ArchiMate and TOGAF are designed to be used together: ArchiMate is the notation, TOGAF the method.)
- **The mechanics of building the model inside Enterprise Architect** (creating packages, diagrams, connectors via the EA MCP, taggedValues, placement coordinates): the language reference here defines *what* to draw; for the *how-to-build* workflow use the **`ea-modeling`** skill. `reference/ea-bridge.md` is the thin mapping layer between the two.
- **Notation drawing in Mermaid**: not possible — Mermaid has **no native ArchiMate notation** (no ArchiMate elements, layer colors, or relationship line styles). See `reference/viewpoints.md` for what to do instead.

## Reference files (open the one you need)

| File | What it covers | Open it when |
|------|----------------|--------------|
| `reference/framework-and-layers.md` | The ArchiMate Full Framework: the layers (Strategy, Business, Application, Technology, Physical) plus the Motivation and Implementation & Migration aspects; the three aspects (Active Structure, Behavior, Passive Structure); the layers×aspects grid; layer colors; the generic metamodel and the active-structure / behavior / passive-structure / service / interface chain. | You need the big picture, the grid, layer/aspect definitions, or to understand *why* an element sits where it does. |
| `reference/elements.md` | The complete element catalog, per layer/aspect, with a one-line definition and notation for each. Composite elements (Location, Grouping). Notes the ArchiMate 3.2-specific changes. | You need to look up or choose a specific element, or want the exhaustive list. |
| `reference/relationships.md` | The full relationship set — structural (Composition, Aggregation, Assignment, Realization), dependency (Serving, Access, Influence, Association), dynamic (Triggering, Flow), and other (Specialization, Junction). Notation, direction conventions, the **derivation rule**, valid-combination guidance, and relationship connectors (Junction). | You need to pick/validate a relationship, get its notation, or understand derivation. |
| `reference/viewpoints.md` | The viewpoint mechanism (concern → viewpoint → view), the standard viewpoint categories (Composition/Support/Cooperation/Realization and the purpose dimension Designing/Deciding/Informing), the catalog of standard viewpoints, and the Mermaid caveat. | The user asks about viewpoints/views, or which viewpoint fits a concern/stakeholder. |
| `reference/worked-example.md` | A concrete small enterprise (online insurance quote service) modeled end-to-end: a layered view spanning Business → Application → Technology with every element and relationship named, plus a motivation snippet. | You want a worked, copyable example to learn from or adapt. |
| `reference/ea-bridge.md` | How Enterprise Architect represents ArchiMate (the ArchiMate 3 MDG, passing the fully-qualified `ArchiMate3::ArchiMate_*` type string directly — no UML base type, no stereotype layering), the element/relationship → EA-type mapping (**CONFIRMED against live EA**), and the EA MCP gotchas. Points to `ea-modeling`. | The user wants to build the ArchiMate model in EA, or asks how ArchiMate maps to EA types. |

Authoritative source: *ArchiMate® 3.2 Specification*, The Open Group Standard C226 (https://pubs.opengroup.org/architecture/archimate32-doc/). Cite it for any normative claim.
