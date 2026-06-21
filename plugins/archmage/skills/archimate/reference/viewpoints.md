# ArchiMate 3.2 — views and viewpoints

The viewpoint mechanism and the catalog of standard viewpoints. Source: *ArchiMate 3.2 Specification*, The Open Group C226 (2022), Chapter 14 and Appendix C ("Example Viewpoints"). The mechanism aligns with ISO/IEC/IEEE 42010.

## Contents

- [View vs viewpoint vs concern](#view-vs-viewpoint-vs-concern)
- [How viewpoints are classified](#how-viewpoints-are-classified)
- [The standard (example) viewpoints](#the-standard-example-viewpoints)
- [Key viewpoints worth knowing](#key-viewpoints-worth-knowing)
- [Defining your own viewpoint](#defining-your-own-viewpoint)
- [Mermaid caveat](#mermaid-caveat)

## View vs viewpoint vs concern

- **Concern** — an interest of a **stakeholder** (e.g. "is the architecture cost-effective?", "what depends on this server?").
- **Viewpoint** — a *specification of* what a view shows and for whom: which element/relationship types are allowed, the abstraction level, and the concern/stakeholder it targets. A viewpoint is a **lens / template**.
- **View** — an actual diagram produced *by applying* a viewpoint to a model: "what the architect designs and the stakeholder sees."

> Relationship: a **stakeholder** has a **concern**, which is addressed by a **viewpoint**, which governs a **view**. Selecting the right viewpoint is selecting the right subset of the language for the audience.

The standard viewpoints in the spec are **examples/recommendations**, not a closed set — you may tailor or invent viewpoints.

## How viewpoints are classified

ArchiMate classifies viewpoints along **two independent dimensions**:

### 1. Purpose (what the stakeholder does with it)

| Purpose | Use | Typical form |
|---------|-----|--------------|
| **Designing** | Support architects/designers from initial sketch to detailed design. | Diagrams, often formal/detailed. |
| **Deciding** | Help managers make decisions (cost, risk, impact-of-change). | Cross-references, landscape maps, tables. |
| **Informing** | Explain/convince a broad audience, gain buy-in. | Illustrations, animations, cartoons, informal pictures. |

### 2. Content / abstraction (how much of the framework it spans)

| Level | Span |
|-------|------|
| **Details** | One layer/aspect, single element + immediate environment. |
| **Coherence** | Multiple layers/aspects — how things fit together. |
| **Overview** | Whole enterprise, multiple layers and aspects at a glance. |

The spec also groups the **basic** viewpoints by the **relationship direction** they emphasize:

| Category | You are looking at… | Typical direction |
|----------|---------------------|-------------------|
| **Composition** | internal composition/aggregation of elements | within a layer |
| **Support** | elements **supported by** other elements | one layer **upward** |
| **Cooperation** | **peer** elements cooperating | across aspects, same level |
| **Realization** | elements that **realize** other elements | one layer **downward** |

## The standard (example) viewpoints

The 3.2 spec lists **25** example viewpoints, grouped as below.

**Basic — Composition:** Organization, Application Structure, Information Structure, Technology, Layered, Physical.

**Basic — Support:** Product, Application Usage, Technology Usage.

**Basic — Cooperation:** Business Process Cooperation, Application Cooperation.

**Basic — Realization:** Service Realization, Implementation and Deployment.

**Motivation:** Stakeholder, Goal Realization, Requirements Realization, Motivation.

**Strategy:** Strategy, Capability Map, Value Stream, Outcome Realization, Resource Map.

**Implementation & Migration:** Project, Migration, Implementation and Migration.

(Counts per ArchiMate 3.2 Appendix C: 13 Basic + 4 Motivation + 5 Strategy + 3 Implementation & Migration = 25. The Application Structure (Composition) and Value Stream (Strategy) viewpoints are easy to miss — older third-party summaries predate them.)

## Key viewpoints worth knowing

![A Layered viewpoint spanning Business, Application, and Technology](images/archimate-layered-view.png)

*Rendered in Sparx Enterprise Architect.*

- **Layered Viewpoint** (Overview/Composition) — the flagship. Shows core elements of **all** layers and aspects in one picture, structured by the "each layer *realizes* services that *serve* the layer above" principle. The natural home for a Business→Application→Technology story (see `worked-example.md`). Heavily relies on the **derivation rule** to keep lines manageable.
- **Service Realization Viewpoint** (Realization) — how business services are realized by business processes (and sometimes by application components/services). Good for "what delivers this service to the customer".
- **Application Cooperation Viewpoint** (Cooperation) — application components, their interfaces, and the application services/data they exchange. The application-landscape integration picture.
- **Application Usage Viewpoint** (Support) — how applications support business processes/functions (which app serves which process).
- **Implementation and Deployment Viewpoint** (Realization) — how software (artifacts/components) maps onto the technology infrastructure (nodes/devices). The deployment picture.
- **Goal Realization / Requirements Realization** (Motivation) — refine drivers→goals→outcomes→requirements/principles and trace them to the elements that satisfy them.
- **Capability Map / Resource Map** (Strategy) — a structured overview of the enterprise's capabilities or resources, often as a heatmap-able grid for **Deciding**.

## Defining your own viewpoint

A custom viewpoint is specified by: the **stakeholders** and **concerns** it serves; the **purpose** (Designing/Deciding/Informing); the **element and relationship types** allowed; and any **analysis/visualization** technique (e.g. coloring nodes by cost or status). Constrain the language to exactly what the audience needs — a good viewpoint *excludes* most of the metamodel.

## Mermaid caveat

**Mermaid has no native ArchiMate notation.** There are no ArchiMate element shapes, no layer color semantics, and no ArchiMate relationship line styles (filled/hollow diamond, dotted realization, etc.) in Mermaid. Do not claim a Mermaid diagram "is ArchiMate." Options when a quick text-based sketch is needed:

- Use a Mermaid `flowchart`/`graph` as an **informal approximation only**, and explicitly label it as not-real-ArchiMate (e.g. encode the type in the node label: `BP[«BusinessProcess» Handle Claim]`). Use subgraphs to fake the layers and edge labels (`-- serves -->`, `-. realizes .->`) to hint at relationship semantics.
- For **real** ArchiMate notation, build in a proper tool: **Archi** (free, open source, the reference editor), **Enterprise Architect** (the `ea-modeling` skill drives it via the MCP), Visual Paradigm, or BiZZdesign. These render correct icons, colors, and line styles and enforce the relationship table.
