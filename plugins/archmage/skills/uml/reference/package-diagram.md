# Package diagram (UML 2.5.1)

What it is · when to use · notation rules · dependencies · worked example · Mermaid note · common mistakes · EA bridge.

## What it is

A **structure** diagram that groups model elements into **packages** (namespaces) and shows the **dependencies** between those groups. It is the standard tool for organizing a large model and for reasoning about coupling between subsystems/layers.

## When to use it

- Showing the high-level architecture as layers/modules and which modules depend on which.
- Organizing a large class model so the package-level dependency graph stays acyclic.
- Documenting `«import»`/`«access»`/`«merge»` relationships between namespaces.

## Notation rules

- A **package** is a tabbed folder: a small tab on top of a larger rectangle. The name placement has three forms: **(a)** name in the tab when members are drawn inside the body; **(b)** name in the body (large rectangle) when members are not shown; **(c)** name in the tab with members shown *outside* the body, attached by the nesting lines below.
- **Nesting** is shown either by drawing one package inside another, or by a line from the container to contained packages with a circle-plus ⊕ ("containment") symbol on the container end.
- A model element is owned **directly by at most one** package; that owning package defines its **namespace**. An element's name need only be unique within its own namespace, so the same simple name may recur in different packages (e.g. `P1::C` and `P2::C` are distinct).
- Fully-qualified names use `::` — e.g. `Web::Controllers::LoginController`.
- A **package dependency** is a dashed arrow from the dependent (client) package to the one it depends on (supplier).

### Dependency stereotypes

| Stereotype | Meaning |
| --- | --- |
| `«import»` | public import: names from the target become usable **and re-exported** as if owned. |
| `«access»` | private import: names usable inside the importing package but **not** re-exported. |
| `«merge»` | package merge: target's contents are conceptually combined into the source (used in metamodels/profiles). |
| `«use»` | generic dependency (default when unlabeled). |

Only members that are **publicly visible** in the target can be imported or accessed. After an `«import»`/`«access»`, the imported element's name is added to the importer's namespace and can be referenced **without qualification** (`Account` rather than `Domain::Account`) — provided no name clash; a clash forces continued use of the qualified name.

## Worked example — layered web app

```
        ┌──────────────┐
        │ ▭ Web        │
        └──────┬───────┘
               ┊ «access»
               ▼
        ┌──────────────┐        ┌──────────────┐
        │ ▭ Services   │┄┄┄┄┄┄┄▶│ ▭ Domain     │
        └──────┬───────┘ «import»└──────────────┘
               ┊ «access»               ▲
               ▼                        ┊ «access»
        ┌──────────────┐                ┊
        │ ▭ Persistence│┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┘
        └──────────────┘
```

`Web` depends on `Services`; `Services` imports `Domain` (re-exporting its types); both `Services` and `Persistence` access `Domain`. The graph is acyclic — a healthy layering. (Dashed arrows ┄▶ are dependencies; ┊ are vertical dashed arrows.)

## Mermaid

**No native equivalent.** Mermaid has no package diagram. Approximate with a `flowchart` using `subgraph` blocks as packages and dashed arrows (`-.->`) for dependencies, but note it is not true UML package notation (no tabbed-folder glyph, no `«import»`/`«access»` semantics).

The same layered web app as above, rendered as a Mermaid flowchart with `subgraph` packages and labelled dashed dependencies:

![Package diagram (Mermaid approximation) — packages with «import»/«access» dependencies](images/uml-package-dependencies.png)

<details>
<summary>Mermaid source</summary>

<!-- render: images/uml-package-dependencies.png -->

```mermaid
flowchart TD
    subgraph Web["Web"]
        WebC["Controllers"]
    end
    subgraph Services["Services"]
        Svc["OrderService"]
    end
    subgraph Domain["Domain"]
        DomT["Order, Customer"]
    end
    subgraph Persistence["Persistence"]
        Repo["Repositories"]
    end
    Web -. "«access»" .-> Services
    Services -. "«import»" .-> Domain
    Services -. "«access»" .-> Persistence
    Persistence -. "«access»" .-> Domain
```

</details>

## Common mistakes

- Pointing the dependency arrow **the wrong way** — it goes from client to supplier (the package that needs the other).
- Treating `«import»` and `«access»` as interchangeable — `«import»` re-exports the names; `«access»` does not.
- Letting the package dependency graph contain **cycles** — usually a design smell; break it with an interface package.
- Confusing **nesting** (ownership/namespace containment) with **dependency** (a usage relationship).

## EA bridge

- Diagram `type`: EA uses a **"Package"** diagram (mark **verify in live EA**).
- Element: packages are created with `enterprise-architect:create_or_update_package` (not `…_elements`); a package can also appear **on** a diagram as a Package element. Verify the on-diagram package element in live EA.
- Connector `type`: **"Dependency"**, with `stereotypes:"import"` / `"access"` / `"merge"` for the labeled variants; **"Package"** / "PackageImport" connector — **verify in live EA**. Build sequence: see **`ea-modeling`** and `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.
