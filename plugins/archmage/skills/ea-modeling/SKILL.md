---
name: ea-modeling
description: Builds and reads Sparx Enterprise Architect models through the EA MCP. Covers the create-elements then connectors then diagram then place then layout then verify build workflow, exploration/reading recipes, and mapping UML/BPMN/ArchiMate concepts onto EA element, connector, and diagram types. Use when the user wants to create, build, generate, populate, read, explore, explain, or render a model or diagram in Enterprise Architect / Sparx EA, or to turn a UML/BPMN/ArchiMate design into actual EA elements. For connection failures or tool setup, ea-mcp applies instead.
---

# ea-modeling — build & read models in Enterprise Architect

This spell is the **modeller's playbook**: the repeatable workflow for turning an idea (or a
UML/BPMN/ArchiMate design) into real EA elements, and for reading an existing repository back out.
It assumes the conduit is healthy — if it is not (connection/setup/tool errors), use `ea-mcp` first.

## When to use this spell

- "Create / build / generate / populate a model (or a class/sequence/activity/… diagram) **in EA**."
- "Read / explore / explain / summarise / render this EA model or diagram."
- "Turn this UML/BPMN/ArchiMate design into actual EA elements."

For the **notation rules** (what a valid class/sequence/BPMN/ArchiMate diagram *is*), pull the
matching spell: `uml`, `bpmn`, `archimate`, `togaf`, `mermaid`. This spell is the EA *mechanics*;
those are the *grammar*.

## The one workflow to remember

```
create_or_update_package        # parent first → capture packageID
  → create_or_update_elements   # arrays → capture element IDs
  → create_or_update_attributes / create_or_update_operations   # class members
  → create_or_update_connectors # relationships (direction "Unspecified")
  → create_or_update_diagram    # the view (correct `type` string)
  → open_diagrams               # REQUIRED before create_or_update_messages
  → place_elements_on_diagram   # x,y,width,height ; x/y > 10
  → layout_connectors           # auto-route
  → get_diagram_image           # VERIFY — render the PNG and check it
```

**Always finish with `get_diagram_image`.** Building blind is how silent errors (duplicate
messages, missed placements, wrong target package) survive. Render and look.

## Before you write: confirm the target

Two different projects can both have a root package named "Model" with `packageID 1`. Writing into
the wrong one silently retargets everything. **Verify the parent package name + ID with
`enterprise-architect:get_packages_information` before the first create.** Keep exactly one EA
instance open.

## Reference files (open on demand)

| File | Open it when… |
| --- | --- |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-modeling/reference/build-workflow.md` | Building anything — the full step-by-step with payloads and the gotcha list. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-modeling/reference/reading-recipes.md` | Exploring/summarising/extracting from an existing repository. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-modeling/reference/notation-to-ea-mapping.md` | Translating a UML/BPMN/ArchiMate concept into the right EA `type`. |
| `${CLAUDE_PLUGIN_ROOT}/skills/ea-modeling/reference/diagram-type-playbooks.md` | Building a specific diagram kind (class / use case / sequence / activity / state) with its quirks. |

EA **type strings** live once in `${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.
Tool details and troubleshooting live in the `ea-mcp` spell.

## The gotchas that bite during a build (full list in build-workflow.md)

1. `taggedValues` = **array of `{name,value}`**, never a map.
2. Connector `direction: "Source -> Destination"` **fails** → `"Unspecified"`.
3. `create_*` take **arrays**, **return IDs** → parent package first.
4. `place_elements_on_diagram` needs **x/y > 10**.
5. **Sequence messages:** `open_diagrams` first or they silently duplicate.
6. **No delete** for packages/elements → name throwaways `ZZ_*`.
7. No transaction — a timeout leaves a partial model; `create_baseline` before big builds.

## Working safely

- Build **incrementally** and render after each meaningful step.
- For **large** builds, delegate to the `ea-modeller` familiar (subagent) — it owns the
  create→verify loop and the duplicate-message guard, and keeps dozens of tool calls out of the
  main context. Invoke it with the model description; it reports back the created IDs.
- Take a `create_baseline` before edits you might want to undo (there is no element delete).
