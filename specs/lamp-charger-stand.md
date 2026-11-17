# Lamp charger stand

Bridge that carries a Belkin BoostCharge Pro 3-in-1 wireless charging
stand (WIZ017) above the base of an IKEA NYMANE work lamp (type
A2001), which has a Qi pad in the middle of its base. Source:
`scripts/lamp_charger_stand.scad`. Build: `make lamp-stand`;
`make lamp-stand-save` copies the STL to `models/`.

## Requirement

- The Belkin stand and the lamp share one spot on the desk, one above
  the other.
- The Qi pad of the lamp stays usable: a phone or an earbud case can
  be laid on it and taken off with the Belkin in place.
- No change to the lamp or to the Belkin; removable.
- One piece, fits a 220 x 220 mm bed, no supports.

## Source measurements

Read from photos with a steel ruler laid across the parts. Reading
error about +-3 mm; `bracket_r` is worse, it is estimated from a
photo taken from above.

| parameter   | value | what                                              |
|-------------|-------|---------------------------------------------------|
| `lamp_d`    | 220   | diameter of the lamp base                         |
| `pad_d`     | 80    | Qi pad, a flush disc in the middle of the base    |
| `bracket_r` | 60    | lamp centre to the near face of the arm bracket   |
| `belkin_d`  | 135   | diameter of the Belkin base                       |
| `phone_w`   | 82    | widest device for the pad, in its case (assumed)  |

The top of the lamp base is flat from the pad out to a rounded edge
(`lamp_edge`, 8 mm allowed). The arm bracket stands on the base near
its rim and is taller than the bridge. The Belkin base has a soft
non-slip underside; its cable leaves at the edge of the base.

## Geometry

Frame: X along the tunnel, Y across it, Z up, top of the lamp base at
Z = 0.

- Plate: 139 x 139 mm (`belkin_d` + 2 x `margin`), 5 mm thick, 20 mm
  corner radius. The Belkin stands on it, 2 mm inside the edge.
- Two walls, 6 mm thick, 32 mm tall (`clear_h`), along the two edges
  of the plate at +-Y. They stand on the lamp base, one each side of
  the pad.
- Tunnel between the walls: 127 mm wide, 32 mm high, open at both
  ends. A 6 mm gusset at 45 degrees joins each wall to the plate.
- Overall 139 x 139 x 37 mm, 145 cm3.

Placement: the part is symmetric and loose. With the lamp arm at the
back it stands 11.5 mm in front of the lamp centre (`stand_off`,
derived) so that the plate clears the bracket by 2 mm. The phone lies
on the pad across the lamp, sticking out of both ends of the tunnel;
it keeps 11 mm to the wall by the bracket. The wall feet reach 98.6 mm
from the lamp centre, inside the flat top.

The script asserts: plate fits the bed, the device keeps 3 mm to the
wall by the bracket, the feet stay off the rounded edge of the base.

## Decisions

- Walls stand on the lamp base, not on the desk: a bridge over the
  whole 220 mm base does not fit the bed in one piece.
- Two walls and an open tunnel, not three or four legs: a phone is
  longer than the bridge and has to pass through.
- A square plate with walls at its edges, not a disc on arc walls:
  the feet are 133 mm apart and at least 99 mm long, close to the footprint of
  the Belkin itself, so pushing a phone onto the magnet does not tip
  the bridge.
- No rim around the Belkin: a rim would lift the plate off the bed
  and need supports under all of it. The soft underside of the Belkin
  holds it on the plate.
- Not fixed to the lamp: where the bracket stands is not measured
  well enough for a locating feature, and a loose part can be turned
  to suit the device.
- 32 mm free height: an earbud case lying flat is about 22 mm, a
  phone in a case about 13 mm, plus room for fingers.

## Print notes

- Upside down, top face of the plate on the bed. No supports; the
  gussets narrow upwards.
- PETG preferred: both chargers get warm. PLA works away from the
  sun.
- 3 perimeters, 15 to 20 percent infill, about 60 g.
- Stick thin felt or silicone strips (6 mm wide) under the walls so
  the feet do not scratch the paint and do not slide.

## Limits and open points

- Not printed. `bracket_r`, `belkin_d` and the flat width of the lamp
  top are photo readings; measure them before printing and pass them
  with `SCAD_ARGS`, for example
  `make lamp-stand SCAD_ARGS='-D bracket_r=58 -D clear_h=36'`.
- The Belkin base holds metal and magnets 37 mm above the lamp pad.
  That is far outside Qi range, but the pad's foreign object
  detection with the bridge in place is untested.
- A device on the lamp pad charges under a roof. The tunnel is open
  at both ends; temperature is untested.
- The lamp arm cannot be folded forward over the bridge.

## Security Note

No secrets in this part. Two wireless chargers are stacked: keep
metal objects (keys, coins, cards with chips) out of the tunnel and
off the pad, and check that neither charger nor the print gets hot
in the first days of use.
