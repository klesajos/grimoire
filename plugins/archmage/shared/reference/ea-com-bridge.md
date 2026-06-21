# EA via COM — the display + export the MCP can't do

The `enterprise-architect` MCP builds the **model** (packages, elements, attributes, connectors,
diagrams) but it cannot set several **display** properties and cannot save a diagram image to disk.
The result: MCP-built diagrams render notation-**incomplete** — associations with no navigability
arrow; dependency / realization / serving connectors drawn **headless**; hollow (never filled)
composite diamonds; **invisible** initial/final nodes; no swimlanes.

Everything the MCP can't do, EA's **COM automation API** can — driven from **Windows PowerShell 5.1**
(.NET Framework, so `GetActiveObject` exists). Pattern: **build the model with the MCP, then finish the
rendering and export the PNG via COM.** Every recipe below is **confirmed** against live EA (the 32-bit
EA build under ARM64 emulation). This is the mechanism archmage's image pipeline uses to ship
notation-complete EA PNGs.

> Scope: this is *finishing* and *export* tooling, run from a shell — it is **not** an MCP tool and not
> something Claude invokes through the conduit. The MCP remains the right tool to **build** the model.

## Connect

```powershell
$ea   = [System.Runtime.InteropServices.Marshal]::GetActiveObject("EA.App")
$repo = $ea.Repository                 # the currently open project
$prj  = $repo.GetProjectInterface()
```

Works cross-bitness (ARM64 PowerShell ↔ the emulated 32-bit EA — an out-of-process COM server). EA must
be running with the repository open. Introspect any returned COM object with
`Get-Member -InputObject $obj` to find its real property names.

## Export a diagram to a real PNG

```powershell
$repo.ReloadDiagram($diaId)            # pick up any MCP edits first
$repo.OpenDiagram($diaId); $repo.ActivateDiagram($diaId)
$prj.SaveDiagramImageToFile("C:\...\out.png")   # extension-driven -> real PNG (sig 89 50 4E 47)
```

**Do NOT** use `PutDiagramImageToFile($guid,$path,0)` for PNG — it ignores the `.png` extension and
writes an **EMF** (sig `01 00 00 00`), which the image API can't read.

## Navigability arrows on associations

The MCP leaves `direction:"unspecified"` → a plain line with no arrowhead (and it *rejects* the string
`"Source -> Destination"`). Set it via COM so the arrow points at the target:

```powershell
$c = $repo.GetConnectorByID($id)
$c.ClientEnd.Navigable   = "Unspecified"; $c.ClientEnd.Update()    # reset FIRST
$c.SupplierEnd.Navigable = "Unspecified"; $c.SupplierEnd.Update()
$c = $repo.GetConnectorByID($id); $c.Direction = "Source -> Destination"; $c.Update()
```

Order matters: if you set `Navigable` **after** `Direction`, EA re-derives and **inverts** the
direction. `ClientID`/`SupplierID` are reliable (source→target); the `ClientEnd`/`SupplierEnd` objects
can flip on update, so trust the IDs.

## Headless connectors → show their heads

**Dependency, Realization, Extension, and ArchiMate Serving** render as plain lines (no open arrow / no
hollow triangle) when `direction` is unspecified — which is how the MCP always creates them. Same fix:

```powershell
$c = $repo.GetConnectorByID($id); $c.Direction = "Source -> Destination"; $c.Update()
```

This makes «include» / «extend» / «deploy» Dependencies, component Realizations, profile «Extension», and
ArchiMate Serving draw their proper heads. (Generalization triangles, ArchiMate Assignment, and ArchiMate
Realization heads are intrinsic and don't need it.)

## Composite (filled) diamond

The MCP can only make a hollow/shared `Aggregation`. Promote it to composition by setting the **whole**
(aggregate) end to composite:

```powershell
$c = $repo.GetConnectorByID($id)
$c.SupplierEnd.Aggregation = 2          # 2 = composite (filled), 1 = shared (hollow), 0 = none
$c.SupplierEnd.Update(); $c.Update()
```

Set it on whichever of `ClientEnd`/`SupplierEnd` is attached to the aggregate — verify with
`$repo.GetElementByID($c.SupplierID).Name`. (This resolves the old "filled diamond is GUI-only"
limitation.)

## Initial / final nodes (state machine **and** activity)

The MCP creates initial/final as `StateNode` with **`Subtype = 0` → they render INVISIBLY** (transitions
point at empty space). Fix the kind:

```powershell
$e = $repo.GetElementByID($id); $e.Subtype = 100; $e.Name = ""; $e.Update()   # 100 = initial (filled circle)
# Subtype = 101 for the final node (bullseye)
```

Also: `place_elements_on_diagram` (MCP) silently **no-ops** for these pseudostates — add them to the
diagram via COM:

```powershell
$dia = $repo.GetDiagramByID($diaId)
$o = $dia.DiagramObjects.AddNew("l=80;r=110;t=-70;b=-100;",""); $o.ElementID = $elemId; $o.Update()
```

EA diagram Y is **negative** (top less-negative than bottom; e.g. a box from y70..100 is `t=-70;b=-100`).

## Swimlanes / activity partitions

Do **NOT** place `ActivityPartition` elements as separate boxes — EA draws them as cluttered overlapping
bands with cramped vertical edge-labels, not real lanes. Use the diagram's native **Swimlanes**:

```powershell
$sld = $dia.SwimlaneDef
$sld.Swimlanes.DeleteAll()
$l = $sld.Swimlanes.Add("Customer", 0); $l.width = 200    # one per lane; .width is lowercase
$sld.Swimlanes.Add("Sales", 0).width     = 290
$sld.Swimlanes.Add("Warehouse", 0).width = 220
$sld.Orientation = 0                                       # 0 = vertical lanes (columns)
$dia.Update()
```

Renders clean vertical lanes with horizontal headers; then position the action nodes into each lane's
x-range. `Diagram.SwimlaneDef` is **read-only** (`$dia.SwimlaneDef = $x` throws "Unable to write
read-only property") — mutate the returned object in place and call `$dia.Update()`.

## Connector routing

Set clean right-angle routing with the MCP (`create_or_update_connectors` →
`connectorStyle:"OrthogonalSquare"`). EA's router minimizes bends, so a connector to a target that is
below-and-in-another-lane always does a **side-entering L** — you **cannot** force a top-entering route
across a lane (manual `DiagramLink.Geometry`/`Path` waypoints are silently ignored; `Custom` style
collapses the line to a diagonal). So in a top-to-bottom activity/swimlane diagram, **same-lane edges
enter the top; cross-lane edges enter the side-middle** from the source lane's direction — the practical
ceiling, and the conventional swimlane look. (Top-entry across a lane needs manual dragging in the EA
GUI.)

## Gotchas

- `Repository.SQLQuery` is **pathologically slow** under ARM64 emulation (minutes; often auto-backgrounded).
  Use `GetElementByID` / `GetConnectorByID` / `GetDiagramByID` instead.
- Keep PowerShell `git commit` messages **free of double quotes** (PS 5.1 here-string quoting splits the arg).
- **BPMN is out of scope for COM too.** A BPMN *diagram* type is settable (`Diagrams.AddNew(name,
  "BPMN2.0::BusinessProcess")` sets `MetaType`), but BPMN *element* stereotypes **revert** — setting
  `Stereotype`/`StereotypeEx` to `"BPMN2.0::Activity"` falls back to a plain `Activity`. Real BPMN
  elements still need EA's GUI toolbox (see the `bpmn` skill).

## Full recipe — polish + export one diagram

```powershell
$ea=[Runtime.InteropServices.Marshal]::GetActiveObject("EA.App"); $repo=$ea.Repository
# 1. navigability arrows on associations + heads on dependency/realization/serving
foreach($id in $arrowConnIds){ $c=$repo.GetConnectorByID($id); $c.Direction="Source -> Destination"; $c.Update() }
# 2. filled composite diamond (set on the aggregate end)
$c=$repo.GetConnectorByID($aggId); $c.SupplierEnd.Aggregation=2; $c.SupplierEnd.Update(); $c.Update()
# 3. make initial/final nodes visible (state machine + activity)
foreach($p in @(@($initId,100),@($finalId,101))){ $e=$repo.GetElementByID($p[0]); $e.Subtype=$p[1]; $e.Name=""; $e.Update() }
# 4. reload + export to a real PNG
$repo.ReloadDiagram($diaId); $repo.OpenDiagram($diaId)|Out-Null; $repo.ActivateDiagram($diaId)|Out-Null
$repo.GetProjectInterface().SaveDiagramImageToFile($outPng)
```
