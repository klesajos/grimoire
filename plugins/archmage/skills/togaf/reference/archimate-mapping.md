# Mapping ArchiMate onto the ADM

TOGAF (the *method*) and ArchiMate (the *modeling language*) are complementary Open Group standards: the ADM tells you **which architecture to develop in which phase**, and ArchiMate gives you a **notation to express it**. This file maps ADM phases and their artifacts onto ArchiMate layers and elements. For the ArchiMate language itself — element/relationship semantics, the full layer set, and viewpoints — use the **`archimate`** skill.

## ArchiMate layers in one line

- **Strategy** layer — Resource, Capability, Course of Action, Value Stream.
- **Business** layer — Business Actor/Role/Collaboration, Business Process/Function/Interaction, Business Service, Business Object, Product, Contract.
- **Application** layer — Application Component/Collaboration, Application Function, Application Service, Application Interface, Data Object.
- **Technology** layer — Node, Device, System Software, Technology Service, Artifact, Communication Network, Path (plus the **Physical** elements: Equipment, Facility, Material).
- **Motivation** layer (cross-cutting) — Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, Constraint, Value, Meaning.
- **Implementation & Migration** layer — Work Package, Deliverable, Implementation Event, Plateau, Gap.

## ADM phase → ArchiMate mapping

| ADM phase | Primary TOGAF artifacts | ArchiMate layer(s) | Key ArchiMate elements |
|-----------|--------------------------|--------------------|------------------------|
| **Preliminary** | Architecture Principles, Org Model | **Motivation** | Principle, Stakeholder, Driver |
| **A — Architecture Vision** | Architecture Vision, Stakeholder Map, Solution Concept, Value Chain | **Motivation** + **Strategy** | Stakeholder, Driver, Assessment, Goal, Outcome, Value; Capability, Value Stream, Course of Action, Resource |
| **B — Business Architecture** | Business Footprint, Functional Decomposition, Org/Actor & Goal catalogs, Process Flow | **Business** (+ **Motivation**) | Business Actor/Role, Business Process/Function, Business Service, Business Object, Product; Goal/Requirement (Motivation) |
| **C — Data Architecture** | Conceptual/Logical Data diagrams, Data Entity catalog, Data/Function & App/Data matrices | **Application** (passive) | **Data Object** (and Business Object at the business level); Representation/Meaning for information |
| **C — Application Architecture** | Application Communication & Portfolio, Interface catalog, Application Interaction matrix | **Application** | Application Component, Application Collaboration, Application Function, **Application Service**, Application Interface |
| **D — Technology Architecture** | Platform Decomposition, Environments & Locations, Network/Hardware, Technology Standards catalog | **Technology** (+ **Physical**) | Node, Device, System Software, **Technology Service**, Artifact, Communication Network, Path; Equipment/Facility (Physical) |
| **E — Opportunities & Solutions** | Architecture Roadmap, Transition Architectures, Project Context/Benefits | **Implementation & Migration** | Work Package, Deliverable, **Plateau** (= Transition Architecture), **Gap** |
| **F — Migration Planning** | Implementation & Migration Plan | **Implementation & Migration** | Work Package, Deliverable, Implementation Event, Plateau |
| **G — Implementation Governance** | Architecture Contract, Compliance Assessment | **Implementation & Migration** + realization links | Work Package, Deliverable; realization relationships to architecture elements |
| **H — Change Management** | Change Requests, architecture updates | Any layer (the changed elements) | (re-uses elements from the affected layers) |
| **Requirements Management** | Architecture Requirements Specification | **Motivation** | **Requirement**, Constraint, Goal, Principle |

## How the mappings line up structurally

- **Baseline vs Target** architectures map cleanly to **Plateaus** in the Implementation & Migration layer; the differences between them are **Gap** elements — which is exactly what TOGAF gap analysis in B/C/D produces and what Phase E consolidates.
- **ABB vs SBB** (TOGAF building blocks) both render as ArchiMate **structural elements** (Components, Nodes, Services); the abstraction difference is captured by *how generic* the modeled element is, not by a different notation.
- The **Motivation** layer is the natural home for everything in the TOGAF *Architecture Vision* and *Requirements Management* hub (drivers, goals, principles, requirements) — it threads through every ADM phase, just like Requirements Management sits at the center of the ADM wheel.
- A TOGAF **catalog** ≈ an ArchiMate element list; a **matrix** ≈ a relationship/cross-reference view; a **diagram** ≈ an ArchiMate **view** built from a **viewpoint**.

## Practical guidance

- Use ArchiMate's **layering with service realization** (each layer *serves* the one above; each layer's services are *realized* by the layer below) to keep TOGAF's Business→Application→Technology chain consistent across Phases B→C→D.
- Pick ArchiMate **viewpoints** to satisfy the **stakeholder concerns** identified in Phase A — this is the formal bridge between TOGAF's stakeholder management and ArchiMate's viewpoint mechanism.
- To author these views in a tool (Sparx Enterprise Architect), see the **`ea-modeling`** skill. For the precise semantics of any element/relationship named above, see the **`archimate`** skill.
