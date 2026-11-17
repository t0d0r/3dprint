# 2026-11-18 lamp charger stand

New part: a stand that carries a Belkin BoostCharge Pro 3-in-1 stand
above the base of an IKEA NYMANE work lamp, so the Qi pad in the lamp
base stays free.

## Done

- First version: a square plate on two walls standing on the lamp
  base (commit 70987b3). Replaced by a round cone with a kumiko
  relief (commit c211104), then by the slanted cone below.
- `scripts/lamp_charger_stand.scad`: slanted truncated cone. Skirt
  over the rim of the lamp base (216 mm outside for the measured
  210 mm base), wall up to a 150 mm plate 65 mm above the lamp top.
  The plate is 33 mm in front of the lamp axis, its front edge above
  the front of the skirt, its rear edge 42 mm behind the axis.
- Two 92 mm openings opposite each other: rear for the arm bracket,
  front as the door. Asanoha relief on the wall, 42 triangles round,
  6 rows. Geometry in specs/lamp-charger-stand.md.
- Three pieces in two STLs: `lamp-charger-stand-sides.stl` (both side
  walls) and `lamp-charger-stand-top.stl` (plate with lip and tabs).
- `make lamp-stand` builds both STLs and six previews;
  `make lamp-stand-save` copies the STLs to `models/`.
- Both STLs watertight, both fit a 220 mm bed, no supports.
- `make check` passes.

## Decisions

- Cone gripping the rim of the lamp base instead of a bridge standing
  on it: round, and it centres itself on the rounded edge.
- Slanted cone, plate forward: the lamp arm swings forward and back;
  the plate ends in front of the arm bracket and needs no notch.
- Door at the front, opposite the lamp arm. With the rear opening it
  splits the cone into two side walls; the plate joins them.
- Plate 150 mm: the smallest that keeps the wall ends beside the rear
  opening within 45 degrees of the vertical.
- The pattern is a relief on a 1.2 mm skin. An open lattice on a
  leaning wall needs supports under every bar.
- Rows shrink by a constant ratio with the radius; on the slanted
  cone the triangles are true on the sides and stretched at the rear.
- Mesh fixes: bars 0.02 mm proud of the wall, pattern turned 0.7
  degrees, skirt and cone as one convex body, cone sections cut from
  a longer cone. Each removed a source of non-manifold edges.

## Open

- Not printed. The skirt fit (0.6 mm of air) is untested.
- `bracket_r` (60) is a photo estimate. With the door facing the
  bracket, a phone centred on the pad reaches 83 mm back; whether it
  passes the bracket is not known.
- The forward swing of the arm against the rear edge of the plate is
  not measured.
- The plate lies loose on the walls; glue is recommended after the
  fit test.
- Both chargers working with the stand in place is untested.
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

Print the side walls and try them on the rim of the lamp base. If the
skirt is loose or tight, rebuild with
`make lamp-stand-save SCAD_ARGS='-D lamp_clr=...'`. Then print the
plate.

## Security Note

No secrets in this work. Two wireless chargers are stacked: keep
metal objects out of the cone and watch the temperature in the first
days.
