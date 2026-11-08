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
- Rails kept at their original position (door face to 22 mm before the
  back): the script now splits them off before mirroring the body, with
  a 0.3 mm bite of wall so they fuse back in, and extends them to the
  door across the fillet zone.
- Output verified: watertight after STL reload, one body, no unfused
  rail faces, genus 2 as expected (see spec), same outer size,
  68.3 cm3. Previews, corner zooms and sections rendered and checked.
- Printability of the new model recorded in specs/printability.md.
- requirements: rtree, shapely, networkx, matplotlib added.

## Decisions

- Mirror the existing body rather than remodel: keeps every detail of
  the original (rounds, rails, fillets) except the two ends.
- Cuts stay off the door face (0.02 mm inside the plate for the door,
  3.5 mm past it for the body): a coplanar cut left a zero-thickness
  sheet, and a cut through the fillet left slivers inside the back wall.
- Rails are split off with 0.3 mm of wall, not on the wall plane: the
  wall faces have 0.03 mm of noise, and a split on the plane left the
  rails a few microns off the wall, unfused, with a stray handle in the
  topology.
- The core is clipped 0.005 mm inside the outermost wall points, so its
  outer faces are flat; costs 0.03 mm of wall at the noisiest spots.
- Final `Manifold.simplify(1e-3)` is required: without it the boolean
  result is watertight in memory but not after the STL float32 round
  trip. The script asserts watertightness on its own reloaded output.
- Genus 2 is accepted and asserted (0 or 2 only): the two handles are
  the open corners between the rails and the rounded ramp tip at the
  door, real geometry that prints as islands merging a few layers up.

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
