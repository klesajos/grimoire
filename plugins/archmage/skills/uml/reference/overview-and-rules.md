# UML 2.5.1 — Overview and cross-cutting rules

Contents:
1. Version note
2. The taxonomy: structure vs behavior
3. The 14 diagram types (table)
4. Picking a diagram type
5. Cross-cutting notation
   - Visibility
   - Multiplicity
   - Name strings, roles, qualifiers
   - Stereotypes & profiles
   - Notes, comments, and `{constraints}`
   - Packages & namespaces
   - Keywords vs stereotypes

---

## 1. Version note

This skill targets **UML 2.5.1**, OMG document **formal/17-12-05** (December 2017). 2.5.1 is an editorial revision of 2.5 (formal/15-03-01) that reorganized the spec into one document and dropped the old "Infrastructure/Superstructure" split. The diagram set and notation are stable across 2.5 / 2.5.1. UML defines **no required diagram types** — diagrams are views onto a single underlying model; the 14 named types are the canonical, non-normative taxonomy from Annex A.

## 2. The taxonomy: structure vs behavior

The 14 diagrams split into two families:

- **Structure diagrams (7)** show the static things in a system and their relationships: **Class, Object, Package, Composite Structure, Component, Deployment, Profile.**
- **Behavior diagrams (7)** show dynamics over time: **Use Case, Activity, State Machine**, plus the four **Interaction** diagrams (a sub-family of Behavior): **Sequence, Communication, Timing, Interaction Overview.**

```
UML 2.5.1 diagrams
├── Structure (7)
│   ├── Class
│   ├── Object
│   ├── Package
│   ├── Composite Structure
│   ├── Component
│   ├── Deployment
│   └── Profile
└── Behavior (7)
    ├── Use Case
    ├── Activity
    ├── State Machine
    └── Interaction (sub-family)
        ├── Sequence
        ├── Communication
        ├── Timing
        └── Interaction Overview
```

## 3. The 14 diagram types

| # | Diagram | Family | What it captures | Mermaid? |
| --- | --- | --- | --- | --- |
| 1 | Class | Structure | Classifiers, attributes, operations, relationships | Yes (`classDiagram`) |
| 2 | Object | Structure | A snapshot of instances and their links | No |
| 3 | Package | Structure | Grouping of model elements into namespaces | No |
| 4 | Composite Structure | Structure | Internal parts, ports, connectors of a classifier | No |
| 5 | Component | Structure | Components and their provided/required interfaces | No |
| 6 | Deployment | Structure | Hardware nodes and the artifacts deployed on them | No |
| 7 | Profile | Structure | Extensions to UML via stereotypes | No |
| 8 | Use Case | Behavior | System scope, actors, and their goals | No |
| 9 | Activity | Behavior | Workflow / control & object flow | Yes (via `flowchart`) |
| 10 | State Machine | Behavior | States of one object and event-driven transitions | Yes (`stateDiagram-v2`) |
| 11 | Sequence | Behavior/Interaction | Time-ordered messages between lifelines | Yes (`sequenceDiagram`) |
| 12 | Communication | Behavior/Interaction | Same interaction, emphasizing links/structure | No |
| 13 | Timing | Behavior/Interaction | State/value of lifelines against a time axis | No |
| 14 | Interaction Overview | Behavior/Interaction | Activity-style flow whose nodes are interactions | No |

## 4. Picking a diagram type

- *What things exist and how they relate?* → **Class** (types) or **Object** (a concrete instance snapshot).
- *Who uses the system and for what?* → **Use Case**.
- *What is the step-by-step process / algorithm / business flow?* → **Activity**.
- *How does one object react to events over its lifetime?* → **State Machine**.
- *In what order do objects talk to do one scenario?* → **Sequence** (time emphasis) or **Communication** (structure emphasis).
- *How does a signal/value change against real time?* → **Timing**.
- *How do several scenarios string together at a high level?* → **Interaction Overview**.
- *How is the code organized into modules with interfaces?* → **Component**; *how is the build laid into folders/namespaces?* → **Package**.
- *What runs on what hardware?* → **Deployment**.
- *What is the internal wiring of a classifier?* → **Composite Structure**.
- *Inventing your own modeling vocabulary on top of UML?* → **Profile**.

## 5. Cross-cutting notation

These conventions apply across many diagrams; the per-diagram files assume them.

### Visibility

Prefixed on attributes, operations, roles, and other features:

| Symbol | Visibility | Meaning |
| --- | --- | --- |
| `+` | public | visible to any element that can access the namespace |
| `-` | private | visible only inside the owning classifier |
| `#` | protected | visible to the classifier and its specializations |
| `~` | package | visible to elements in the same package |

### Multiplicity

Written as `lower..upper` on an association end, attribute, or part. `*` means unbounded (so `0..*` = "zero or more"; `*` alone is shorthand for `0..*`). Examples: `1` (exactly one), `0..1` (optional), `1..*` (one or more), `2..4`. Multiplicity may carry `{ordered}`, `{unordered}`, `{unique}`, `{nonunique}` property strings — e.g. `[0..*] {ordered, unique}` is the default-set semantics for a sequence.

### Name strings, roles, qualifiers

- Attribute syntax: `visibility name : type [multiplicity] = default {property-string}` — e.g. `- balance : Money [1] = 0 {readOnly}`.
- Operation syntax: `visibility name(param-list) : return-type {property-string}` where each param is `direction name : type = default` and `direction ∈ {in, out, inout, return}`.
- Association ends carry a **role name** and **multiplicity**; a filled arrowhead/open arrow indicates navigability; an `x` on an end means **not navigable**.
- A **qualifier** is a small box on the source end naming a key that partitions the target set (e.g. `Bank [accountNo] —— Account`).

### Stereotypes & profiles

A **stereotype** extends a metaclass with extra semantics, shown in guillemets: `«interface»`, `«enumeration»`, `«include»`, `«deploy»`. Multiple stereotypes: `«stereo1, stereo2»`. Stereotypes are defined in a **Profile** (see `profile-diagram.md`) and may add **tagged values** (name=value properties). Do not invent stereotypes that contradict standard ones.

### Notes, comments, and `{constraints}`

- A **comment/note** is a dog-eared rectangle attached by a dashed line; it carries no semantics.
- A **constraint** is a boolean condition in curly braces `{ }`, e.g. `{age >= 18}`, `{self.end > self.start}`, or OCL. On an association, `{xor}` between two associations means exactly one holds. `{subsets r}`, `{redefines r}`, `{union}` refine association ends.

### Packages & namespaces

A **package** is a named container (a tabbed folder) that owns a namespace; fully-qualified names use `::` (e.g. `Banking::Account`). Dependencies between packages use dashed arrows, optionally `«import»` / `«access»` / `«merge»`. See `package-diagram.md`.

### Keywords vs stereotypes

UML **keywords** (e.g. `{abstract}`, `«interface»` as a predefined keyword, `«primitive»`) are built into UML; **stereotypes** come from an applied profile. Both render in guillemets, but keywords are not user-defined. Abstract classifiers/operations are shown with the name in *italics* or the keyword `{abstract}`.
