# ADM Phases — Objective, Steps, Outputs

The Architecture Development Method (ADM) is the core of the TOGAF Standard, 10th Edition. It is an iterative cycle of phases driven by **Requirements Management** at the center. In the 10th Edition the cycle diagram **has no directional arrowheads** — phases are not strictly sequential and you may iterate, skip, or re-enter phases as governance requires; the Preliminary↔Phase A link is bidirectional.

## Contents

- [Reading the cycle](#reading-the-cycle)
- [Preliminary Phase](#preliminary-phase)
- [Phase A: Architecture Vision](#phase-a-architecture-vision)
- [Phase B: Business Architecture](#phase-b-business-architecture)
- [Phase C: Information Systems Architectures (Data + Application)](#phase-c-information-systems-architectures)
- [Phase D: Technology Architecture](#phase-d-technology-architecture)
- [Phase E: Opportunities & Solutions](#phase-e-opportunities--solutions)
- [Phase F: Migration Planning](#phase-f-migration-planning)
- [Phase G: Implementation Governance](#phase-g-implementation-governance)
- [Phase H: Architecture Change Management](#phase-h-architecture-change-management)
- [Requirements Management (center)](#requirements-management-center)
- [Worked example: Preliminary → A → B](#worked-example-preliminary--a--b)

## Reading the cycle

Each phase below lists its **Objective**, **Key steps**, and **Outputs** (deliverables and artifacts). Three documents are the connective tissue across phases:

- **Request for Architecture Work** — the mandate that initiates a cycle (output of Preliminary / input to A).
- **Statement of Architecture Work** — the agreed scope, plan, and resources for the cycle (produced in A, approved by sponsors).
- **Architecture Definition Document (ADD)** + **Architecture Requirements Specification (ARS)** — living deliverables progressively populated across B, C, D. The ADD holds the qualitative/graphical description (Baseline + Target); the ARS holds the quantitative/measurable requirements.

The **Architecture Vision**, **Architecture Roadmap**, and **Implementation and Migration Plan** also evolve across multiple phases.

---

## Preliminary Phase

**Objective.** Prepare the organization to do architecture: establish the Architecture Capability, tailor TOGAF and select frameworks/tools, define architecture principles, and scope the enterprise. "How do we do architecture here?"

**Key steps.** Scope the enterprise organizations affected; confirm governance and support frameworks; define and establish the Architecture Team and organization (the Architecture Board, roles); identify and establish **Architecture Principles**; tailor TOGAF and other selected frameworks; implement architecture tools.

**Outputs.**
- **Organizational Model for Enterprise Architecture** (scope, roles, budget, governance).
- **Tailored Architecture Framework** (method + content tailoring, configured tools).
- **Architecture Principles** (initial set).
- Initial **Architecture Repository** populated with reference material.
- **Request for Architecture Work** (often the trigger handed into Phase A).
- Restatements of business principles, goals, and drivers.

---

## Phase A: Architecture Vision

**Objective.** Set the scope, constraints, and expectations for a specific architecture project; produce the **Architecture Vision**; validate the business context; secure approval to proceed via the **Statement of Architecture Work**.

**Key steps.** Establish the architecture project; identify stakeholders, concerns, and business requirements; confirm and elaborate business goals/drivers/principles; evaluate capabilities; assess readiness for business transformation; define scope; confirm architecture principles; develop the **Architecture Vision**; define the **Target Architecture value propositions and KPIs**; identify business transformation risks and mitigation; develop the Statement of Architecture Work and secure approval.

**Outputs.**
- **Architecture Vision** (the headline deliverable — high-level Baseline and Target, value proposition).
- **Statement of Architecture Work** (approved).
- Refined **Architecture Principles**, **goals**, and **business drivers**.
- **Capability Assessment**, **Communications Plan**.
- Key artifacts: **Stakeholder Map matrix**, **Value Chain diagram**, **Solution Concept diagram**, **Business Model / business scenarios**.

---

## Phase B: Business Architecture

**Objective.** Develop the **Target Business Architecture** describing how the enterprise needs to operate to achieve the business goals and Architecture Vision, and the Baseline; analyze gaps.

**Key steps.** Select reference models, viewpoints, and tools; develop **Baseline Business Architecture**; develop **Target Business Architecture**; perform **gap analysis** (Baseline vs Target); define candidate roadmap components; resolve impacts across the Architecture Landscape; conduct formal stakeholder review; finalize and create the Architecture Definition Document.

**Outputs.**
- **Architecture Definition Document** — Business Architecture sections (Baseline + Target).
- **Architecture Requirements Specification** — business requirements.
- **Architecture Roadmap** — Business Architecture components.
- Catalogs: Organization/Actor, Driver/Goal/Objective, Role, Business Service/Function, Location, Process/Event/Control/Product.
- Matrices: Business Interaction, Actor/Role.
- Diagrams: Business Footprint, Business Service/Information, Functional Decomposition, Product Lifecycle, Goal/Objective/Service, Business Use-Case, Organization Decomposition, Process Flow.

---

## Phase C: Information Systems Architectures

Phase C produces **two** architectures — **Data** and **Application** — which may be developed in either order or concurrently.

**Objective.** Develop the Target Data and Application Architectures, showing how the enterprise's data and applications enable the Business Architecture and Vision; analyze gaps.

**Key steps (each of Data, Application).** Select models/viewpoints/tools; develop Baseline and Target descriptions; perform gap analysis; define roadmap components; resolve landscape impacts; stakeholder review; finalize; update the Architecture Definition Document.

### Phase C — Data Architecture
**Outputs.** ADD/ARS Data sections; Data Architecture roadmap components.
- Catalogs: **Data Entity / Data Component**.
- Matrices: **Data Entity / Business Function**, **Application / Data** (CRUD).
- Diagrams: **Conceptual / Logical Data**, **Data Dissemination**, **Data Lifecycle**, **Data Security**, **Data Migration**.

### Phase C — Application Architecture
**Outputs.** ADD/ARS Application sections; Application Architecture roadmap components.
- Catalogs: **Application Portfolio**, **Interface**.
- Matrices: **Application/Organization**, **Role/Application**, **Application/Function**, **Application Interaction**.
- Diagrams: **Application Communication**, **Application & User Location**, **Application Use-Case**, **Enterprise Manageability**, **Process/Application Realization**, **Software Engineering**, **Application Migration**, **Software Distribution**.

---

## Phase D: Technology Architecture

**Objective.** Develop the **Target Technology Architecture** — the logical and physical technology platforms (infrastructure, middleware, networks, hardware) that host the application and data components from Phase C — and the Baseline; analyze gaps.

**Key steps.** Select reference models (e.g. the **TRM**), viewpoints, and tools; develop Baseline Technology Architecture; develop Target Technology Architecture; gap analysis; define candidate roadmap components; resolve landscape impacts; stakeholder review; finalize; update ADD.

**Outputs.**
- **Architecture Definition Document** — Technology Architecture sections (Baseline + Target).
- **Architecture Requirements Specification** — technology requirements (incl. standards).
- **Architecture Roadmap** — Technology Architecture components.
- Catalogs: **Technology Standards**, **Technology Portfolio**.
- Matrices: **Application / Technology**.
- Diagrams: **Environments & Locations**, **Platform Decomposition**, **Processing**, **Network Computing/Hardware**, **Communications Engineering**.

---

## Phase E: Opportunities & Solutions

**Objective.** Generate the first complete, end-to-end version of the **Architecture Roadmap**; identify delivery vehicles (projects, programs, portfolios); group changes into **Transition Architectures** that deliver continuous business value. This is the bridge from "what" (B–D) to "how/when".

**Key steps.** Determine/confirm key change attributes; determine business constraints; review and consolidate gap analysis from B–D; review IT requirements from a functional perspective; consolidate and reconcile interoperability requirements; refine and validate dependencies; confirm readiness and risk; formulate **Implementation and Migration Strategy**; identify and group major work packages; identify **Transition Architectures**; create the architecture roadmap and Implementation and Migration Plan.

**Outputs.**
- **Architecture Roadmap** (consolidated, version 1.0).
- **Transition Architectures** (as needed).
- **Implementation and Migration Plan** (initial / outline).
- **Capability Assessment** updates, Architecture Definition Document updates.
- Artifact: **Project Context diagram**, **Benefits diagram**.

---

## Phase F: Migration Planning

**Objective.** Finalize a detailed **Implementation and Migration Plan**, coordinated with the enterprise's portfolio/project management, so that the value and cost of the work packages are understood and prioritized.

**Key steps.** Confirm management framework interactions; assign business value to each work package; estimate resource requirements, timings, and availability; prioritize migration projects via cost/benefit and risk; confirm Architecture Roadmap and update the Architecture Definition Document; complete the Implementation and Migration Plan; complete the architecture development cycle and document lessons learned.

**Outputs.**
- **Implementation and Migration Plan** (detailed, finalized).
- Finalized **Architecture Roadmap** and **Transition Architectures**.
- Finalized **Architecture Definition Document**.
- **Implementation Governance Model**.
- Completed architecture (ready to hand to implementation).

---

## Phase G: Implementation Governance

**Objective.** Provide architectural oversight of implementation; ensure that implementation projects conform to the Target Architecture; produce signed **Architecture Contracts**.

**Key steps.** Confirm scope and priorities for deployment with development management; identify deployment resources and skills; guide development of solutions deployment; perform enterprise architecture compliance reviews; implement business and IT operations; perform post-implementation review and close the implementation.

**Outputs.**
- **Architecture Contract** (signed, between architecture function and implementers).
- **Compliance Assessments** (architecture compliance reviews).
- Change Requests for the deployment process.
- The implemented solution, with architecture-compliant building blocks deployed.

---

## Phase H: Architecture Change Management

**Objective.** Ensure the architecture lifecycle is maintained; the governance framework is run; and that the Architecture Capability meets current requirements — deciding whether change is handled by a simplification, an incremental update, or a full ADM re-entry (a new cycle).

**Key steps.** Establish value realization process; deploy monitoring tools; manage risks; provide analysis for architecture change management; develop change requirements to meet performance targets; manage governance process; activate the process to implement change.

**Outputs.**
- **Architecture updates** (for maintenance changes).
- **Changes to architecture framework and principles**.
- **New Request for Architecture Work** (to start a new ADM cycle when major change is needed).
- **Statement of Architecture Work** / Architecture Contract (updated).
- Compliance assessments.

---

## Requirements Management (center)

**Objective.** A **continuous** process (not a sequential phase) that manages architecture requirements throughout the ADM — identifying, storing, and feeding requirements into and out of every phase. The hub of the wheel; every phase both consumes and produces requirements.

**Key steps.** Identify/document requirements; baseline requirements; monitor changes; identify changed requirements and record priorities; assess impact on current and previous phases; implement requirements arising from Phase H; update the requirements repository; implement change in the current phase; assess and revise gap analysis for past phases.

**Outputs.**
- Populated **Architecture Requirements Specification** (changes).
- **Requirements Impact Assessment** (which phases must revisit which requirements).

---

## Worked example: Preliminary → A → B

**Initiative — "Loyalty: a customer rewards program"** for a mid-size grocery retailer that wants to launch a points-and-coupons loyalty scheme spanning stores and a mobile app.

**Preliminary.** The EA team scopes the affected organizations (Marketing, Store Operations, Digital, IT). It stands up an Architecture Board and tailors TOGAF to a lightweight, two-iteration approach. It defines four **Architecture Principles** ("single customer view", "data minimization", "buy-before-build", "API-first"). Deliverables: **Organizational Model for EA**, **Tailored Architecture Framework**, **Architecture Principles**, and a seeded **Architecture Repository**. The CMO issues a **Request for Architecture Work** for the loyalty program.

**Phase A — Architecture Vision.** The architect identifies stakeholders (CMO, Head of Stores, CISO, mobile product owner) and their concerns via a **Stakeholder Map matrix**. A **Solution Concept diagram** sketches the loyalty platform: a customer identity service, a points engine, store-POS integration, and the mobile app. Business goals ("+5% repeat-purchase rate", "build first-party data") become measurable KPIs. Deliverables: the **Architecture Vision** document, an approved **Statement of Architecture Work**, a **Capability Assessment**, and a **Communications Plan**.

**Phase B — Business Architecture.** The team models the Baseline (today: no unified customer record; coupons are paper) and the Target. Catalogs: an **Organization/Actor catalog** and a **Driver/Goal/Objective catalog**. A **Functional Decomposition diagram** breaks out new capabilities — *Enrollment*, *Points Accrual*, *Reward Redemption*, *Consent Management*. A **Business Footprint diagram** ties goals to services to organizations. **Gap analysis** flags the missing *Consent Management* and *Single Customer View* functions. Deliverables: the **Architecture Definition Document** (Business sections, Baseline + Target), business entries in the **Architecture Requirements Specification**, and Business components of the **Architecture Roadmap**.

From here the cycle continues into Phase C (a *Customer* data entity and a *Loyalty* application component) and Phase D (where the points engine is hosted), then E/F sequence the build into transition steps.
