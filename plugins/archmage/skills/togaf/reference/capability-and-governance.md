# EA Capability & Governance

The **Enterprise Architecture Capability & Governance** volume of the TOGAF Standard, 10th Edition covers *who runs architecture and how it is steered* — the organizational and governance machinery around the ADM, plus the structures that let architecture scale: the Enterprise Continuum, partitioning, iteration, and levels of architecture.

## Contents

- [The Architecture Capability](#the-architecture-capability)
- [Architecture Governance & the Architecture Board](#architecture-governance--the-architecture-board)
- [Architecture Contracts](#architecture-contracts)
- [Architecture Compliance](#architecture-compliance)
- [The Enterprise Continuum](#the-enterprise-continuum)
- [Architecture Partitioning](#architecture-partitioning)
- [ADM Iteration](#adm-iteration)
- [Levels: Strategic, Segment, Capability](#levels-strategic-segment-capability)

## The Architecture Capability

An **Architecture Capability** is the organization's ability to develop, use, and sustain architecture. The TOGAF Standard recommends establishing it as an operational entity — itself developed by **running the ADM on the architecture function** (treating "doing architecture" as the target business needing its own Business/Data/Application/Technology architecture). Outputs established in the **Preliminary Phase**: the **Organizational Model for EA**, the **Architecture Governance Framework**, **Architecture Principles**, tooling, and the Architecture Board.

## Architecture Governance & the Architecture Board

**Architecture Governance** is the practice of managing and controlling architectures at an enterprise level. It sits within a hierarchy of governance (Corporate → Technology → IT → Architecture) and rests on **discipline, transparency, independence, accountability, responsibility**, and **fairness**.

The **Architecture Board** is the cross-organization body accountable for governance:

- **Responsibilities** — oversee ADM implementation; ensure consistency between sub-architectures; approve/monitor dispensations; enforce compliance; resolve ambiguities/conflicts; provide advice, guidance, and the locus of decision-making for architecture.
- **Membership** — representatives from across the enterprise stakeholders; typically a small body (e.g. 4–5 members) meeting regularly.
- It operates the **Governance Repository** (compliance records, dispensations, contracts) — see `reference/content-framework.md`.

## Architecture Contracts

An **Architecture Contract** is a joint, signed agreement between development partners and sponsors on the deliverables, quality, and fitness-for-purpose of an architecture. They make governance *enforceable*. Two main uses:

- Between the **architecture function and the business** (statement of architecture work era).
- Between the **architecture function and implementers** in **Phase G** — the development organization commits to building in conformance with the Target Architecture, which the Architecture Board then monitors.

## Architecture Compliance

Compliance reviews check that implementation projects conform to the defined architecture. The TOGAF Standard defines a **compliance spectrum** for how a system relates to a stated architecture: *Irrelevant, Consistent, Compliant, Conformant, Fully Conformant, Non-Conformant*. A formal **Architecture Compliance Review** (typically in Phase G) produces a Compliance Assessment, and non-conformance is handled via remediation or a **dispensation** (a time-bounded waiver granted by the Architecture Board).

## The Enterprise Continuum

The **Enterprise Continuum** is a classification model / "view" of the Architecture Repository that organizes assets by their degree of specificity and supports reuse. It has two parallel continua:

- **Architecture Continuum** — abstract building blocks (ABBs), progressing through:
  **Foundation Architectures → Common Systems Architectures → Industry Architectures → Organization-Specific Architectures** (decreasing generality).
- **Solutions Continuum** — the corresponding concrete realizations (SBBs): **Foundation Solutions → Common Systems Solutions → Industry Solutions → Organization-Specific Solutions**.

Movement **left→right** (generic→specific) is how reusable assets get adapted into a specific deployment; movement right→left feeds reusable assets back. The **TRM** sits at the foundation end of the Architecture Continuum; the **III-RM** is an example of a common-systems-level model (see `reference/content-framework.md`).

## Architecture Partitioning

Partitioning divides the enterprise's architectures so that teams can work in parallel without overlap and assets stay manageable. Architectures are partitioned along several dimensions:

- **Subject matter / breadth** (which part of the enterprise — segments, domains).
- **Level of detail** (granularity).
- **Time period** (Baseline, Transition, Target).
- **Architecture domain** (Business, Data, Application, Technology).
- **Maturity / volatility**.

Partitioning is what makes the **Architecture Landscape**'s three levels (below) coherent.

## ADM Iteration

The 10th Edition stresses the ADM is **not a one-pass waterfall** (hence the arrowheads were removed from the cycle diagram). Common iteration patterns:

- **Iteration to develop a complete architecture** — cycling through B, C, D to mature them together.
- **Iteration to manage the architecture landscape** — repeating ADM cycles at different levels (strategic → segment → capability).
- **Architecture Capability iteration** — Preliminary + A to (re)establish the capability.
- **Iteration between phases** — e.g. revisiting earlier phases via Requirements Management when new requirements emerge.
- **Baseline-first vs Target-first** approaches to populating B/C/D.

## Levels: Strategic, Segment, Capability

Architecture is developed at **three levels of granularity** (matching the Architecture Landscape partitions):

| Level | Scope & purpose | Typical horizon |
|-------|------------------|-----------------|
| **Strategic Architecture** | Enterprise-wide, long-term, summary/aggregate view that gives direction and supports executive decision-making. Low detail, broad breadth. | Long-term, whole enterprise |
| **Segment Architecture** | A detailed, formal description of a coherent **segment** of the enterprise (a business unit, value stream, or program) used to direct projects. Medium detail. | Mid-term, portfolio/program |
| **Capability Architecture** | A detailed view of a specific **capability** being delivered, used to direct and assemble the implementation. High detail, narrow breadth. | Short-term, project/solution |

Strategic architectures provide context that **frames** segment architectures, which in turn frame capability architectures — and capability work feeds learnings back up.
