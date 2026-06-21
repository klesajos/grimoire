# BPMN 2.0.2 — Pools, Lanes & Collaboration

Table of contents:
1. Swimlanes overview
2. Pool (participant)
3. Lane
4. Black-box pools & message flow
5. Collaboration diagrams
6. Choreography (brief note)
7. Worked example: leave request across two pools
8. Common swimlane mistakes
9. Enterprise Architect bridge (BPMN 2.0 MDG)

---

## 1. Swimlanes overview

**Swimlanes** organize a model by *who* does the work. BPMN has two:

- **Pool** — a **participant** in a collaboration (an organization, a system, a
  role acting as a black box). Each pool contains **one process** (or is empty /
  black-box).
- **Lane** — a **sub-division of a pool** (a role, department, or system within
  that participant).

Orientation can be horizontal (lanes stacked vertically) or vertical; horizontal
is most common.

## 2. Pool (participant)

A **Pool** is the container for a single participant's process. Notation: a large
**rectangle with a labelled header band** (the participant's name) on the left
(horizontal) or top (vertical) edge.

Rules:
- A pool holds **at most one process**. Two interacting parties = **two pools**.
- **Sequence flow stays inside a pool**; it must **not** cross the pool boundary.
- Interaction *between* pools is **message flow only** (dashed line) — see
  `flows-and-data.md`.
- A pool may be **expanded** (its process drawn inside) or **collapsed /
  black-box** (empty — only its message interface is shown).

## 3. Lane

A **Lane** partitions a pool into rows/columns, typically by **role or system**.
Notation: sub-bands within the pool, each labelled.

Rules:
- Lanes are **organizational only** — they have **no token semantics**. A token
  crosses lane boundaries freely along sequence flow (lanes are *not* pools).
- Use lanes to show *responsibility* ("Sales", "Warehouse", "Finance") within one
  participant.
- Sequence flow **may** cross lanes (same pool); it may **not** cross pools.

Lane vs. Pool decision: same legal/organizational entity, different roles ⇒
**lanes** in one pool. Separate parties that exchange messages ⇒ **separate
pools**.

## 4. Black-box pools & message flow

A **black-box pool** is a collapsed pool whose internals are hidden — you model
*your* process in detail and the counterpart (customer, external system) as an
empty pool you only exchange **messages** with.

- A black-box pool exposes **only message flow**; no sequence flow enters or
  leaves it, and no internal elements are shown.
- Message flow connects to the pool edge, or to specific message events /
  send-receive tasks if the pool is expanded.

## 5. Collaboration diagrams

A **collaboration** shows **two or more pools** and the **message flows** between
them. This is the standard way to model an interaction (e.g. Customer ↔ Seller,
or Process ↔ external Service).

Build pattern:
1. One pool per participant; detail the process(es) you control, black-box the
   rest.
2. Wire intra-pool control with **sequence flow**; wire inter-pool exchanges with
   **message flow**.
3. Use **message events / send & receive tasks** as the touch-points where
   messages are thrown/caught (`events.md`, `activities.md`).

## 6. Choreography (brief note)

A **choreography diagram** models the **ordered message exchanges between
participants** with no single controlling process — each choreography *activity*
is a message interaction band naming the two participants. It is a distinct,
niche diagram type with limited tool support; most work uses **process** and
**collaboration** diagrams. Mentioned here for completeness only.

## 7. Worked example: leave request across two pools

Splitting the leave-request process (`overview-and-rules.md`) into a
collaboration:

- **Pool "Employee / Manager"** (expanded): start → User Task "Submit request" →
  *(message flow out)* → … → XOR "Approved?" → end events, as before.
- **Pool "HR System"** (expanded or black-box): receives the request, records it,
  and **sends** an approval/rejection message back.
- **Message flows** (dashed) cross between the pools: "Leave request" out from a
  **Send task** in the Employee pool to a **Receive task / message start** in the
  HR pool; "Decision" back from HR to a **catching message event** in the Employee
  pool. The XOR "Approved?" branches on the *content* of that received decision.

Note: nothing connects the two pools except message flow; each pool's token flow
is independent. A message does **not** carry a token across — the receiving side
reacts with its own catching event (`overview-and-rules.md` §5).

The diagram below is a Mermaid **approximation** of a collaboration: Mermaid has
no BPMN pools or message flow, so `subgraph`s stand in for pools and a dashed
arrow for the message flow — Enterprise Architect renders true BPMN pools, lanes,
and message-flow connectors.

![BPMN collaboration — two pools with a message flow (Mermaid approximation)](images/bpmn-collaboration-approx.png)

<details>
<summary>Mermaid source</summary>

<!-- render: images/bpmn-collaboration-approx.png -->

```mermaid
flowchart LR
  subgraph Customer
    C1[Submit request] --> C2[Receive decision]
  end
  subgraph Supplier
    S1[Record request] --> S2[Send decision]
  end
  C1 -.->|message| S1
  S2 -.->|message| C2
```

</details>

## 8. Common swimlane mistakes

- **Sequence flow crossing pools** — the cardinal error; use message flow.
- **Two parties in one pool with lanes** when they actually exchange *messages* —
  if they message each other, they are **separate pools**, not lanes.
- **Message flow between lanes of the same pool** — within a pool it's sequence
  flow; message flow is inter-pool.
- **Detailing a black-box pool** — if you don't control/model it, keep it
  collapsed and interact only by message.
- **Expecting lanes to synchronize tokens** — lanes have no semantics; only
  gateways/events do.

## 9. Enterprise Architect bridge (BPMN 2.0 MDG)

EA models BPMN through its **BPMN 2.0 MDG technology**. The element/connector
**stereotypes differ from plain UML** types — they are BPMN-profile stereotypes
(e.g. `«BPMN2.0::Activity»`, `«BPMN2.0::Event»`, pools as `«BPMN2.0::Pool»`,
sequence/message flow stereotypes).

> **Confirmed limitation: BPMN is NOT creatable via the
> `enterprise-architect:create_or_update_elements` MCP tool.** A type string
> like `"BPMN2.0::Activity"` errors, and the `stereotype` field strips the BPMN
> profile, so the created element is a plain UML element, not a real BPMN one.
> Treat the mapping below as reference for what the MDG concepts are called —
> **not** as a build recipe to attempt through the MCP. To author real BPMN,
> use EA's own BPMN toolbox/UI. The Mermaid approximations in these reference
> files exist precisely because of this limitation.
>
> The EA **COM** API doesn't help either (confirmed against live EA with the
> BPMN2.0 MDG v1.0.7 installed): a BPMN *diagram* type IS settable —
> `Diagrams.AddNew(name, "BPMN2.0::BusinessProcess")` sets its `MetaType` — but
> BPMN *element* stereotypes **revert**: setting `Stereotype` / `StereotypeEx` to
> `"BPMN2.0::Activity"` (or passing the FQN to `Elements.AddNew`) falls back to a
> plain `Activity`. So the GUI toolbox stays the only path to real BPMN elements.

**MDG concept reference (informational — not MCP-creatable, see above):**

| BPMN concept | EA MDG element/connector |
|--------------|--------------------------|
| Task / Sub-Process | `«BPMN2.0::Activity»` element; `activityType` tagged value selects Task vs. SubProcess, and `taskType` selects User/Service/Send/etc. |
| Event (start/intermediate/end) | `«BPMN2.0::Event»` element; tagged values set position (`eventType`) and trigger (`trigger`) |
| Gateway | `«BPMN2.0::Gateway»` element; `gatewayType` tagged value = Exclusive/Parallel/Inclusive/EventBased/Complex |
| Pool / Lane | `«BPMN2.0::Pool»` / `«BPMN2.0::Lane»` (often a specialized swimlane element/diagram artifact) |
| Sequence Flow | `«BPMN2.0::SequenceFlow»` connector |
| Message Flow | `«BPMN2.0::MessageFlow»` connector |
| Association / Data Association | `«BPMN2.0::Association»` connector |
| Data Object / Data Store | `«BPMN2.0::DataObject»` / `«BPMN2.0::DataStore»` element |

The trigger/marker selections in real EA BPMN are driven by **tagged values**,
not by distinct element types — but again, you cannot set these by creating BPMN
elements through the MCP create tool (see the limitation above).

**EA gotchas (these apply to plain-UML modeling via the MCP, where the build
flow lives in the `ea-modeling` skill):**
- `taggedValues` is an **ARRAY** of `{name, value}` objects.
- Connector `direction:"Source -> Destination"` **FAILS** — use
  `direction:"Unspecified"`. (Flow direction is the line's own source→target, not
  this field.)
- `place_elements_on_diagram` needs **x/y > 10** (values ≤ 10 are rejected/ignored).
- Open the diagram (`enterprise-architect:open_diagrams`) before adding ordered
  artifacts, per `ea-modeling`.

See also `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

Bottom line: to convey BPMN through this plugin's MCP path, use the **Mermaid
approximations** above; to author genuine BPMN, build it in EA's BPMN toolbox by
hand.
