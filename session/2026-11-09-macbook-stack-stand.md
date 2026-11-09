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
  prints mesh info. `SCAD_ARGS` passes OpenSCAD overrides.
- First version: 7 mm channel depth, 60 mm long, 23 x 49.5 x 60 mm,
  24.2 cm3.
- Second version: channel depth (`engage`) 15 mm and `length` 68 mm
  (60 mm of full channel plus two 4 mm lead-ins). 31 x 49.5 x 68 mm,
  36.8 cm3.
- Current version: `length` 100 mm, shelves and top lip full depth
  only over 12 mm at each rail end (`pad_len`), cut back to a 1 mm rib
  (`stub`) in between with 45 degree transitions. 31 x 49.5 x 100 mm,
  39.5 cm3, about 49 g PLA solid each. Screw holes at 15 and 85 mm.
- Intake slot measured: starts 24 mm from the back edge, 105 mm long
  (24 to 129 mm). Rail placed 80 to 180 mm from the back edge; about
  75% of the slot length stays fully open.
- `make macbook-stand-fit` and `part = "fit"`: 10 mm slice of the bare
  profile in its own file. `part = "plan"` and
  `out/macbook-stack-stand-plan.png`: view from below with the slots.
- Two screw holes in the outward foot for fixing a stand to the desk:
  15 mm from each rail end (first cut: 20 mm), 4.5 mm hole, 90 degree countersink, 8.5 mm
  head pocket, for 4 mm countersunk wood screws. `screw_n = 0` removes
  them. Foot tip thickened from 2.5 to 4 mm to hold the head pocket.
- Verified: watertight, one body; channel heights 16.0 mm and channel
  depth 15.0 mm measured from sections; both hole axes free, 4.50 and
  8.50 mm diameters measured; the only overhang is the top of the two
  horizontal screw holes.
- Printability recorded in specs/printability.md.
- The `-D length=10` fit-test recipe is retired: it failed on the
  screw hole assertion once the holes were added, and it overwrote the
  stand STL.

## Decisions

- Side rails that wrap the laptop edges, placed in front of the ports.
- 100 mm rail carrying at its two ends: steadier front to back than
  the 68 mm rail, and the window between the pads leaves the intake
  slot open. 45 degree transitions so the upper pads print without
  supports; same slope at both ends so left and right stands are the
  same part.
- Channel depth 15 mm for a deeper hold on the laptop edges. The first
  version used 7 mm to stay outside the rubber feet; at 15 mm the
  shelves reach the band where the feet are expected, so a laptop may
  not slide through lengthwise. The stands go on from the sides.
- Middle shelf is 9.5 mm so the laptops rest exactly 10 mm apart with
  0.5 mm channel clearance.
- Screw holes go in the outward foot, not under the laptop: reachable
  with the laptops in place and no screw head under a laptop.
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
  than 15 mm to the side edge. Stands screwed to the desk cannot be
  fitted from the sides, so with screws this is no longer optional.
- Screw size (4 mm countersunk) is assumed.
- The rail starts 80 mm from the back edge on the assumption that the
  ports end at about 74 mm; unmeasured.
- Cooling with the remaining slot opening is untested under load.
- The two rails are not joined; a tie bar under the lower laptop or
  rubber pads under the base are possible follow-ups if they creep.

## Files touched

Makefile, scripts/macbook_stack_stand.scad, specs/macbook-stack-stand.md,
specs/README.md, specs/printability.md, todo/todo.md, this note.

## How to run

- `make macbook-stand`                              build STL and previews
- `make macbook-stand-fit`                           fit-test slice
- `make printcheck MODEL=out/macbook-stack-stand.stl`
- `make check`

## Next step

Measure the feet inset and the last port position, print the fit test
(`make macbook-stand-fit`), adjust `clearance` and `rail_from_back`,
decide on the feet relief, then print two full stands.

## Security Note

The part is generated from local source; no external model is read and
no secrets are needed. The stands carry two laptops on 15 mm shelves and
are not joined to each other: check the fit with the test piece first
and keep them snug against the laptop sides.
