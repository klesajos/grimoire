# archmage — review log (resolved)

Output of a **40-agent review + test pass** over the `archmage` plugin (20 partitioned
review-and-fix agents → 20 read-only skill-trial agents → synthesis). Straightforward fixes were
applied in-place during the review (commit `0a0d279`); the deeper improvements were filed as GitHub
issues #3–#21 and have since been **resolved** (closed via #23 / the `feat/archmage-ea-plugin`
merge). This file is kept as a historical index of what the review found and fixed.

## Already resolved in this pass
- **Generate missing rendered PNGs** for authored render markers (bpmn approximations, `ea-build-steps`) — re-rendered; image health verified (no broken links, no marker without a PNG).
- **Remove stale render markers** from the 3 GitHub-native (no-PNG) class diagrams — all three cleaned.
- The 20-agent fix phase also flipped the confirmed **ArchiMate MDG strings** (`ArchiMate3::ArchiMate_*`) from "verify in live EA", corrected UML 2.5.1 collection-kind semantics, and confirmed EA type strings (Realization, Object, Part, Composite Structure, Device, Artifact, …) across ~28 files.

## Resolved improvements (issues #3–#21 — all CLOSED)

### High priority
| Issue | Title | Area |
| --- | --- | --- |
| [#3](https://github.com/klesajos/grimoire/issues/3) | Fix wrong attribute/operation payload shapes & member visibility field in build-workflow.md (`attributeInfo`/`operationInfo` envelope; `scope` not `visibility`) | bug · ea |
| [#4](https://github.com/klesajos/grimoire/issues/4) | `sourceCardinality` is not a real connector field — use `sourceEnd.multiplicity` (diagram-type-playbooks.md) | bug · ea |
| [#6](https://github.com/klesajos/grimoire/issues/6) | profile-diagram.md tells users to create a non-existent `Stereotype` EA element type | bug · ea · uml |
| [#7](https://github.com/klesajos/grimoire/issues/7) | Flip stale BPMN "verify in live EA" framing in notation-to-ea-mapping.md to the confirmed not-creatable limitation | docs · ea · bpmn |

### Medium priority
| Issue | Title | Area |
| --- | --- | --- |
| [#5](https://github.com/klesajos/grimoire/issues/5) | Document the `create_or_update_messages` payload (uses `sourceElementID`/`targetElementID`, unlike connectors) | docs · ea |
| [#8](https://github.com/klesajos/grimoire/issues/8) | Make the `/archmage:ea-doctor` write-tools check robust / human-framed | bug · ea · infra |
| [#9](https://github.com/klesajos/grimoire/issues/9) | Fix self-contradictory ER cardinality pitfall in mermaid/er.md | bug · mermaid |
| [#10](https://github.com/klesajos/grimoire/issues/10) | Fix dangling `reference/`-prefixed sibling cross-references in two togaf files | docs · togaf |
| [#11](https://github.com/klesajos/grimoire/issues/11) | Resolve the composite-aggregation (composition) build mechanism — MCP field unidentified | enhancement · ea · uml |
| [#13](https://github.com/klesajos/grimoire/issues/13) | Clarify the ArchiMate diagram-type string behaviour & host-on-`Class` guidance | docs · ea · archimate |
| [#14](https://github.com/klesajos/grimoire/issues/14) | Harden idempotency/recovery guidance for half-built models after a timeout | docs · ea |
| [#15](https://github.com/klesajos/grimoire/issues/15) | Tighten cross-cutting SKILL.md router consistency (array claim, trigger coverage, stale ArchiMate description) | docs · archimate · uml · mermaid |

### Low priority
| Issue | Title | Area |
| --- | --- | --- |
| [#12](https://github.com/klesajos/grimoire/issues/12) | Resolve/document the unverified UML `Requirement` element & `Package` diagram-type strings | docs · ea · uml |
| [#16](https://github.com/klesajos/grimoire/issues/16) | Add a "Choosing the notation" decision aid at the ea-modeling entry point | docs · ea |
| [#17](https://github.com/klesajos/grimoire/issues/17) | Tracking: confirm remaining ArchiMate/UML diagram-type/connector strings live in EA | enhancement · ea · uml |
| [#18](https://github.com/klesajos/grimoire/issues/18) | Standardize the MCP tool-name qualification convention and document it once | docs · ea · infra |
| [#19](https://github.com/klesajos/grimoire/issues/19) | Tracking: build real BPMN diagrams via the EA GUI toolbox (MCP cannot create BPMN) | enhancement · bpmn · ea |
| [#20](https://github.com/klesajos/grimoire/issues/20) | Tracking: pin a Mermaid build that renders `classDiagram` with `<<interface>>` + members | infra · mermaid · enhancement |
| [#21](https://github.com/klesajos/grimoire/issues/21) | Tighten correctness nits across UML/BPMN behaviour & worked-example files | docs · uml · bpmn · archimate |

---
*Generated 2026-06-16 from a multi-agent review of `plugins/archmage`. The fix phase landed in commit `0a0d279`; the 19 items above were filed as issues #3–#21 and are now all closed (resolved via #23).*

---

## 2026-06-21 - Diagram-regeneration dogfood (20-subagent recon)

A 20-subagent recon walked every diagram in the plugin, used the archmage skill to derive each diagram's regeneration recipe, graded the current render against the project quality bars, and logged where the skill docs made that hard. 28 improvements + a 46-item work-list.

### Improvements (ranked)

1. **[HIGH] Missing diagram-type playbooks for confirmed types**
   - Finding: diagram-type-playbooks.md covers only Class/Use Case/Sequence/Activity/State/Requirements, but the cheatsheet confirms Component, Deployment, Object, Composite Structure, Profile, Communication, and Timing as buildable. Regenerators of Component, Deployment, Object, Composite Structure, and Profile diagrams found NO canonical layout-and-COM-polish recipe and had to stitch one from the cheatsheet + uml reference + class playbook.
   - Fix: Add playbook sections for Component (provided=Realization/required=Dependency, Direction fix, head-lands-on-interface), Deployment (artifact-in-node nesting via owningElementID vs «deploy» arrow, CommunicationPath), Object (Object elements, plain links, RunState slots), Composite Structure (Part/Port ownership, lollipop/socket, assembly vs delegation), and Profile («profile» frame, Extension vs Generalization heads). Update the playbook Contents list.
   - Affects: skills/ea-modeling/reference/diagram-type-playbooks.md

2. **[HIGH] ea-type-cheatsheet.md (declared single source of truth) is missing confirmed type strings**
   - Finding: The cheatsheet is declared the canonical source for type strings yet omits several confirmed strings that live only in skill references: Boundary (use-case system boundary, confirmed only in use-case-diagram.md), CommunicationPath (deployment, only in deployment-diagram.md), Synchronization (activity fork/join bar, only in prose), and executionEnvironment (no row, capitalization unconfirmed). The missing Boundary row is exactly why uml-use-case-library.png shipped with no system boundary.
   - Fix: Add rows to ea-type-cheatsheet.md for: System boundary -> Boundary; Communication path -> CommunicationPath; Fork/join -> Synchronization; execution environment -> Node + stereotypes:'executionEnvironment' (with confirmed string). Mirror the Boundary/CommunicationPath additions into notation-to-ea-mapping.md.
   - Affects: shared/reference/ea-type-cheatsheet.md, notation-to-ea-mapping.md

3. **[HIGH] No per-diagram-type scoping of the quality bars**
   - Finding: The project grading bars (top-to-bottom flow, single aligned spine, side-MIDDLE entry, FILLED composite diamonds, VISIBLE initial/final nodes, SwimlaneDef swimlanes, navigability arrows, headless-connector heads, orthogonal routing) are overwhelmingly class/activity/state/swimlane concerns. Almost none apply to sequence, object, composite-structure, profile, deployment, ArchiMate, or any Mermaid diagram. Worse, for object diagrams navigability arrows would be a notation ERROR. Nothing states which bars apply to which diagram kind, risking mis-grading correct diagrams or 'fixing' them into errors.
   - Fix: Add an 'applicable quality bars by diagram type' table (in uml/archimate SKILL.md or alongside the bars) carving structure/snapshot diagrams out of the flow/arrow bars and naming the bars that DO apply per type (e.g. sequence: message order + sync/return + activation + lifeline naming).
   - Affects: skills/uml/SKILL.md, skills/archimate SKILL.md, diagram-type-playbooks.md, grading bars doc

4. **[HIGH] Mermaid render pipeline mishandles UTF-8 (mojibake)**
   - Finding: The render pipeline decodes UTF-8 .mmd source as Latin-1/Windows-1252, corrupting all non-ASCII glyphs. uml-package-dependencies.png ships «access»/«import» as 'Â«accessÂ»' and mermaid-c4-context.png ships its em-dash title as 'â€"'. The source files are confirmed valid UTF-8, so this is a render-time encoding defect that silently breaks every stereotype-heavy (guillemet) and smart-punctuation example.
   - Fix: Fix the renderer to read .mmd and load the puppeteer/HTML page as UTF-8 (ensure <meta charset="utf-8">; the Windows default code page is the likely culprit). Add a SKILL.md note: use &laquo;/&raquo; (or &#171;/&#187;) for guillemets and keep titles ASCII (avoid em-dashes/smart quotes) unless UTF-8 is guaranteed. Add a guillemet entry to flowchart.md 'Special characters' pitfalls.
   - Affects: skills/mermaid/SKILL.md, skills/mermaid/reference/flowchart.md, skills/uml/reference/package-diagram.md, skills/mermaid/reference/c4.md, render toolchain

5. **[HIGH] connectorStyle:'OrthogonalSquare' undocumented in the core build path**
   - Finding: Orthogonal routing is a stated project quality bar, yet the single field that controls it (connectorStyle:'OrthogonalSquare') appears ONLY in ea-com-bridge.md's 'Connector routing' section (framed around activity/swimlane diagrams). It is absent from build-workflow.md Step 4's connector payload, from ea-type-cheatsheet.md's connector field list, from worked-examples.md, and from every diagram-type playbook. The result is directly visible as diagonal edges in we-class-ea, we-activity-ea, archimate-layered-view, and others.
   - Fix: Add connectorStyle:'OrthogonalSquare' as a documented connector-payload field in build-workflow.md Step 4 and ea-type-cheatsheet.md's connector row, and reference it from each diagram-type playbook (class, activity, deployment, use-case, ArchiMate) and worked-examples.md. Note that layout_connectors alone leaves diagonals.
   - Affects: build-workflow.md, ea-type-cheatsheet.md, ea-com-bridge.md, diagram-type-playbooks.md, worked-examples.md, archimate/ea-bridge.md

6. **[HIGH] Worked-example docs and shipped PNGs are out of sync**
   - Finding: Multiple reference docs describe a different (usually richer) diagram than the committed image, so following the doc regenerates the wrong artifact. Component (doc: assembly+artifact+manifest; PNG: expanded-interface IOrdering/IPayment), Deployment (doc: 3-node nested executionEnvironment + HTTPS/JDBC; PNG: 2-node TCP/IP), Object (doc: cityLib/copy42/loan99 + 'owns'; PNG: central/c100/l42, no label), Composite Structure (doc: Car/ports/lollipops; PNG: Order Processing, no ports/interfaces), ArchiMate Layered (doc: ~30 elements with Serving spine; PNG: 6-box smoke test). Each doc's '![...](image)' implies the image IS the worked example.
   - Fix: For each pair, pick one source of truth: either re-render the PNG to match the documented model or rewrite the worked example to match the shipped image. Where EA cannot produce the doc's notation, add a caption noting the image is a reduced/illustrative subset.
   - Affects: component-diagram.md, deployment-diagram.md, object-diagram.md, composite-structure-diagram.md, archimate/worked-example.md, archimate/ea-bridge.md

7. **[MED] Port-on-boundary and pseudostate placement need COM, but the dependency is buried in the bridge file**
   - Finding: place_elements_on_diagram silently NO-OPS for StateNode pseudostates (initial/final) and likely for boundary Ports, requiring a COM DiagramObjects.AddNew step with a NEGATIVE-Y l/r/t/b box. This is documented only in ea-com-bridge.md; worked-examples.md and the playbooks say merely 'make sure both are placed' or omit it entirely, so a regenerator calls place_elements_on_diagram, sees nothing, and is stuck. The AddNew coords also have no tie to the lane/spine x, and the negative-Y convention is never restated in the worked example.
   - Fix: Flag the place-no-op + COM AddNew dependency inline in the state-machine, activity, and composite-structure playbooks (not only the bridge). Add a worked 'place the initial node centered in lane 1' example tying SwimlaneDef.width / spine x to the AddNew l/r/t/b box, and restate the negative-Y convention.
   - Affects: ea-com-bridge.md, worked-examples.md, diagram-type-playbooks.md

8. **[MED] Manifest dependency and Assembly connector unverified / conflicting**
   - Finding: component-diagram.md claims the 'Assembly' connector is '(confirmed)' but the cheatsheet has no Assembly row; the «manifest» dependency is variously 'verify in live EA' (component + deployment docs) while the cheatsheet only documents stereotypes:'deploy', not 'manifest'. There is no single confirmed recipe for «manifest», yet the doc's worked example depends on it.
   - Fix: Probe Assembly and manifest on a ZZ_ throwaway, then record the confirmed strings in one place (likely Dependency + stereotypes:'manifest'); reconcile the 'confirmed' vs 'verify' labels across the component, deployment, and cheatsheet docs.
   - Affects: component-diagram.md, deployment-diagram.md, ea-type-cheatsheet.md

9. **[MED] Lollipop/socket and assembly-vs-delegation notation has no EA recipe**
   - Finding: Component and Composite Structure docs make ball-and-socket (lollipop/socket) and assembly-vs-delegation connectors the centerpiece, but there is no confirmed connector-string recipe to produce them via the MCP — the cheatsheet has no lollipop/socket/assembly rows, and the MCP path yields expanded-interface boxes, not lollipops. Both diagrams shipped without these features, consistent with there being no documented way to create them.
   - Fix: Resolve and document the lollipop/socket and assembly/delegation recipes (or state explicitly that they are EA-GUI-only and the MCP yields expanded-interface notation). Add 'Assembly' and provided/required-interface rows to the cheatsheet with real verification status; downgrade the unsupported 'confirmed' label on the Assembly connector.
   - Affects: component-diagram.md, composite-structure-diagram.md, ea-type-cheatsheet.md, notation-to-ea-mapping.md

10. **[MED] No Mermaid layout-quality / house-style bar (direction, spacing, ELK, crossings)**
   - Finding: The grading bars are EA-centric; the mermaid skill states no Mermaid-specific tidiness target (preferred direction, single-spine, even spacing, max nodes/row, when to label edges, theme consistency). Authors had no target, producing: TOGAF ultra-wide fans and staircase drift, ArchiMate hub tangle, inconsistent directions (5 LR + 2 TD in BPMN; TB vs TD mix), and clashing yellow subgraph fills across a doc set. The levers that fix these (config.flowchart.curve:linear, nodeSpacing, rankSpacing, layout:elk, theme:neutral, empty direction-LR subgraphs for multi-row grids) are barely or never documented.
   - Fix: Add a 'flowchart layout hygiene / house style' section to flowchart.md and SKILL.md: prefer one direction per diagram class, document nodeSpacing/rankSpacing/curve keys, the ELK layout option (and that it needs a separate package and may not render on GitHub), subgraph-row regrouping to avoid wide fans, and 'pick one theme per doc set' (recommend neutral). Add a 'taming crossings / dense hub-and-spoke' anti-pattern note.
   - Affects: skills/mermaid/SKILL.md, skills/mermaid/reference/flowchart.md

11. **[MED] Mermaid render toolchain / version is undocumented**
   - Finding: Every reference file uses the diagrams but NO doc records how a PNG is produced — no mmdc/mermaid-cli command, theme, background, scale, or engine version. A regenerator cannot reproduce theme colors, background, or pixel scale, and cannot predict canvas-width-dependent defects (the gantt axis collision is partly width-dependent). This recurs across every Mermaid slice.
   - Fix: Add a short reference/rendering.md (or SKILL.md section) documenting the exact mmdc invocation, theme, background, and scale used to generate committed images, plus a per-image '<!-- rendered with: ... -->' breadcrumb.
   - Affects: skills/mermaid/SKILL.md, skills/mermaid/reference/*.md

12. **[MED] ControlFlow guard field name and bracket convention not spelled out**
   - Finding: worked-examples.md and the activity playbook say 'put the guard in the connector name' / 'set the guard as the connector's guard property' but never give the exact MCP field name (name? guard? transitionGuard?) nor confirm the [square brackets] are literal text, unlike attributes' 'scope' and connector ends' 'relatedElementID' which ARE spelled out. The rendered [in stock]/[else]/[valid] labels prove it works but the regenerator must guess.
   - Fix: Document the exact guard field name and the literal-bracket convention in ea-type-cheatsheet.md / build-workflow.md, and show one concrete guarded-ControlFlow payload in the activity playbook.
   - Affects: ea-type-cheatsheet.md, build-workflow.md, diagram-type-playbooks.md, worked-examples.md

13. **[MED] Cross-lane / cross-layer routing: corner-entry and side-entry caveats buried or absent**
   - Finding: EA's router minimizes bends and produces side-entering L-routes; the 'cannot force top-entry across a lane' caveat lives only in ea-com-bridge.md framed for swimlanes and is never cross-referenced for state machines, use-case fans, or ArchiMate layered views. Separately, the bars forbid CORNER entry but no doc gives the lever to hit side-MIDDLE (align the source's exit Y to the target's vertical center), which is exactly the uml-activity-process-order Submit->Validate defect.
   - Fix: Add a concrete 'align the source exit Y to the target vertical center to avoid corner entry' tip and state per type that perfect orthogonal top-entry across a lane is GUI-only. Cross-reference the routing caveat from the state-machine, use-case, and ArchiMate docs (where the fan/radial default produces crossings).
   - Affects: ea-com-bridge.md, diagram-type-playbooks.md, archimate/ea-bridge.md, use-case-diagram.md

14. **[MED] No layout/coordinate guidance for several diagram types**
   - Finding: 'Uniform grid, even spacing, single aligned spine' is an explicit bar, but several types get no placement coordinates and the renders miss the bar as a result. Class (no x/y sketch -> OrderLine/Product not column-aligned), Sequence (no lifeline-header geometry), Use Case (only 'actors-left, cases-right' -> diagonal crossing fan), single-lane Activity branch/merge (no centered-spine/mirror-branches note -> asymmetric layout), swimlane Activity (no 'reject branch beside not below' rule -> dead vertical gap), Object/Profile (no spine sketch).
   - Fix: Add concrete coordinate sketches and layout conventions to the relevant playbooks: class grid with shared columns; sequence lifeline header row; use-case actors-left + two case columns with «include»/«extend» targets level with their base; single-lane activity centered spine with mirrored branches; swimlane branch-beside-spine + even vertical pitch.
   - Affects: worked-examples.md, diagram-type-playbooks.md, ea-com-bridge.md

15. **[MED] Composite-aggregation end (ClientEnd vs SupplierEnd) hard-codes the whole-is-target assumption**
   - Finding: worked-examples.md and ea-com-bridge.md both instruct SupplierEnd.Aggregation=2 'on the end attached to the whole' but only ever show the SupplierEnd code, implicitly assuming the whole is the TARGET. In we-class-ea the whole (Order) is the SOURCE of the Order->OrderLine aggregation, so the correct end is ClientEnd; a reader copying the SupplierEnd snippet would put the filled diamond on the wrong (OrderLine) end.
   - Fix: Add an explicit ClientEnd code branch keyed to 'if the whole is the source/Client end', and a one-line rule: always confirm which end is the aggregate by name before setting Aggregation=2.
   - Affects: shared/reference/worked-examples.md, shared/reference/ea-com-bridge.md

16. **[MED] MCP create payload vs COM bridge direction contradiction unflagged**
   - Finding: ea-type-cheatsheet.md hard-rule #2 and the ea-modeling SKILL gotcha state connector direction 'Source -> Destination' FAILS / use 'Unspecified'. True for the MCP create payload, but worked-examples.md and ea-com-bridge.md then tell you to set Direction='Source -> Destination' via COM for navigability/heads. A reader hits an apparent contradiction.
   - Fix: Add a one-line cross-reference to the cheatsheet rule: '(the COM bridge DOES accept Source -> Destination on an existing connector — this rule is about the MCP create payload only).'
   - Affects: shared/reference/ea-type-cheatsheet.md, ea-modeling/SKILL.md

17. **[MED] Object-diagram slots (RunState) and classifier typing undocumented**
   - Finding: Slots are the entire point of an object diagram, yet object-diagram.md admits the slot/run-state mechanism is UNVERIFIED and no doc gives a concrete recipe; uml-object-library.png shipped with ZERO slots. Separately, naming an Object 'instance : Classifier' only sets header TEXT — real classifier typing (so slots can derive) needs a COM ClassifierID step the create payload does not expose.
   - Fix: Add a confirmed COM recipe to ea-com-bridge.md: Element.RunState string format ('@VAR;Variable=...;Value=...;Op==;Note=;@END;') for slots and Element.ClassifierID for typing, plus a note that the GUI 'Set Run State' dialog is the fallback. State that plain naming is header-only.
   - Affects: object-diagram.md, ea-com-bridge.md, diagram-type-playbooks.md (new Object section)

18. **[MED] Headless connectors: head-landing direction (source/target orientation) underspecified**
   - Finding: The COM Direction='Source -> Destination' fix draws heads on Dependency/Realization/Extension/Serving, but the docs don't state which end must be source so the head lands correctly per diagram: Component (source MUST be the component so the head lands on the interface), «deploy» (source MUST be the artifact so the arrow points up into the node), Extension (source MUST be the stereotype so the filled triangle lands on the metaclass), Serving in ArchiMate (must be applied to EVERY Serving edge or the layered spine renders invisible). Easy to produce inverted or invisible heads.
   - Fix: In ea-com-bridge.md's 'Headless connectors' section add per-relationship source/target notes (component->interface, artifact->node, stereotype->metaclass) and make 'every Serving connector needs the Direction fix' a numbered build step in archimate/ea-bridge.md. Also caution: do NOT set Direction on use-case actor associations (they must stay plain).
   - Affects: ea-com-bridge.md, archimate/ea-bridge.md, component-diagram.md, deployment-diagram.md, profile-diagram.md, use-case-diagram.md

19. **[LOW] Fork/join multi-edge alternative misleads; reset-Navigable-first dance ambiguous**
   - Finding: The activity playbook offers 'or model parallelism with multiple outgoing/incoming control flows on a fork node' as an alternative to a Synchronization bar — but that renders a diamond/no-bar and FAILS the 'filled bar fork' bar. Separately, ea-com-bridge.md shows a reset-Navigable-first dance before setting Direction, while worked-examples.md shows only the bare one-liner; it's unclear when each is required.
   - Fix: State plainly: use Synchronization for the visible fork/join bar; the multi-edge alternative does not render a bar. Clarify that the bare Direction one-liner suffices on a freshly-created plain association and the reset-first version is only needed when re-orienting an existing navigable end.
   - Affects: diagram-type-playbooks.md, ea-com-bridge.md, worked-examples.md, ea-type-cheatsheet.md

20. **[LOW] Activation bars, layout_connectors, and full Subtype map underspecified for some types**
   - Finding: Sequence diagrams show activation bars but no EA doc says they are auto-derived from sync call/return pairing (no extra step) — the reader can't tell if a step is needed; and whether layout_connectors helps/no-ops/disturbs message order on a sequence diagram is undocumented. For activity, only Subtype 100=initial/101=final are mapped; the flow-final (circle-with-X) terminal kind has no recipe.
   - Fix: Add a one-line note that EA auto-derives sequence execution-occurrence bars (no separate step) and that sequence ordering relies on the 'order' field (layout_connectors unnecessary). Document the full activity pseudostate Subtype map including whether flow-final is reachable.
   - Affects: diagram-type-playbooks.md, worked-examples.md, ea-com-bridge.md, ea-type-cheatsheet.md

21. **[LOW] Build-order sequence duplicated by hand in three places (drift risk)**
   - Finding: The canonical EA build order is encoded independently three times: the ea-mcp-build-order Mermaid diagram, the pseudo-code block in ea-type-cheatsheet.md, and the tail of tool-catalog-write.md. No cross-reference links them, so adding/reordering a step requires updating three copies with no shared source of truth.
   - Fix: Add a comment in each copy pointing at the others as the shared source of truth (or designate one canonical list the others reference), to prevent drift.
   - Affects: ea-type-cheatsheet.md, skills/ea-mcp tool-catalog-write.md, ea-mcp build-order diagram

22. **[LOW] Diagram captions/names not stated, so frame labels aren't reproducible**
   - Finding: Rendered EA frame labels ('class Shop - Class Model', 'sd Shop - Place Order', 'act Shop - Handle Order') depend on the diagramInfo.name, but the worked-example recipes give only type:'...' with no name example, so a regenerator must guess the title to match the rendered frame.
   - Fix: Document the exact diagram name alongside its type in each worked example so the rendered frame label is reproducible.
   - Affects: shared/reference/worked-examples.md

23. **[LOW] Mermaid reference under-illustrates the patterns the worked examples actually use**
   - Finding: Several skill reference files lead with idioms different from what the worked examples ship, or omit the simple pattern entirely: sequence.md leads with +/- activation shorthand while examples use long-form activate/deactivate; class.md uses type-first attributes while worked-examples uses 'name: Type' (both parse, undocumented as equivalent); state.md only shows trivial [*] cases, not multiple-incoming-finals or labels-with-slashes; er.md drops the attribute-comment column so no rendered sample shows it; mindmap lives only in other-diagrams.md with weak indexing.
   - Fix: Note equivalent forms (shorthand vs long-form activation; 'visibility name : Type' alternate attribute form) and add minimal rendered samples for the patterns the worked examples rely on (multi-path-to-final, attribute comments). Surface mindmap's location in the SKILL.md table of contents.
   - Affects: skills/mermaid/reference/sequence.md, class.md, state.md, er.md, other-diagrams.md, SKILL.md

24. **[LOW] Undocumented Mermaid idioms relied on by shipped examples**
   - Finding: Several load-bearing idioms are used but never documented: empty-label node + fill:#000 classDef = fork/join bar (activity-diagram.md); repeating 'State: line' to build a state's entry/exit compartment (state-machine); the A --- B & C & D ampersand fan shorthand for hubs (TOGAF); forward-referencing a subgraph id before its declaration; that a child subgraph silently overrides the parent's direction (caused the TB-came-out-LR content-hierarchy bug); subgraph titles colliding with node labels render the label twice (content-hierarchy duplicate). A from-scratch regenerator cannot derive these.
   - Fix: Document each idiom in flowchart.md/state.md with a one-line note: the empty-node+black-classDef bar pattern, the repeat-State compartment pattern, the & fan shorthand, subgraph forward-reference, per-subgraph direction (must restate or it won't inherit), and the title-vs-label duplication trap.
   - Affects: skills/mermaid/reference/flowchart.md, skills/mermaid/reference/state.md, activity-diagram.md

25. **[LOW] Mermaid reserved-word / special-char escaping gaps**
   - Finding: flowchart.md warns bare 'end' breaks the parser but doesn't clarify the safe cases the examples rely on: 'End' as a node ID with ((End)) label is fine, and parentheses/colons/slashes inside ['...'] need quoting (only mentioned generically in SKILL.md, not in the flowchart Pitfalls at point of use). The guillemets « » mandatory for UML stereotype labels are omitted from the special-character list. Edge-label escaping differs between |text| (tolerates commas) and -- text --> forms, undocumented.
   - Fix: Expand flowchart.md Pitfalls: node IDs like End are safe (only a bare lowercase end token breaks); quote parens/colons/slashes inside [...]; add guillemets with the &laquo;/&raquo; recommendation; document the |...| vs -- ... --> edge-label escaping difference.
   - Affects: skills/mermaid/reference/flowchart.md, skills/mermaid/SKILL.md

26. **[LOW] Distinct terminal nodes labelled identically; merge/boundary semantics unmapped in Mermaid**
   - Finding: Multiple Mermaid sketches reuse 'End' (or 'message') as the visible label for distinct nodes, hurting legibility most where meanings differ (bpmn-events normal vs escalated end; bpmn-collaboration two unnamed message flows). Cross-twin semantic mismatches go unflagged: the activity Decision 'also serves as merge' in EA but the Mermaid merge moves to the join action; BPMN dotted means boundary/sequence in one sketch but Association/message elsewhere (contradicting flows-and-data.md). No doc says distinct terminals should carry distinct labels, nor gives a Mermaid pattern for boundary events.
   - Fix: Add a BPMN/Mermaid approximation-convention block (shared checklist): distinct terminal nodes get distinct labels; solid=sequence inside a subgraph, dotted=message between subgraphs/pools; subgraph=pool/sub-process; parallelogram=data object, cylinder=data store; prefer TD; approximate a boundary event as a labelled branch off the activity. Note where a Mermaid twin's merge/semantics intentionally differ from its EA twin.
   - Affects: skills/bpmn/reference/*.md, skills/bpmn/SKILL.md, activity-diagram.md, skills/mermaid/reference/flowchart.md

27. **[LOW] Stereotype text vs glyph and structure-frame rendering not explained**
   - Finding: EA renders an applied «stereotype» as a small '<>' metatype glyph in the box corner, not the literal guillemet keyword the docs' ASCII shows (uml-profile-bpm), so a regenerator thinks the keyword is missing. Separately, how the «profile» package frame, the use-case Boundary, and ArchiMate 'class'-titled diagram frame get drawn/relabelled on the diagram is unexplained, and the ArchiMate view diagram-type FQN is still unresolved (forced onto a 'class ...'-titled Class diagram).
   - Fix: Document that the '<>' glyph IS the stereotype indicator (with the GUI display option to show «stereotype» text), how a «profile»/Boundary frame is placed, and resolve the ArchiMate view FQN on a ZZ_ throwaway (record the confirmed string or how to relabel the 'class' frame header).
   - Affects: profile-diagram.md, use-case-diagram.md, ea-type-cheatsheet.md, archimate/ea-bridge.md

28. **[LOW] Render-marker convention and slice file-set boundaries undocumented**
   - Finding: The '<!-- render: images/X.png -->' comment is the contract pairing Mermaid source to its committed PNG, used everywhere but defined nowhere (path relative to the .md, must sit directly above the fence, what consumes it). Relatedly, some rendered diagrams live where the slice description doesn't point (bpmn-process-sketch in SKILL.md not reference/), and files contain unmarked inline-only Mermaid blocks (overview-and-rules.md §8) — so a regenerator must grep for the marker rather than count fences.
   - Fix: Document the render-marker semantics in mermaid SKILL.md (it pairs source->PNG; path is relative to the containing .md; must sit directly above the fenced block; only marked blocks have PNGs). Note that rendered examples can live in SKILL.md as well as reference/.
   - Affects: skills/mermaid/SKILL.md, skills/bpmn/SKILL.md, overview-and-rules.md

### Regeneration work-list (actionable only)

- **we-class-ea.png** (EA) - Add connectorStyle:'OrthogonalSquare' to all connectors and place classes on a uniform two-row grid (Order/OrderLine and Payment/Product column-aligned); fix diagonal routing and loose spine.
- **we-state-ea.png** (EA) - Re-layout as a vertical top-to-bottom spine with Cancelled as an off-spine side sink; set connectorStyle:'OrthogonalSquare' (accept side-entering L-routes as the ceiling).
- **we-sequence-ea.png** (EA) - Drop the trailing '()' on the two return-message names (approved, orderConfirmed) to match the Mermaid twin; otherwise faithful.
- **we-activity-ea.png** (EA) - Add connectorStyle:'OrthogonalSquare' on every ControlFlow and lay out a centered spine with the two branches mirrored symmetrically; fix diagonal branch/merge edges and asymmetric grid.
- **uml-component-ordering.png** (EA) - Reconcile with its doc: either re-render to the doc's assembly+artifact+manifest variant or rewrite the doc to the shipped expanded-interface style; add connectorStyle:'OrthogonalSquare'.
- **uml-use-case-library.png** (EA) - Add the missing 'Library' Boundary element enclosing the use cases; align actor Y between their cases and apply OrthogonalSquare to fix the crossing/diagonal association fan.
- **uml-deployment-ordering.png** (EA) - Sync with doc: either upgrade to the 3-node nested-executionEnvironment topology (Client PC, Tomcat, HTTPS/JDBC) or simplify the ASCII to the shipped 2-node TCP/IP version.
- **uml-object-library.png** (EA) - Add the missing slot/run-state compartments via COM Element.RunState; reconcile instance names with the doc (cityLib/copy42/loan99) and restore the 'owns' role label.
- **uml-composite-structure.png** (EA) - Add boundary Ports and provided/required (lollipop/socket) interfaces plus an assembly-vs-delegation connector; or downgrade the doc's worked example to what EA can render.
- **uml-profile-bpm.png** (EA) - Faithful render; optionally enable the «stereotype» keyword text display option to match the doc (currently shows only the '<>' glyph). No structural fix required.
- **uml-activity-process-order.png** (EA) - Fix corner-entry on Submit->Validate (align source exit Y to target center) and close the dead vertical gap by pulling the fork up / keeping the reject branch beside (not below) the happy path.
- **archimate-layered-view.png** (EA) - Rebuild to the full ~30-element documented model with the Serving spine (apply COM Direction fix so Serving heads draw); add connectorStyle:'OrthogonalSquare' and align a uniform layer grid.
- **uml-package-dependencies.png** (Mermaid) - Fix guillemet mojibake (Â«accessÂ»): replace « » with &laquo;/&raquo; HTML entities or render the UTF-8 source through a UTF-8-clean pipeline.
- **archimate-relationships-sketch.png** (Mermaid) - Re-layout with ELK + curve:linear + layer subgraphs (Tech over App over Business) to untangle the Business Service hub and reduce crossings.
- **bpmn-events-approx.png** (Mermaid) - Regenerate as TD; rename the two End nodes (Reviewed/Escalated) and make the timer-boundary edge leave the activity cleanly (fix corner-origin spline and identical-End ambiguity).
- **bpmn-data-approx.png** (Mermaid) - Switch to TD so the solid sequence spine runs straight and data nodes (parallelogram/cylinder) hang to the side instead of being overarched by the R->C edge.
- **bpmn-collaboration-approx.png** (Mermaid) - Keep structure; name the two message-flow edges (Leave request / Decision) instead of generic 'message'.
- **togaf-adm-cycle.png** (Mermaid) - Fix ultra-wide single-row fan: regroup nine phases into two LR subgraph rows under the RM hub; add nodeSpacing/rankSpacing and curve:linear.
- **togaf-adm-phase-flow.png** (Mermaid) - Redesign: drop the nine RM spokes and show only the P->H horizontal phase spine (or use the &-fan TB hub variant) to fix the staircase drift and edge tangle.
- **togaf-content-hierarchy.png** (Mermaid) - Remove the duplicate 'Architecture Repository' inner node (use subgraph as container); add direction TB inside the Content subgraph; apply theme:neutral to calm the yellow subgraph fills.
- **togaf-governance.png** (Mermaid) - Label all three Board edges (or none) for consistency; link Architecture Continuum->Solutions Continuum to remove the orphan gap; apply theme:neutral + curve:linear.
- **mermaid-state.png** (Mermaid) - Re-render to clear the stray phantom rounded box near the initial node (choice/back-edge dagre artifact); add direction TB if it persists.
- **mermaid-gantt.png** (Mermaid) - Add 'tickInterval 1week' (keep axisFormat %m/%d) to fix the collided/unreadable daily x-axis labels; optionally widen render.
- **mermaid-c4-context.png** (Mermaid) - Fix mojibake title ('â€"' for em-dash): render .mmd as UTF-8 or replace the em-dash with a plain hyphen in the title.

_Plus 22 diagrams graded correct as-is (no regeneration needed)._
