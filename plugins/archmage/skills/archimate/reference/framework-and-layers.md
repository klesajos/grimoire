# ArchiMate 3.2 — framework, layers, and aspects

Reference for the structure of the ArchiMate language: how concepts are organized into layers and aspects, the generic metamodel that every layer specializes, and the layer color convention. Source: *ArchiMate 3.2 Specification*, The Open Group C226 (2022).

## Contents

- [The core idea: layers × aspects](#the-core-idea-layers--aspects)
- [The three aspects (the columns)](#the-three-aspects-the-columns)
- [The layers (the rows)](#the-layers-the-rows)
- [The Full Framework grid](#the-full-framework-grid)
- [The generic metamodel (the pattern every layer repeats)](#the-generic-metamodel-the-pattern-every-layer-repeats)
- [Layer colors and notation conventions](#layer-colors-and-notation-conventions)
- [Why this matters in practice](#why-this-matters-in-practice)

## The core idea: layers × aspects

ArchiMate organizes its concepts along **two dimensions**:

- **Layers** (horizontal bands) — distinguish *who/what part of the enterprise* a concept belongs to: Strategy, Business, Application, Technology, Physical, plus two cross-cutting **aspects-as-layers** for Motivation and Implementation & Migration.
- **Aspects** (vertical columns) — distinguish *the role a concept plays*: Active Structure (the doer), Behavior (the doing), Passive Structure (the done-to). Plus a **Motivation** aspect that cuts across all.

A concept's identity = its layer + its aspect. "Business Process" = Business layer × Behavior aspect. "Application Component" = Application layer × Active Structure aspect. This grid is the single most useful mental model for choosing the right element.

## The three aspects (the columns)

| Aspect | Question it answers | Generic concept | Examples |
|--------|---------------------|-----------------|----------|
| **Active Structure** | *Who/what performs behavior?* (the subject) | Active structure element | Business Actor/Role, Application Component, Node |
| **Behavior** | *What is done?* (the verb) | Behavior element | Business Process/Function, Application Function, Technology Service |
| **Passive Structure** | *On what is behavior performed?* (the object) | Passive structure element | Business Object, Data Object, Artifact |

A fourth, **Motivation aspect**, cuts across the three to capture *why* (drivers, goals, requirements, principles).

The defining sentence of the metamodel: an **active structure element** is **assigned to** a **behavior element**, which **accesses** a **passive structure element**, and which is exposed to the environment as a **service** through an **interface**.

## The layers (the rows)

From top (intent) to bottom (realization):

1. **Strategy** — strategic direction and choices: capabilities, resources, courses of action, value streams. *Why/what at the highest level — what the enterprise is able to do and how it deploys assets.*
2. **Business** — products and services to customers, realized by business processes performed by business actors/roles. *The business operating model.*
3. **Application** — application services that support the business, realized by application components and their functions, operating on data. *The software landscape.*
4. **Technology** — technology/infrastructure services that support applications: nodes, devices, system software, networks, artifacts. *The platform.*
5. **Physical** — an extension of Technology for the physical world: equipment, facilities, materials, distribution networks (manufacturing, logistics, IoT, plant). *Modeled together with Technology.*

Two aspects span all layers and are usually drawn as their own areas:

- **Motivation** — stakeholders, drivers, assessments, goals, outcomes, principles, requirements, constraints, meaning, value. *Why the architecture is shaped the way it is.*
- **Implementation & Migration** — work packages, deliverables, implementation events, plateaus, gaps. *How you get from baseline to target architecture (the bridge to programs/projects and to TOGAF's Phases E–F).*

## The Full Framework grid

![A layered view — Business (yellow), Application (cyan), and Technology (green) layers](images/archimate-layered-view.png)

*Rendered in Sparx Enterprise Architect.*

The ArchiMate 3.2 "Full Framework" places layers (rows) against aspects (columns). Motivation and Implementation & Migration sit as bands across the top/bottom.

```
                 ACTIVE STRUCTURE      BEHAVIOR              PASSIVE STRUCTURE      | MOTIVATION (across)
                 (who)                 (what is done)        (on what)              |
 ----------------------------------------------------------------------------------+--------------------
 STRATEGY        Resource              Capability,           (—)                    | Stakeholder
                                       Course of Action,                            | Driver
                                       Value Stream                                 | Assessment
 ----------------------------------------------------------------------------------+ Goal
 BUSINESS        Business Actor,       Business Process,     Business Object,       | Outcome
                 Business Role,        Business Function,    Contract,              | Principle
                 Business Collab.,     Business Interaction, Representation,        | Requirement
                 Business Interface    Business Event,       Product               | Constraint
                                       Business Service                            | Meaning
 ----------------------------------------------------------------------------------+ Value
 APPLICATION     Application Comp.,    Application Function, Data Object            |
                 Application Collab.,  Application Interact.,                       |
                 Application Interface Application Process,                         |
                                       Application Event,                          |
                                       Application Service                         |
 ----------------------------------------------------------------------------------+
 TECHNOLOGY      Node, Device,         Technology Function,  Artifact               |
                 System Software,      Technology Process,                          |
                 Tech. Collaboration,  Technology Interact.,                        |
                 Technology Interface, Technology Event,                            |
                 Path,                 Technology Service                           |
                 Communication Network                                             |
 ----------------------------------------------------------------------------------+
 PHYSICAL        Equipment,            (uses Technology       Material              |
                 Facility,              behavior elements)                          |
                 Distribution Network                                              |
 ----------------------------------------------------------------------------------+--------------------
 IMPLEMENTATION & MIGRATION (across):  Work Package, Deliverable, Implementation Event, Plateau, Gap
 ----------------------------------------------------------------------------------------------------
 COMPOSITE (any layer):  Location, Grouping
```

Notes:
- The **Service** and **Interface** concepts appear in Business, Application, and Technology layers — a service is the externally visible behavior exposed through an interface; this is the mechanism by which one layer **serves** the layer above it.
- **Strategy** has no passive-structure element of its own.
- **Physical** reuses Technology's behavior elements (a Facility is acted on by technology processes); only its active-structure and the passive **Material** are physical-specific.
- For the exact, exhaustive element list with definitions and notation, see `elements.md`.

## The generic metamodel (the pattern every layer repeats)

Every core layer (Business, Application, Technology) instantiates the **same** structural pattern. Learn it once and you can read any layer:

```
 [Active structure] --assigned to--> [Internal behavior] --realizes--> [Service] 
       (e.g. Role)                     (e.g. Process/Function)            (exposed externally)
                                              |                              ^
                                          accesses                          | exposed through
                                              v                              |
                                      [Passive structure]              [Interface]
                                        (e.g. Object)            (active structure, the access point)
```

- **Internal** active-structure/behavior elements live inside the layer; **external** ones (Service, Interface) are what the layer offers to its environment.
- A higher layer consumes a lower layer's services via the **Serving** relationship; the lower layer **realizes** the service. This "realize a service, then serve upward" chain is what makes a *layered* view coherent (it is the backbone of the Layered Viewpoint).

## Layer colors and notation conventions

Color is **not normative** but the de-facto standard (used by Archi, EA, Visual Paradigm, BiZZdesign):

| Layer / aspect | Conventional color |
|----------------|--------------------|
| Strategy | Orange / yellow-orange |
| Business | Yellow |
| Application | Cyan / light blue |
| Technology | Green |
| Physical | Green (darker / same family as Technology) |
| Motivation | Purple / violet |
| Implementation & Migration | Pink / rose |

Notation conventions:
- Each element is a **rectangle** with a small **icon in the top-right corner** identifying its type (e.g., the gear-like icon for processes, the chevron for functions, the rounded "lozenge" for services).
- Elements can be shown **boxed** (rectangle + icon) or as a bare **icon** — equivalent.
- Aspect hint by shape: active-structure boxes often have square corners; behavior elements use rounded corners; service is a rounded "stadium" shape; interface is a small socket/lollipop.

## Why this matters in practice

- **Choosing an element** = locate it on the grid: decide the *layer* (whose concern), then the *aspect* (doer / doing / done-to). E.g., "the thing that runs the claim check" is Behavior; in software it's an **Application Function**; the human-process version is a **Business Process**.
- **Layered consistency** = make sure each layer *serves* the one above and *realizes* services for it; that's how a Business→Application→Technology view holds together (see `worked-example.md`).
- **Don't cross layers with the wrong relationship** — e.g., an Application Component should not be *assigned to* a Business Process; it *serves* it (the data on which they both operate is shared via Access). Relationship validity is in `relationships.md`.
