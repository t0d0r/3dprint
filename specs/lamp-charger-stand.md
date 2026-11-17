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
- 65 mm between the top of the lamp base and the underside of the
  plate.
- The plate is moved forward until its front edge is above the front
  edge of the lamp base: the lamp arm swings forward and back and
  needs the room behind the plate.
- The wall carries a kumiko pattern.
- The door for the device on the pad is at the front, opposite the
  lamp arm.
- No change to the lamp or to the Belkin; removable.
- Every piece fits a 220 x 220 mm bed, no supports.

## Source measurements

| parameter   | value | what                                            | source   |
|-------------|-------|-------------------------------------------------|----------|
| `lamp_d`    | 210   | diameter of the lamp base                       | measured |
| `belkin_d`  | 137   | diameter of the Belkin base                     | measured |
| `pad_d`     | 80    | Qi pad, a flush disc in the middle of the base  | photo    |
| `bracket_r` | 60    | lamp axis to the near face of the arm bracket   | photo    |
| `bracket_w` | 50    | width of the arm bracket                        | photo    |
| `phone_w`   | 82    | widest device for the pad, in its case          | assumed  |

Photo readings are from a steel ruler laid across the parts, about
+-3 mm; `bracket_r` is worse, it is estimated from a photo taken
from above. The arm bracket stands on the base near its rim. The top
edge of the lamp base is rounded. The Belkin base has a soft non-slip
underside.

## Geometry

Frame: origin on the lamp axis, Z up, top of the lamp base at Z = 0,
lamp arm at +Y, door at -Y.

Cone:

- Skirt: 216 mm outside, 2.4 mm wall, 8 mm down the side of the lamp
  base, 0.6 mm of air on the radius.
- Wall: from the skirt at Z = 0 to a circle of 150 mm (`top_d`) at
  Z = 65 (`clear_h`), 2.4 mm thick measured level. The top circle is
  33 mm in front of the lamp axis (`top_fwd`, derived), so its front
  edge is straight above the front of the skirt.
- Lean of the wall above the level: upright at the front, 63 degrees
  at the sides, 46 degrees at the wall ends beside the rear opening.
- The inside of the wall rests on the rounded top edge of the lamp
  base; depending on the radius of that edge the stand sits 1 to
  3 mm lower than drawn.
- Two openings 92 mm wide (`open_w`) and as tall as the wall,
  opposite each other: the rear one for the arm bracket, the front
  one is the door. They leave two side walls, each 130 degrees of
  the circle at the skirt.

Plate:

- Disc of 150 mm, 5 mm thick, on top of the two side walls. The
  Belkin stands in its middle with 6.5 mm to spare all round.
- Its rear edge is 42 mm behind the lamp axis, 18 mm in front of the
  arm bracket as read; the front edge is 108 mm in front of the axis.
- Lip under it, 5 mm deep, inside the tops of the walls with 0.3 mm
  of air. It keeps the walls from leaning in.
- Tabs under it in the tops of both openings, as thick as the wall,
  0.3 mm from the wall ends. They keep the walls from sliding round
  the lamp.
- A notch for the arm bracket is cut only if the plate reaches it;
  with these numbers it does not.

Heights: 65 mm from the top of the lamp base to the underside of the
plate, 70 mm to the surface the Belkin stands on, less the 1 to 3 mm
the cone settles on the rounded edge.

## Pattern

Asanoha (hemp leaf): a grid of triangles, each with three thin bars
from its centre to its corners. 42 triangles round the circle
(`n_around`), 6 rows (`rows`), between a 4 mm band at the bottom and
a 3.8 mm band at the top, with 3 mm plain bands beside the openings.

The rows get lower towards the top by a constant ratio, matched to
the radius, so on the sides of the cone the triangles keep the shape
of an equilateral one while they shrink: side 15.9 mm in the bottom
row, 11.5 mm in the top row. The cone is slanted, so towards the
rear, where the wall leans more, the triangles are stretched along
the wall, and towards the front they are squeezed.

The pattern is a relief, not a lattice: grid bars 1.6 mm and leaf
bars 1.0 mm wide stand 1.2 mm (measured level) on a 1.2 mm skin
(`skin`).

## Pieces

- `lamp-charger-stand-sides.stl`: both side walls, moved together to
  144 x 195 x 73 mm, 58.5 cm3.
- `lamp-charger-stand-top.stl`: the plate, 150 x 155 x 10 mm,
  96.4 cm3.

## Decisions

- Three pieces. The two openings split the cone into two walls; the
  plate joins them. The walls print with the pattern upwards and the
  plate prints flat. With the measured 210 mm base the ring is
  216 mm and would fit a 220 mm bed in one piece, but only upside
  down on the plate, with the pattern facing the bed.
- Slanted cone instead of a notch in the plate: the plate ends in
  front of the arm bracket and the arm keeps its swing.
- `top_d` 150: the smallest plate that keeps the wall ends beside
  the rear opening at 46 degrees. A smaller plate leans them more
  than 45 degrees from the vertical; the script refuses that.
- Relief on a skin instead of an open lattice: a lattice of this
  pattern on a leaning wall has bars 20 to 30 degrees from the bed
  and needs supports under every bar.
- Skin 1.2 mm level: three 0.4 mm lines in each layer.
- No rim round the Belkin: the plate prints top face down. The soft
  underside of the Belkin holds it.
- Rear opening as wide as the door: one number, a symmetric part.
- Mesh: the bars stand 0.02 mm proud of the bands (`proud`), the
  pattern is turned 0.7 degrees (`phase`), skirt and cone are one
  convex body, and cone sections are cut from a longer cone. Bar
  faces in the wall surface, bars along a facet edge and thin end
  discs each left edges shared by four or six faces in the STL.

## Print notes

- Side walls: as exported, skirt on the bed, pattern outwards. No
  supports. The bed contact is a 2.4 mm strip and the walls are
  73 mm tall: use a brim. 3 perimeters. The rear ends lean 44
  degrees from the vertical, the limit for most printers; slow the
  outer wall down if they sag.
- Plate: as exported, top face on the bed, lip and tabs up. No
  supports.
- PETG preferred: both chargers get warm. PLA works away from the
  sun.
- About 25 g for the walls and 42 g for the plate at 20 percent
  infill.

## Limits and open points

- Not printed. 0.6 mm of air between skirt and lamp base may be
  loose or tight; print the side walls first and try them on the rim.
- `bracket_r` and `bracket_w` are photo readings. The rear opening
  is 92 mm wide, so the width matters little.
- The door faces the arm bracket. A 166 mm phone centred on the pad
  reaches 83 mm back from the lamp axis, the bracket is read at
  60 mm: whether a phone passes under or beside the bracket is not
  known. An earbud case fits.
- The plate lies loose on the walls, 70 mm up and 33 mm in front of
  the lamp axis. The Belkin stays inside the outline of the lamp
  base, but a few drops of glue between plate and walls are
  recommended once the fit is confirmed.
- How far the arm can swing forward before it meets the rear edge of
  the plate is not measured.
- The Belkin base holds metal and magnets 70 mm above the lamp pad;
  far outside Qi range. The pad's foreign object detection with the
  stand in place is untested.

## Security Note

No secrets in this part. Two wireless chargers are stacked: keep
metal objects (keys, coins, cards with chips) out of the cone and
off the pad, and check that neither charger nor the print gets hot
in the first days of use.
