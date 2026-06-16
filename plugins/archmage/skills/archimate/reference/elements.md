# ArchiMate 3.2 — element catalog

The complete catalog of ArchiMate 3.2 elements, organized by layer/aspect, each with a concise definition and notation hint. Source: *ArchiMate 3.2 Specification*, The Open Group C226 (2022). For where each sits on the layers×aspects grid, see `framework-and-layers.md`.

## Contents

- [Conventions](#conventions)
- [Strategy layer](#strategy-layer)
- [Business layer](#business-layer)
- [Application layer](#application-layer)
- [Technology layer](#technology-layer)
- [Physical elements](#physical-elements)
- [Motivation aspect](#motivation-aspect)
- [Implementation & Migration](#implementation--migration)
- [Composite elements](#composite-elements)
- [What changed in ArchiMate 3.2](#what-changed-in-archimate-32)

## Conventions

![Example elements across layers — business role/process/service, application component/service, technology node](images/archimate-layered-view.png)

*Rendered in Sparx Enterprise Architect.*

Each layer follows the generic pattern: **active structure** (the doer), **internal behavior** (what it does), **external behavior = Service** (what it offers), **interface** (the access point for the service), and **passive structure** (what behavior acts on). A **Collaboration** is an active-structure element formed by two or more cooperating active-structure elements; an **Interaction** is the collective behavior of a collaboration.

## Strategy layer

| Element | Aspect | Definition |
|---------|--------|------------|
| **Resource** | Active structure | An asset owned or controlled by an individual or organization (financial, physical, intellectual, human). |
| **Capability** | Behavior | An ability that an active structure element (organization, person, system) possesses. |
| **Course of Action** | Behavior | An approach or plan for configuring capabilities and resources to achieve a goal (a strategy or tactic). |
| **Value Stream** | Behavior | A sequence of (value-adding) activities that create an overall result for a customer, stakeholder, or end user. |

(Strategy has no passive-structure or interface element of its own.)

## Business layer

| Element | Aspect | Definition |
|---------|--------|------------|
| **Business Actor** | Active structure | A business entity capable of performing behavior (a person, organizational unit, or organization). |
| **Business Role** | Active structure | Responsibility for performing specific behavior, to which an actor can be assigned. |
| **Business Collaboration** | Active structure | An aggregate of two or more business roles/actors that cooperate to perform collective behavior. |
| **Business Interface** | Active structure | A point of access where a business service is made available to the environment. |
| **Business Process** | Behavior | A sequence of business behaviors that achieves a specific result (a defined set of products/services). |
| **Business Function** | Behavior | A collection of business behavior grouped by required skills, resources, or competencies (capability-aligned, not flow-aligned). |
| **Business Interaction** | Behavior | Collective business behavior performed by (the roles in) a business collaboration. |
| **Business Event** | Behavior | A business-related state change (something that happens and triggers/affects behavior). |
| **Business Service** | Behavior (external) | Explicitly defined behavior that a business role/actor/collaboration exposes to its environment. |
| **Business Object** | Passive structure | A concept used within a particular business domain (information/knowledge object). |
| **Contract** | Passive structure | A formal or informal specification of an agreement (a specialization of Business Object) governing a product/service. |
| **Representation** | Passive structure | A perceptible form of information carried by a business object (document, screen, message). |
| **Product** | Passive structure | A coherent collection of services and/or passive structure elements, with a contract, offered as a whole to customers. |

## Application layer

| Element | Aspect | Definition |
|---------|--------|------------|
| **Application Component** | Active structure | An encapsulated unit of application functionality with well-defined interfaces (a deployable, replaceable software part). |
| **Application Collaboration** | Active structure | An aggregate of two or more application components/internal active structure elements that cooperate. |
| **Application Interface** | Active structure | A point of access where application services are made available (an API, UI endpoint). |
| **Application Function** | Behavior | Automated behavior performed by an application component. |
| **Application Interaction** | Behavior | Collective application behavior performed by (the components in) an application collaboration. |
| **Application Process** | Behavior | A sequence of application behaviors that achieves a specific result. |
| **Application Event** | Behavior | An application-related state change. |
| **Application Service** | Behavior (external) | Explicitly defined exposed application behavior. |
| **Data Object** | Passive structure | Data structured for automated processing (the application-layer counterpart of a Business Object). |

## Technology layer

| Element | Aspect | Definition |
|---------|--------|------------|
| **Node** | Active structure | A computational or physical resource that hosts, manipulates, or interacts with other such resources. |
| **Device** | Active structure | A physical IT resource on which artifacts may be stored/deployed and executed (a specialized node). |
| **System Software** | Active structure | Software providing an environment for storing, executing, and using software or data (OS, DBMS, middleware, container runtime). |
| **Technology Collaboration** | Active structure | An aggregate of two or more nodes/internal active structure elements that cooperate. |
| **Technology Interface** | Active structure | A point of access where technology services are made available. |
| **Path** | Active structure | A link between two or more nodes through which they exchange data, energy, or material (logical connection). |
| **Communication Network** | Active structure | A set of structures connecting nodes for transmission (the physical/logical realization of paths). |
| **Technology Function** | Behavior | Automated behavior performed by a node. |
| **Technology Process** | Behavior | A sequence of technology behaviors achieving a specific result. |
| **Technology Interaction** | Behavior | Collective technology behavior performed by (the nodes in) a technology collaboration. |
| **Technology Event** | Behavior | A technology-related state change. |
| **Technology Service** | Behavior (external) | Explicitly defined exposed technology behavior. |
| **Artifact** | Passive structure | A piece of data used or produced in software development/deployment/operation (a file, binary, table, deployable). Realizes/deploys application & data objects. |

## Physical elements

The Physical part is an extension of the Technology layer for the physical world; it reuses Technology's behavior elements (technology function/process/etc.) and adds:

| Element | Aspect | Definition |
|---------|--------|------------|
| **Equipment** | Active structure | One or more physical machines, tools, or instruments that create, use, store, move, or transform materials. |
| **Facility** | Active structure | A physical structure or environment (factory, building, warehouse, plant). |
| **Distribution Network** | Active structure | A physical network used to transport materials or energy (the physical counterpart of a communication network). |
| **Material** | Passive structure | Tangible physical matter or energy; the medium for or product of physical processes (raw materials, products, fuel). |

## Motivation aspect

| Element | Definition |
|---------|------------|
| **Stakeholder** | The role of an individual, team, or organization (or class thereof) that has interests in the architecture's outcome. |
| **Driver** | An external or internal condition that motivates an organization to define its goals and enact changes (e.g., regulation, cost, customer satisfaction). |
| **Assessment** | The result of analyzing the state of affairs with respect to a driver (a SWOT-style finding — strength, weakness, opportunity, threat). |
| **Goal** | A high-level statement of intent, direction, or desired end state. |
| **Outcome** | An end result, effect, or consequence of a certain state of affairs (a measurable result, e.g. "increased customer satisfaction"). |
| **Principle** | A general, normative property or guideline that applies in a given context (a qualitative statement of intent). |
| **Requirement** | A statement of need defining a property that applies to a specific system as realized by the architecture. |
| **Constraint** | A factor that limits or restricts the realization of goals / the architecture decisions (a restrictive requirement). |
| **Meaning** | The knowledge or expertise present in, or the interpretation of, a representation (what something "means" to a stakeholder). |
| **Value** | The relative worth, utility, or importance of a concept (what a stakeholder gains). |

## Implementation & Migration

| Element | Definition |
|---------|------------|
| **Work Package** | A series of actions/activities identified and managed as a unit (a project, program, or task) producing deliverables. |
| **Deliverable** | A precisely defined result produced by a work package. |
| **Implementation Event** | A behavioral element denoting a state change related to implementation or migration. |
| **Plateau** | A relatively stable state of the architecture over a limited period (e.g. baseline, transition, target architecture). |
| **Gap** | A statement of difference between two plateaus (the outcome of a gap analysis; what must change). |

## Composite elements

Composite elements can aggregate/compose elements from **multiple** layers:

| Element | Definition |
|---------|------------|
| **Grouping** | Aggregates or composes an arbitrary set of concepts that belong together by some common characteristic (an overlay, not an ownership). |
| **Location** | A conceptual or physical place or position where concepts are located (e.g. where actors/equipment/nodes reside). |

## What changed in ArchiMate 3.2

ArchiMate 3.2 (2022) is a **minor** revision of 3.1; the element list is essentially unchanged. Key refinements to be aware of:

- **Technology metamodel cleanup**: Device, System Software, Facility, and Equipment are **no longer formally subtypes of Node** — they are technology/physical *internal active structure* elements in their own right. This enables new **composition and aggregation** relationships *involving Node* (a Node can now be composed of Devices, etc.).
- New permitted relationships: **Composition/Aggregation from Plateau to Outcome**; **Realization from Material to Equipment**; clarified **derivation rules for Grouping**.
- Sharpened definitions for **Outcome**, **Constraint**, **Business Function**, and **Product**.

When precision matters, confirm against the spec's element tables (C226, Chapters 6–13 and Appendix A).
