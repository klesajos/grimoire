# ArchiMate 3.2 — relationships

The full ArchiMate relationship set, with notation, direction conventions, the derivation rule, and validity guidance. Source: *ArchiMate 3.2 Specification*, The Open Group C226 (2022), Chapter 5 and Appendix B.

## Contents

- [The four categories](#the-four-categories)
- [Structural relationships](#structural-relationships)
- [Dependency relationships](#dependency-relationships)
- [Dynamic relationships](#dynamic-relationships)
- [Other relationships](#other-relationships)
- [Relationship connectors (Junction)](#relationship-connectors-junction)
- [Direction conventions](#direction-conventions)
- [Valid relationship combinations](#valid-relationship-combinations)
- [The derivation rule](#the-derivation-rule)
- [Strength ordering (which relationship is "stronger")](#strength-ordering)
- [Quick chooser](#quick-chooser)

## The four categories

| Category | Relationships | What they express |
|----------|---------------|-------------------|
| **Structural** | Composition, Aggregation, Assignment, Realization | Static construction/composition — how things are built up and allocated. |
| **Dependency** | Serving, Access, Influence, Association | How elements are used by / depend on / support other elements. |
| **Dynamic** | Triggering, Flow | Temporal/behavioral ordering and transfer. |
| **Other** | Specialization, Junction | Generalization, and the connector for combining relationships. |

## Structural relationships

| Relationship | Notation | Meaning |
|--------------|----------|---------|
| **Composition** | Solid line, **filled diamond** at the whole (parent) end | The whole consists of the parts; parts cannot exist without the whole (strong ownership, no sharing). |
| **Aggregation** | Solid line, **hollow/open diamond** at the whole end | The whole groups the parts; parts can exist independently and be shared. |
| **Assignment** | Solid line, **filled ball/circle** at the source, **filled arrowhead** at the target | Allocation of active structure to behavior, or of behavior/interface to a service — "is responsible for / performs / is deployed on". (Role→Process, Component→Function, Node→Artifact, Interface→Service.) |
| **Realization** | **Dotted** line, **hollow/open triangle** arrowhead at the target | A more concrete element realizes a more abstract one (Process **realizes** Service; Artifact **realizes** Data Object/Component; Course of Action **realizes** Goal; Requirement **realizes** Goal). |

## Dependency relationships

| Relationship | Notation | Meaning |
|--------------|----------|---------|
| **Serving** | Solid line, **open arrowhead** at the served element | An element provides its functionality to another — "serves / is used by". The backbone of layered models (lower layer's Service *serves* the upper layer's behavior/actor). (Replaced 2.x "Used By".) |
| **Access** | **Dotted** line, **open arrowhead**; arrowhead encodes direction of data | Behavior accesses a passive structure element. Modes: **read** (arrow to behavior), **write** (arrow to object), **read/write** (arrows both ends), **access/no-arrow** (unspecified). |
| **Influence** | **Dashed** line, **open arrowhead**, optional **+ / - (or weight)** label | One element affects the achievement/implementation of another (chiefly in Motivation: a Requirement influences a Goal positively/negatively). Sign or weight indicates strength/polarity. |
| **Association** | Plain solid line (optional open arrowhead for directed association) | An unspecified/other relationship not covered by the rest; weakest, most generic. Can carry a name and direction. |

## Dynamic relationships

| Relationship | Notation | Meaning |
|--------------|----------|---------|
| **Triggering** | **Solid** line, **filled arrowhead** | A temporal/causal sequence — one behavior triggers/causes the next (control flow). Process A → Process B. |
| **Flow** | **Dashed** line, **filled arrowhead** | Transfer from one element to another, usually of **information, value, or goods** (data flow / value flow). Often labeled with what flows. |

> Easy confusion: **Triggering = solid** (causation/sequence); **Flow = dashed** (something is transferred). They often run in parallel but mean different things.

## Other relationships

| Relationship | Notation | Meaning |
|--------------|----------|---------|
| **Specialization** | Solid line, **hollow/open triangle** arrowhead at the general (parent) element | "is a kind of" — the specific element inherits the features of the general one (must be same element type; Contract specializes Business Object). |
| **Junction** | A small **filled (AND)** or **hollow (OR)** circle/dot | Not a relationship between elements but a *relationship connector* — see below. |

## Relationship connectors (Junction)

A **Junction** combines or splits relationships of the **same type**. Use it to model fork/join and and/or branching of triggering, flow, or structural relationships:

- **AND junction** (filled): all incoming/outgoing branches apply together (fork/join).
- **OR junction** (hollow): one of the branches applies (choice).

A junction lets, e.g., one Business Event trigger two parallel processes (event → AND-junction → process1, process2), or two triggers converge before the next step.

## Direction conventions

ArchiMate relationships are **directed**; read them as a sentence "source → relationship → target":

- **Composition/Aggregation**: diamond is at the **whole**; the line runs *from the whole to the part* (the diamond end owns/groups the other).
- **Assignment**: from the **active/behavioral provider** to **what it performs/realizes** (filled ball at source).
- **Realization / Specialization**: arrowhead (triangle) points at the **more abstract / more general** element ("realizes →", "is-a →").
- **Serving**: arrowhead points at the element **being served** (the consumer): "Service —serves→ Process".
- **Triggering / Flow**: arrowhead points in the **direction of control / of the thing transferred**.
- **Access**: arrowhead direction encodes read vs write (to-behavior = read, to-object = write).

## Valid relationship combinations

Not every relationship is allowed between every pair of element types. The spec defines this in a **normative relationship table** (C226, Appendix B) — a matrix of source type × target type → permitted relationships. **Do not reproduce the full table from memory**; when validity is in question, consult the spec's table (or let the modeling tool enforce it — Archi/EA only offer legal relationships in the palette).

Rules of thumb that hold broadly:
- **Assignment** connects active structure → behavior (Role→Process), or active structure → interface/node (Component→Interface, Artifact→Node), or interface/behavior → service.
- **Realization** connects a concrete element → the abstract element it realizes (Process→Service, Artifact→Data Object, Requirement→Goal, Plateau→… ).
- **Serving** crosses layers upward (Technology Service → Application Function → Business Process).
- **Access** connects a **behavior** element → a **passive structure** element only.
- **Composition/Aggregation** generally connect elements of the **same layer** (with composite Grouping/Location and the 3.2 Node changes as notable exceptions).
- **Specialization** requires **same element type**.

## The derivation rule

The **derivation rule** lets you infer a valid abstract relationship across a chain of more detailed ones, so you can draw a simplified (higher-altitude) view without losing correctness.

Core idea: a chain of **structural and dependency** relationships in the same direction can be replaced by a **single relationship of the weakest type in the chain**.

> If element **a** has a relationship to **b**, and **b** has a relationship to **c**, and both are in the permitted "potential derivation" set, then a valid derived relationship exists directly from **a** to **c**, of the *weakest* of the two types.

Example: a Business Process is *assigned to* a Business Role, the Role is *assigned to* a Business Service via the process realizing it… more practically: `Node —assigned to→ System Software —realizes→ Technology Service —serving→ Application Function` can be derived into `Node —serving→ Application Function`. This is exactly what a **Layered Viewpoint** exploits to show "Technology serves Application serves Business" without every intermediate hop.

ArchiMate 3.2 adds explicit derivation rules for **Grouping** (a relationship to a grouping can be derived to its members). Derivation is **normative** for the structural+dependency chains; use it to justify the lines you draw in summary views.

## Strength ordering

From strongest (most binding) to weakest — used by the derivation rule:

**Composition → Aggregation → Assignment → Realization → Serving → Access → Influence → Association**

The derived relationship across a chain takes the **weakest** type present. Association is the weakest and the universal fallback.

## Quick chooser

| You want to say… | Use |
|------------------|-----|
| X is made of Y, Y can't exist alone | **Composition** |
| X groups Y, Y is independent/shared | **Aggregation** |
| Actor/component performs / is deployed to do this behavior | **Assignment** |
| This concrete thing fulfills that abstract thing | **Realization** |
| X provides functionality to / is used by Y | **Serving** |
| This behavior reads/writes this data/object | **Access** |
| This motivation element pushes another up/down | **Influence** |
| A causes/sequences B (control flow) | **Triggering** |
| Information/value/goods move from A to B | **Flow** |
| X is a kind of Y (same type) | **Specialization** |
| Fork/join/choice among same-type relationships | **Junction** |
| None of the above / unspecified link | **Association** |
