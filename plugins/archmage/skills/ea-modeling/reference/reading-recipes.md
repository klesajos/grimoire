# EA reading recipes

Repeatable read flows for exploring an existing repository. All tools are read-only (no
`-enableEdit` needed). Tool reference: `ea-mcp`'s `tool-catalog-read.md`.

Tool names in the recipe blocks below are written **bare** (`get_root_packages`); every one is the
EA MCP tool `enterprise-architect:get_root_packages`. In prose they are qualified. The full
tool-name convention (and the invokable `mcp__enterprise-architect__<tool>` form) lives in
`${CLAUDE_PLUGIN_ROOT}/shared/reference/ea-type-cheatsheet.md`.

## Contents
- [Recipe: orient in an unfamiliar model](#recipe-orient-in-an-unfamiliar-model)
- [Recipe: summarise a package/subsystem](#recipe-summarise-a-packagesubsystem)
- [Recipe: render a diagram as an image](#recipe-render-a-diagram-as-an-image)
- [Recipe: find where an element is used (impact)](#recipe-find-where-an-element-is-used-impact)
- [Recipe: extract an element's linked document](#recipe-extract-an-elements-linked-document)
- [Recipe: read a model the user is pointing at in EA](#recipe-read-a-model-the-user-is-pointing-at-in-ea)

## Recipe: orient in an unfamiliar model

```
get_root_packages                          # the model roots
  → get_packages_information(rootId)         # child packages + contained elements
  → repeat down the tree to map the structure
```
Report the package hierarchy and where the interesting content lives before drilling in.

## Recipe: summarise a package/subsystem

```
get_packages_information(pkgId)            # elements + sub-packages
  → get_diagrams_information(pkgId)          # the views in this package
  → get_diagram_image(eachDiagramId)         # render the key ones to actually see them
  → get_elements_information([elementIds])   # attributes, operations, stereotypes, tagged values, notes
  → get_connectors_information([connIds])    # how the elements relate
```
Then write the summary from the rendered diagrams + element detail — don't summarise from names alone.

## Recipe: render a diagram as an image

```
get_diagrams_information                    # get the diagramID (by package), or
find_element_in_diagrams(elementId)         # the diagrams a known element appears on
  → get_diagram_image(diagramId)             # returns a PNG
```
Use this whenever the user asks "show me / what does X look like". Rendering is also the
verification step after any build.

## Recipe: find where an element is used (impact)

```
find_elements_by_name("Order")             # resolve the element ID
  → find_element_in_diagrams(elementId)      # every diagram it appears on
  → get_connectors_information(...)          # its relationships
```
Good for "what depends on this?" / "is it safe to change this?" questions.

## Recipe: extract an element's linked document

```
find_elements_by_name(...)                 # resolve the element ID
  → export_element_linked_documents(elementId)   # pull its rich-text linked document
```

## Recipe: read a model the user is pointing at in EA

When the user says "this" (they have something selected in EA):
```
get_current_package        # the selected package
get_current_elements       # the selected element(s)
get_current_diagram        # the active diagram
get_opened_diagrams        # what's open
```
Start from the current selection rather than guessing IDs.
