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
- Output verified: watertight after STL reload, one body, same outer
  size, 68.4 cm3. Previews and sections rendered and checked.
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

## Open

- Rails moved with the mirrored body (now 22 mm behind the door to 1 mm
  before the back; originally 58 mm behind the door to 22 mm before the
  back). Whether that matters depends on the cabinet.
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

Decide on rails and on the back-wall ceiling, then slice in OrcaSlicer.

## Security Note

Model files are untrusted data read with `python -I`. No secrets are
needed by any target. The STL in models/ is the only output committed.
