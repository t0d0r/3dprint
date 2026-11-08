# 2026-11-08 drawer swap

Continues session/2026-11-08-setup.md.

## Done

- `scripts/section.py` (`make sections`): cross-section plots and
  simplified outlines at the middle of each axis. Used to read the
  drawer geometry: floor at high X, walls down to an open edge at low X,
  rails near the open edge, door at low Z, ramp at high Z.
- `scripts/drawer_swap.py` (`make drawer-swap`): builds
  `models/drawer-20cm-front-slope.stl`, the drawer with the ramp moved to
  the front against the door and a vertical 1.3 mm back wall. Method and
  numbers in specs/drawer-swap.md.
- Front braces added to the swapped drawer (specs/drawer-swap.md): the
  side walls, with their corner round, now run at full height to the
  door and foot on it with a 3 mm stepped fillet. Before, the plate was
  held by the ramp tip and two rounded corners only.
- Output verified: watertight after STL reload, one body, genus 0, same
  outer size, 70.1 cm3. Previews, cut-aways and ray probes of the front
  corners checked; nothing outside the wall planes or above the open
  edge near the door.
- Printability of the new model recorded in specs/printability.md.
- requirements: rtree, shapely, networkx, matplotlib added.

## Decisions

- Mirror the existing body rather than remodel: keeps every detail of
  the original (rounds, rails, fillets) except the two ends.
- Cuts stay off the door face (0.02 mm inside the plate for the door,
  3.5 mm past it for the body): a coplanar cut left a zero-thickness
  sheet, and a cut through the fillet left slivers inside the back wall.
- Final `Manifold.simplify(1e-3)` is required: without it the boolean
  result is watertight in memory but not after the STL float32 round
  trip. The script asserts watertightness on its own reloaded output.
- Back wall clipped flush with the side walls (not the rails).
- Braces are inset 0.1 mm from the wall planes and 0.05 mm from other
  surfaces and clipped to the inside of the wall planes: a first version
  grew a 0.05 mm fin of rail profile along each brace, and the fillet
  steps poked 0.45 mm above the open edge until the footprint used to
  clip them was cut at the open edge.
- Rails stay where the mirrored body puts them (22 mm behind the door
  to 1 mm before the back). The in-place variant was built, verified
  and reverted on request the same day; see specs/drawer-swap.md.

## Open

- The inside of the back wall is a 113 mm bridge when printing on the
  door. Print as bridge, support it, or change the design.
- Real slicer numbers still not recorded.

## Files touched

Makefile, requirements.txt, scripts/section.py, scripts/drawer_swap.py,
models/drawer-20cm-front-slope.stl, specs/drawer-swap.md,
specs/printability.md, specs/toolchain.md, specs/README.md,
todo/todo.md, this note.

## How to run

- `make drawer-swap`   rebuild the swapped drawer
- `make preview MODEL=models/drawer-20cm-front-slope.stl`
- `make sections MODEL=models/drawer-20cm-front-slope.stl`
- `make printcheck MODEL=models/drawer-20cm-front-slope.stl`
- `make check`

## Next step

Decide on the back-wall ceiling, then slice in OrcaSlicer.

## Security Note

Model files are untrusted data read with `python -I`. No secrets are
needed by any target. The STL in models/ is the only output committed.
