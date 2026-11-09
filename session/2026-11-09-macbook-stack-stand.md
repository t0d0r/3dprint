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
- Verified: watertight, one body, 23 x 49.5 x 60 mm, 24.2 cm3; channel
  heights 16.0 mm measured from sections; zero overhangs as modelled.
- Printability recorded in specs/printability.md.

## Decisions

- Side rails that wrap the laptop edges, placed at mid depth, clear of
  the ports. Shelf reach 7 mm to stay outside the rubber feet.
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
- The two rails are not joined; a tie bar under the lower laptop or
  rubber pads under the base are possible follow-ups if they creep.

## Files touched

Makefile, scripts/macbook_stack_stand.scad, specs/macbook-stack-stand.md,
specs/README.md, specs/printability.md, todo/todo.md, this note.

## How to run

- `make macbook-stand`                              build STL and previews
- `make macbook-stand SCAD_ARGS="-D length=10"`     fit-test slice
- `make printcheck MODEL=out/macbook-stack-stand.stl`
- `make check`

## Next step

Measure the laptop, print the fit test, adjust `clearance` and `engage`,
then print two full stands.

## Security Note

The part is generated from local source; no external model is read and
no secrets are needed. The stands carry two laptops on 7 mm shelves and
are not joined to each other: check the fit with the test piece first
and keep them snug against the laptop sides.
