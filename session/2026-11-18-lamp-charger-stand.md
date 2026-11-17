# 2026-11-18 lamp charger stand

New part: a bridge that carries a Belkin BoostCharge Pro 3-in-1 stand
above the base of an IKEA NYMANE work lamp, so the Qi pad in the lamp
base stays free.

## Done

- `scripts/lamp_charger_stand.scad`: 139 x 139 x 5 mm plate on two
  6 mm walls, 32 mm free height, 127 mm wide tunnel open at both
  ends, 45 degree gussets. Previews with lamp, bracket, phone and
  Belkin. Geometry in specs/lamp-charger-stand.md.
- `make lamp-stand` builds `out/lamp-charger-stand.stl` and four
  previews; `make lamp-stand-save` copies the STL to `models/`.
- `models/lamp-charger-stand.stl` saved: watertight, 145.2 cm3, no
  overhang when printed top face down.
- `make check` passes.

## Decisions

- Walls stand on the lamp base, not on the desk: a bridge over the
  220 mm base does not fit a 220 mm bed in one piece.
- Two walls and a tunnel instead of legs: a phone is longer than the
  bridge and passes through.
- Square plate with the walls at its edges, so the feet are about as
  far apart as the Belkin base is wide and the bridge does not tip
  when a phone is pushed onto the magnet.
- No rim around the Belkin and no locating feature on the lamp: the
  plate prints flat on the bed, and the bracket position is only an
  estimate.
- Placed 11.5 mm in front of the lamp centre to clear the arm
  bracket (derived from `bracket_r`).

## Open

- Not printed. Lamp and Belkin numbers are photo readings, +-3 mm;
  `bracket_r` (60) is the weakest.
- Both chargers working with the bridge in place is untested (foreign
  object detection of the lamp pad, heat under the plate).
- The RM10 parts are still not committed (see the 2026-11-15 note).

## Files touched

- scripts/lamp_charger_stand.scad (new)
- models/lamp-charger-stand.stl (new)
- Makefile (lamp-stand, lamp-stand-save)
- specs/lamp-charger-stand.md (new), specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make lamp-stand` and look at out/lamp-charger-stand-*.png
- `make printcheck MODEL=out/lamp-charger-stand.stl`

## Next step

Measure on the lamp: centre of the pad to the arm bracket, width of
the flat top, diameter of the Belkin base. Rebuild with
`make lamp-stand-save SCAD_ARGS='-D bracket_r=...'`, print, test.

## Security Note

No secrets in this work. Two wireless chargers are stacked: keep
metal objects out of the tunnel and watch the temperature in the
first days.
