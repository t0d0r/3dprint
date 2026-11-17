# 2026-11-18 lamp charger stand

New part: a stand that carries a Belkin BoostCharge Pro 3-in-1 stand
above the base of an IKEA NYMANE work lamp, so the Qi pad in the lamp
base stays free.

## Done

- First version: a square plate on two walls standing on the lamp
  base (commit 70987b3). Replaced the same day by the round version
  below.
- `scripts/lamp_charger_stand.scad`: truncated cone with a skirt over
  the rim of the lamp base (226 mm outside), narrowing to a 162 mm
  plate 34 mm above the lamp top. Two 92 mm openings opposite each
  other: rear for the arm bracket, front as the door. Asanoha relief
  on the wall, 45 triangles round, 3 rows. Geometry in
  specs/lamp-charger-stand.md.
- Three pieces in two STLs: `lamp-charger-stand-sides.stl` (both side
  walls) and `lamp-charger-stand-top.stl` (plate with lip and tabs).
- `make lamp-stand` builds both STLs and six previews;
  `make lamp-stand-save` copies the STLs to `models/`.
- Both STLs watertight, both fit a 220 mm bed, no supports.
- `make check` passes.

## Decisions

- Cone gripping the rim of the lamp base instead of a bridge standing
  on it: round, and it centres itself on the rounded edge.
- Door at the front, opposite the lamp arm. With the rear opening it
  splits the cone into two side walls; the plate joins them. A ring
  in one piece would be 226 mm and not fit the bed.
- The pattern is a relief on a 1.2 mm skin. An open lattice on a
  leaning wall needs supports under every bar.
- The triangle grid is regular in (log radius, angle) on the unrolled
  cone, so the triangles keep their shape and shrink towards the top.
- Bars 0.02 mm proud of the wall and the pattern turned 0.7 degrees:
  bar faces lying in the wall surface, or bars along a facet edge,
  gave non-manifold edges in the STL.

## Open

- Not printed. `lamp_d` sets the skirt fit and is a ruler reading.
- `bracket_r` (60) is the weakest number. With the door facing the
  bracket, a phone centred on the pad reaches 83 mm back; whether it
  passes the bracket is not known.
- Both chargers working with the stand in place is untested (foreign
  object detection of the lamp pad, heat under the plate).
- The RM10 parts are still not committed (see the 2026-11-15 note).

## Files touched

- scripts/lamp_charger_stand.scad
- models/lamp-charger-stand-sides.stl, -top.stl (new);
  models/lamp-charger-stand.stl (removed)
- Makefile (lamp-stand, lamp-stand-save)
- specs/lamp-charger-stand.md, specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make lamp-stand` and look at out/lamp-charger-stand-*.png
- `make printcheck MODEL=out/lamp-charger-stand-sides.stl`

## Next step

Measure the lamp base with calipers and the position of the arm
bracket, rebuild with `make lamp-stand-save SCAD_ARGS='-D lamp_d=...
-D bracket_r=...'`, print the side walls first and try them on the
rim.

## Security Note

No secrets in this work. Two wireless chargers are stacked: keep
metal objects out of the cone and watch the temperature in the first
days.
