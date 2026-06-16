# Use case diagram (UML 2.5.1)

What it is · when to use · notation rules · relationships · worked example · Mermaid note · common mistakes · EA bridge.

## What it is

A **behavior** diagram that captures the **functional scope** of a system: the **actors** (roles outside the system), the **use cases** (units of useful functionality the system provides), and the **system boundary**. It is a requirements/scoping tool, not a process flow — the *steps* of a use case live in its textual specification or an activity diagram.

## When to use it

- Early scoping: what the system does and who needs it.
- Communicating with non-technical stakeholders about goals.
- Indexing detailed requirements (each use case → a specification).

## Notation rules

- An **actor** is a stick figure (or a `«actor»` rectangle) outside the boundary — a **role**, not a person (one person can play many actors; one actor can be many people). Non-human actors (other systems, a clock) are valid.
- A **use case** is an ellipse with a verb-phrase name (e.g. *Place Order*), drawn **inside** the system boundary.
- The **system boundary** is a rectangle enclosing the use cases, labeled with the system name. Actors sit outside it.
- An **association** (plain solid line, no arrowhead) connects an actor to each use case it participates in. This is the *only* actor↔use-case relationship.

### Relationships between use cases

| Relationship | Notation | Meaning |
| --- | --- | --- |
| `«include»` | dashed arrow from **base** → included use case | base **always** runs the included use case (mandatory, factored-out common behavior). |
| `«extend»` | dashed arrow from **extending** → **base** | extending use case **conditionally** adds behavior at an extension point in the base. |
| **Generalization** | solid hollow-triangle arrow → parent | a specialized use case (or actor) inherits and may override the parent. |

Direction is the classic trap: **`«include»`** points *from base to the part it includes*; **`«extend»`** points *from the optional extension back to the base*. The base names an **extension point** (a labeled location) that the `«extend»` may reference with a condition `{condition}`.

## Worked example — library system

![Use case diagram — a library system with «include» and «extend»](images/uml-use-case-library.png)

*Rendered in Sparx Enterprise Architect.*

- **Actors**: `Member`, `Librarian`.
- **Use cases** for the `Library` system: *Search Catalogue*, *Borrow Book*, *Check Membership*, *Return Book*, *Pay Fine*.
- *Borrow Book* `«include»` *Check Membership* (borrowing always verifies membership).
- *Pay Fine* `«extend»` *Return Book* (an overdue return *conditionally* adds the fine; the extending use case points back at the base).
- `Member` ── *Search Catalogue*, *Borrow Book*, *Return Book*; `Librarian` ── *Borrow Book*, *Return Book*.

```
            ┌──────────────────── Library ────────────────────┐
            │   (Search Catalogue)                            │
 Member ────┼── (Borrow Book) ┄┄«include»┄┄▶ (Check Membership)┼
   │        │                                                 │
 Librarian ─┼── (Return Book) ◀┄┄«extend»┄┄  (Pay Fine)        │
            └─────────────────────────────────────────────────┘
```

## Mermaid

**No native equivalent.** Mermaid has no use-case diagram (no actor/ellipse/boundary notation, no `«include»`/`«extend»`). If a sketch is required, approximate with a `flowchart` (stadium shapes `([Use Case])` for cases, plain nodes for actors, dashed links labeled `include`/`extend`) and state explicitly it is not UML use-case notation.

## Common mistakes

- **Reversing `«include»`/`«extend»` arrows** — include goes base→included; extend goes extension→base. This is the #1 error.
- Modeling **process steps** as use cases ("Enter Username", "Click Submit") — those are steps inside one use case, not separate use cases. A use case is a goal that delivers observable value.
- Drawing arrowheads on the **actor association** — actor-to-use-case links are plain solid lines.
- Treating an actor as a specific person rather than a **role**; or omitting external systems that are legitimate actors.
- Over-using `«include»`/`«extend»`/generalization to "factor" everything — keep the diagram about scope, not decomposition.

## EA bridge

- Diagram `type`: **"Use Case"** (confirmed).
- Element `type`: **"UseCase"**, **"Actor"**, and a **"Boundary"** element for the system boundary (verify boundary in live EA).
- Connector `type`: **"Association"** (actor↔use case), **"Generalization"**, **"Dependency"** with `stereotypes:"include"` or `stereotypes:"extend"` for the two factored relationships. Build sequence: **`ea-modeling`** + `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.
