# Composite structure diagram (UML 2.5.1)

What it is · when to use · notation rules (parts, ports, connectors, interfaces, collaborations) · worked example · Mermaid note · common mistakes · EA bridge.

## What it is

A **structure** diagram showing the **internal structure** of a classifier: the **parts** it is composed of at runtime, the **ports** through which it interacts with its environment, and the **connectors** wiring parts and ports together. It answers "what is this thing made of internally and how are the pieces connected?"

## When to use it

- Decomposing a class/component into collaborating runtime parts.
- Specifying the contract surface of a classifier via typed **ports** with provided/required interfaces.
- Capturing a **collaboration** (a reusable pattern of roles) independent of which classes play the roles.

## Notation rules

- The enclosing **classifier** is a large rectangle with its name in the top compartment; its internals are drawn inside.
- A **part** is a rectangle inside, named `rolename : Type [multiplicity]` with a **solid** border (a composite/owned part). A `0..*` part may be drawn as a stacked rectangle. A **referenced** part (not owned, just referenced) has a **dashed** border.
- A **port** is a small square on the boundary of the classifier (or a part), optionally named and typed. Ports relay interactions in/out.
- **Provided interface**: a **lollipop** (ball-on-stick ──○) attached to the port — services the classifier offers.
- **Required interface**: a **socket** (cup-on-stick ──⊂) attached to the port — services it needs from the environment. A provided lollipop fitting a required socket is the **ball-and-socket / assembly** notation.
- A **connector** is a line joining two parts/ports that may communicate at runtime. An **assembly connector** joins a required socket to a compatible provided lollipop; a **delegation connector** forwards a port of the whole to a port of an internal part.
- A **collaboration** is a dashed ellipse containing roles; a **collaboration use** (`:CollaborationName`) binds roles to concrete parts via dashed role-binding lines.

## Worked example — `Car` internal structure

![Composite structure — a class's internal parts and connectors](images/uml-composite-structure.png)

*Rendered in Sparx Enterprise Architect.*

A `Car` classifier composed of parts wired through ports:

```
┌──────────────────────────── Car ─────────────────────────────┐
│                                                               │
│   ┌──────────────┐   drives   ┌──────────────┐               │
│   │ e : Engine   │○──────────⊂│ t : Transmission │           │
│   └──────┬───────┘            └──────┬───────┘               │
│          │ powers                    │                        │
│          ▼                           ▼                        │
│   ┌──────────────┐            ┌──────────────┐               │
│   │ fl : Wheel   │            │ fr : Wheel   │  (parts [4])   │
│   └──────────────┘            └──────────────┘               │
│                                                               │
│  ▢ fuelPort  ──○ IFuelSupply        ▢ diagPort ──⊂ IOBD2     │
└───────────────────────────────────────────────────────────────┘
```

- `Engine` **provides** `IFuelSupply` via a lollipop; `Transmission` **requires** drive via a socket; the assembly connector wires them.
- `fuelPort` is a boundary **port**; a **delegation connector** forwards it to the engine's internal fuel port.
- `fl/fr : Wheel [4]` are owned parts with multiplicity.

## Mermaid

**No native equivalent.** Mermaid cannot render ports, lollipop/socket interfaces, or internal-part containment. If a text sketch is required, fall back to an ASCII box drawing like the one above and state that Mermaid has no composite-structure support.

## Common mistakes

- Confusing a **part** (a runtime role inside this classifier, solid border) with an ordinary associated class on a class diagram.
- Reversing **provided** (lollipop ──○) and **required** (socket ──⊂) interfaces.
- Using an **assembly connector** where a **delegation connector** is needed: assembly joins two parts' ports; delegation joins a boundary port of the whole to an internal part's port.
- Drawing ports as named attributes — ports are boundary squares, not attribute lines.

## EA bridge

- Diagram `type`: EA **"Composite Structure"** diagram (confirmed).
- Element `type`: **"Part"** (confirmed — set `owningElementID` to the structured `Class` so the part nests inside it), **"Class"** (the enclosing classifier, confirmed); **"Port"** (confirmed — owned by the enclosing class, so pass `owningElementID`, not a package); **"Collaboration"** — verify in live EA. Ports/parts are usually added as properties of the owning element.
- Connector `type`: **"Connector"** (confirmed — assembly/delegation line between parts; set role), interface realization shown as provided/required interface on the port. Build sequence: **`ea-modeling`** skill + `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.
