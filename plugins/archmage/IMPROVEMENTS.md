# archmage — review backlog

Output of a **40-agent review + test pass** over the `archmage` plugin (20 partitioned
review-and-fix agents → 20 read-only skill-trial agents → synthesis). Straightforward fixes were
applied in-place during the review (commit `0a0d279`); the remaining improvements are tracked as
GitHub issues below. This file is the index.

## Already resolved in this pass
- **Generate missing rendered PNGs** for authored render markers (bpmn approximations, `ea-build-steps`) — re-rendered; image health verified (no broken links, no marker without a PNG).
- **Remove stale render markers** from the 3 GitHub-native (no-PNG) class diagrams — all three cleaned.
- The 20-agent fix phase also flipped the confirmed **ArchiMate MDG strings** (`ArchiMate3::ArchiMate_*`) from "verify in live EA", corrected UML 2.5.1 collection-kind semantics, and confirmed EA type strings (Realization, Object, Part, Composite Structure, Device, Artifact, …) across ~28 files.

## Open improvements (filed as issues)

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
*Generated 2026-06-16 from a multi-agent review of `plugins/archmage`. The fix phase landed in commit `0a0d279`; the 19 open items above are filed as issues #3–#21.*
