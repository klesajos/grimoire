# BPMN 2.0.2 — Connecting Objects, Data & Artifacts

Table of contents:
1. Sequence Flow
2. Conditional & default sequence flow
3. Message Flow
4. Association
5. Data Object (incl. state & collection)
6. Data Store
7. Data Input / Data Output
8. Data Association
9. Artifacts: Group & Text Annotation
10. Worked example: data in order-to-cash
11. Common flow/data mistakes

---

## 1. Sequence Flow

A **Sequence Flow** is the ordered control-flow connector **within a single
pool**. Notation: a **solid line with a solid (filled) arrowhead**.

Rules:
- Connects **Flow Objects** only — Events, Activities, Gateways (and choreography
  activities).
- **Exactly one source and one target.** No forking on the line itself (use a
  gateway or an uncontrolled multi-flow split).
- **Stays inside one pool / process.** It must **never cross a pool boundary** —
  that's a message flow.
- Carries the **token** (see `overview-and-rules.md` §5).
- A start event has no *incoming* sequence flow; an end event has no *outgoing*.

## 2. Conditional & default sequence flow

- **Conditional sequence flow:** a sequence flow with a boolean **condition
  expression**, evaluated when the token would traverse it. When it leaves a
  **gateway** (XOR/Inclusive) the condition is plain. When a conditional flow
  leaves an **activity directly** (no gateway), it is drawn with a small
  **mini-diamond** at its source to signal the embedded decision.
- **Default sequence flow:** marked with a short **back-slash tick** near its
  source. Selected **only if no other outgoing condition is true**; its own
  condition (if present) is ignored. Used on XOR and Inclusive splits (and on
  activities with conditional outgoing flows). See `gateways.md` §8.

## 3. Message Flow

A **Message Flow** shows a **message exchanged between two participants
(pools)**. Notation: a **dashed line** with an **open (unfilled) circle at the
source** and an **open arrowhead at the target**; an optional **message envelope**
icon may sit on the line.

Rules:
- Connects elements in **different pools** (pool↔pool, or to a specific node such
  as a message event, send/receive task, or pool edge). **Never within one pool.**
- **Does not carry a token** — sending a message does not move control to the
  other pool; the receiving pool reacts via its own **catching message event** or
  **receive task** (see `events.md`, `activities.md`).
- A **black-box pool** exposes *only* message flow (no internal sequence flow is
  visible). See `pools-lanes-collaboration.md`.

## 4. Association

An **Association** links **Artifacts** or **text/data** to flow objects **without
implying sequence**. Notation: a **dotted line**; an **open arrowhead** when
direction is meaningful (e.g. data direction), none when it is a plain link
(e.g. a text annotation).

Use it to attach a **Text Annotation** to an element, link a **Group** visually,
or — in its specialized **Data Association** form (§8) — connect data to
activities/events.

## 5. Data Object (incl. state & collection)

A **Data Object** represents information that flows through the process —
documents, records, payloads. Notation: a **rectangle with a folded top-right
corner** (a "page").

- It is **not** a flow object: it sits beside the flow and connects via **data
  association**, never sequence flow. Data objects have **no token** and don't
  drive control on their own (a *gateway* may test a condition derived from data).
- **State:** a data object can show a **[state]** label in brackets (e.g.
  `Order [confirmed]`) to indicate its lifecycle stage at that point.
- **Collection:** a **multi-instance / collection** data object adds the **three
  vertical bars** marker, meaning "a set of these" (pairs naturally with a
  multi-instance activity).
- A **Data Object Reference** lets the same logical data object appear in several
  places (different states) without duplication.

## 6. Data Store

A **Data Store** is **persistent** data that outlives the process instance — a
database, file system, repository. Notation: a **cylinder** (the classic database
drum). Connected via **data association**.

Difference from Data Object: a Data Object is **transient** (lives within the
process instance / scope); a Data Store is **persistent and shared** across
instances.

## 7. Data Input / Data Output

- **Data Input:** the data required *by* a process or activity from outside —
  drawn as a data-object shape with a **hollow (unfilled) arrow** marker.
- **Data Output:** the data produced *by* a process/activity — data-object shape
  with a **filled arrow** marker.

These appear especially on the boundary of a (sub-)process to declare its data
interface (its **InputOutputSpecification**), and on activities to declare what
they read and write.

## 8. Data Association

A **Data Association** is the directed **dotted line with an open arrowhead** that
moves data **to** an activity/event (input) or **from** it (output), or between
data elements. It is the *only* correct connector for data — **not** sequence
flow and not message flow.

- Direction matters: arrow **into** an activity = the activity reads it; arrow
  **out** = the activity writes it.
- Data associations carry **no token** and impose **no ordering** on control flow;
  they document information dependency.

## 9. Artifacts: Group & Text Annotation

Artifacts add documentation/visual grouping **without affecting flow**.

- **Group:** a **rounded rectangle with a dashed border**. Purely visual — bundles
  elements that belong together (e.g. spanning lanes/pools) for readability. It
  has **no execution semantics** and does **not** constrain flow; it can cross
  pool/lane boundaries.
- **Text Annotation:** an **open bracket "[" shape** holding free text, attached to
  any element with an (undirected) **association**. Pure commentary.

Both are optional and ignorable by an execution engine.

## 10. Worked example: data in order-to-cash

Adding data to the order-to-cash process:

- A **Data Object** `Order [received]` is produced by "Receive order" (data
  association **out**), then read by "Check credit" (data association **in**); its
  state advances to `Order [approved]` after the credit decision (a second data
  object reference with the new state).
- A **Data Store** `Customer DB` (cylinder) is read by "Check credit" via data
  association to look up the credit limit — persistent, shared across all order
  instances.
- A **collection Data Object** `Order Lines [*]` (three-bar marker) feeds the
  multi-instance "Pick line item" task (see `activities.md`).
- A **Text Annotation** "[ SLA: credit check < 2 min ]" is associated with the
  "Check credit" task as a note.

Note: none of these data connections are sequence flow — they are **data
associations** (dotted, open arrowhead) and carry no token. Control still flows
solely along the solid sequence-flow lines.

## 11. Common flow/data mistakes

- **Sequence flow crossing a pool** — use **message flow** between pools.
- **Message flow within one pool** — inter-pool only; intra-pool is sequence flow.
- **Connecting data with sequence flow** — data uses **data association** (dotted,
  open arrowhead); it is not a control-flow step.
- **Treating a Data Object like a token source** — data is passive; control flows
  on sequence flow, decisions are made by gateways/conditions.
- **Data Object vs. Data Store** — transient (per-instance) vs. persistent
  (shared). Don't draw a database as a folded-corner page.
- **Forgetting state labels** — `Order [received]` vs. `Order [approved]` makes the
  model far clearer; use bracketed states.
- **Group treated as a sub-process** — a Group is decoration only; it has no
  start/end and no token scope (that's a sub-process, `activities.md`).
- **Forking a sequence flow line** — one source, one target; branch with a
  gateway.
