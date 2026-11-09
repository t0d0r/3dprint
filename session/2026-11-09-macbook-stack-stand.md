# 2026-11-09 MacBook stacking stand

Continues session/2026-11-08-drawer-swap.md. New, unrelated part.

## Done

- `scripts/macbook_stack_stand.scad`: parametric side rail with an
  E-shaped profile that holds two closed MacBook Pro 14" (M4) laptops,
  the lower 5 mm above the desk and the upper 10 mm above the lower.
  Two identical rails are used, at the middle of the left and right
  sides. Geometry and reasons in specs/macbook-stack-stand.md.
- `make macbook-stand`: exports `out/macbook-stack-stand.stl`, renders
  an assembly view and a cut-away section with the laptops in place,
  prints mesh info. `SCAD_ARGS` passes OpenSCAD overrides, for example
  `-D length=10` for a fit-test slice.
- First version: 7 mm channel depth, 60 mm long, 23 x 49.5 x 60 mm,
  24.2 cm3.
- Current version: channel depth (`engage`) 15 mm and `length` 68 mm
  (60 mm of full channel plus two 4 mm lead-ins). 31 x 49.5 x 68 mm,
  36.8 cm3, about 46 g PLA solid each.
- Verified: watertight, one body; channel heights 16.0 mm and channel
  depth 15.0 mm measured from sections; zero overhangs as modelled.
- Printability recorded in specs/printability.md.
- Fit-test command corrected to `-D length=10 -D flare=0`: with the
  lead-ins on, a 10 mm slice has the real channel height over 2 mm only.

## Decisions

- Side rails that wrap the laptop edges, placed at mid depth, clear of
  the ports.
- Channel depth 15 mm for a deeper hold on the laptop edges. The first
  version used 7 mm to stay outside the rubber feet; at 15 mm the
  shelves reach the band where the feet are expected, so a laptop may
  not slide through lengthwise. The stands go on from the sides.
- Middle shelf is 9.5 mm so the laptops rest exactly 10 mm apart with
  0.5 mm channel clearance.
- Print orientation is the modelled one: profile on the bed.
- The section preview uses `--render`: the OpenCSG preview painted every
  cut face in one colour.
- STL stays in `out/` (build product), unlike the drawer STL.

## Open

- Laptop thickness, feet inset and side vent position are taken from
  published numbers and general knowledge, not measured on the actual
  machines. Measure, then print the 10 mm fit test.
- Rubber feet against the 15 mm shelves: a relief in the bottom and
  middle shelves is the likely fix if the feet turn out to be closer
  than 15 mm to the side edge.
- 68 mm rails end about 77 mm from the back edge; the margin to the
  last port on each side is a few millimetres and unmeasured.
- The two rails are not joined; a tie bar under the lower laptop or
  rubber pads under the base are possible follow-ups if they creep.

## Files touched

Makefile, scripts/macbook_stack_stand.scad, specs/macbook-stack-stand.md,
specs/README.md, specs/printability.md, todo/todo.md, this note.

## How to run

- `make macbook-stand`                              build STL and previews
- `make macbook-stand SCAD_ARGS="-D length=10 -D flare=0"`   fit-test slice
- `make printcheck MODEL=out/macbook-stack-stand.stl`
- `make check`

## Next step

Measure the laptop (feet inset first), print the fit test, adjust
`clearance`, decide on the feet relief, then print two full stands.

## Security Note

The part is generated from local source; no external model is read and
no secrets are needed. The stands carry two laptops on 15 mm shelves and
are not joined to each other: check the fit with the test piece first
and keep them snug against the laptop sides.
