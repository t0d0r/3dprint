# Lamp charger stand

Round stand that carries a Belkin BoostCharge Pro 3-in-1 wireless
charging stand (WIZ017) above the base of an IKEA NYMANE work lamp
(type A2001), which has a Qi pad in the middle of its base. Source:
`scripts/lamp_charger_stand.scad`. Build: `make lamp-stand`;
`make lamp-stand-save` copies both STLs to `models/`.

## Requirement

- The Belkin stand and the lamp share one spot on the desk, one above
  the other.
- The Qi pad of the lamp stays usable with the Belkin in place.
- Round. The stand grips the rim of the lamp base and narrows as a
  truncated cone to the plate under the Belkin.
- The wall carries a kumiko pattern.
- The door for the device on the pad is at the front, opposite the
  lamp arm.
- No change to the lamp or to the Belkin; removable.
- Every piece fits a 220 x 220 mm bed, no supports.

## Source measurements

Read from photos with a steel ruler laid across the parts. Reading
error about +-3 mm; `bracket_r` is worse, it is estimated from a
photo taken from above.

| parameter   | value | what                                              |
|-------------|-------|---------------------------------------------------|
| `lamp_d`    | 220   | diameter of the lamp base                         |
| `pad_d`     | 80    | Qi pad, a flush disc in the middle of the base    |
| `bracket_r` | 60    | lamp axis to the near face of the arm bracket     |
| `bracket_w` | 50    | width of the arm bracket                          |
| `belkin_d`  | 135   | diameter of the Belkin base                       |
| `phone_w`   | 82    | widest device for the pad, in its case (assumed)  |

The arm bracket stands on the base near its rim and is taller than
the stand. The top edge of the lamp base is rounded. The Belkin base
has a soft non-slip underside; its cable leaves at the edge of the
base.

## Geometry

Frame: origin on the lamp axis, Z up, top of the lamp base at Z = 0,
lamp arm at +Y, door at -Y.

Cone:

- Skirt: 226 mm outside, 2.4 mm wall, 8 mm down the side of the lamp
  base, 0.6 mm of air on the radius.
- Wall: from the skirt at Z = 0 to 162 mm diameter (`top_d`) at
  Z = 34 (`clear_h`), 2.4 mm thick measured level, 46.7 degrees above
  the level. Its inside rests on the rounded top edge of the lamp
  base, so the stand centres itself; depending on the radius of that
  edge it sits 1 to 3 mm lower than drawn.
- Two openings 92 mm wide (`open_w`) and as tall as the wall,
  opposite each other: the rear one for the arm bracket, the front
  one is the door. They leave two side walls, each 132 degrees of
  the circle at the skirt.

Plate:

- Disc of 162 mm, 5 mm thick, on top of the two side walls; its
  underside is 34 mm above the lamp top.
- Lip under it, 3 mm deep, inside the tops of the walls with 0.3 mm
  of air. It keeps the walls from leaning in.
- Tabs under it in the tops of both openings, as thick as the wall,
  0.3 mm from the wall ends. They keep the walls from sliding round
  the lamp.
- Notch 56 x 23 mm at the rear for the arm bracket.
- The Belkin stands 9.5 mm in front of the lamp axis (`stand_off`,
  derived) and clears the bracket by 2 mm; the plate reaches 4 mm
  beyond it at the front.

Distance between the two platforms: 34 mm from the top of the lamp
base to the underside of the plate, 39 mm to the surface the Belkin
stands on, less the 1 to 3 mm the cone settles on the rounded edge.

## Pattern

Asanoha (hemp leaf): a grid of triangles, each with three thin bars
from its centre to its corners. 45 triangles round the circle
(`n_around`), 3 rows (`rows`), between a 4 mm band at the bottom and
a 4.5 mm band at the top, with 3 mm plain bands beside the openings.

On the unrolled cone the grid is regular in (log of the distance from
the apex, angle). That map keeps angles, so every triangle has the
shape of an equilateral one and the triangles shrink towards the top:
side 15.3 mm in the bottom row, 11.9 mm in the top row.

The pattern is a relief, not a lattice: grid bars 1.6 mm and leaf
bars 1.0 mm wide stand 1.2 mm (measured level, 0.9 mm square to the
wall) on a 1.2 mm skin (`skin`).

## Pieces

- `lamp-charger-stand-sides.stl`: both side walls, moved together to
  154 x 206 x 42 mm, 38 cm3.
- `lamp-charger-stand-top.stl`: the plate, 162 x 163 x 8 mm, 103 cm3.

## Decisions

- Three pieces: a ring round a 220 mm base is 226 mm across and does
  not fit a 220 mm bed. The two openings split the cone into two
  walls anyway; the plate joins them.
- Relief on a skin instead of an open lattice: a lattice of this
  pattern on a leaning wall has bars 20 to 30 degrees from the bed
  and needs supports under every bar.
- Skin 1.2 mm level: three 0.4 mm lines in each layer.
- Wall 46.7 degrees above the level: the side walls print as they
  stand, leaning in, without supports. `clear_h` and `top_d` set the
  angle; the script refuses less than 45 degrees.
- The plate is a separate flat piece, so it prints on its top face
  and the walls print with the pattern upwards.
- No rim round the Belkin: the plate prints top face down. The soft
  underside of the Belkin holds it.
- Rear opening as wide as the door: one number, a symmetric part,
  and room for the arm bracket whatever its exact width.
- The bars stand 0.02 mm proud of the bands (`proud`) and the pattern
  is turned 0.7 degrees (`phase`): with bar faces in the wall surface
  or bars along a facet edge the STL had edges shared by four or six
  faces.

## Print notes

- Side walls: as exported, skirt on the bed, pattern outwards. No
  supports. The bed contact is a 2.4 mm strip: use a brim. 3
  perimeters.
- Plate: as exported, top face on the bed, lip and tabs up. No
  supports.
- PETG preferred: both chargers get warm. PLA works away from the
  sun.
- About 17 g for the walls and 45 g for the plate at 20 percent
  infill.

## Limits and open points

- Not printed. `lamp_d` sets the fit of the skirt: measure the base
  with calipers first. 0.6 mm of air may be loose or tight.
- `bracket_r`, `bracket_w` and `belkin_d` are photo readings;
  measure them and pass them with `SCAD_ARGS`, for example
  `make lamp-stand SCAD_ARGS='-D lamp_d=219.5 -D bracket_r=58'`.
- The door faces the arm bracket. A 166 mm phone centred on the pad
  reaches 83 mm back from the lamp axis, the bracket is read at
  60 mm: whether a phone passes under or beside the bracket is not
  known. An earbud case fits. A phone can be turned across the lamp
  inside the cone (221 mm inside at the base), but not pushed in that
  way.
- The plate lies loose on the walls. Glue fixes it if wanted.
- The Belkin base holds metal and magnets 39 mm above the lamp pad.
  That is far outside Qi range, but the pad's foreign object
  detection with the stand in place is untested.
- A device on the lamp pad charges under a roof with two openings;
  temperature is untested.
- The lamp arm cannot be folded forward over the stand.

## Security Note

No secrets in this part. Two wireless chargers are stacked: keep
metal objects (keys, coins, cards with chips) out of the cone and
off the pad, and check that neither charger nor the print gets hot
in the first days of use.
