# MacBook Pro 14" stacking stand

Source: `scripts/macbook_stack_stand.scad`. Build: `make macbook-stand`.
Output: `out/macbook-stack-stand.stl` (print two),
`out/macbook-stack-stand-assembly.png`, `out/macbook-stack-stand-section.png`.

## Goal

Two closed MacBook Pro 14" (M4, 2024) laptops lie flat, one above the
other, on two small stands.

- The lower laptop sits 5 mm above the desk, in a channel it slides in.
- The upper laptop sits 10 mm above the lower one, in its own channel.
- The stands go at the middle of the laptops, clear of the ports.

## Design

One stand is a rail with an E-shaped cross-section: a vertical wall with
three shelves. The side edges of the laptops go into the two channels.
Two identical stands are used, one at the middle of the left side and one
at the middle of the right side; the second is the first turned around.

```
        +-------+
        |  +----+   top lip, 3 mm
        |  |
        |  |        upper channel, 16.0 mm  <- upper laptop
        |  +----+
        |       |   middle shelf, 9.5 mm
        |  +----+
        |  |
        |  |        lower channel, 16.0 mm  <- lower laptop
       /|  +----+
     /  |       |   bottom shelf, 5 mm
    +---+-------+   desk
    foot wall shelves
     12   4    7    mm
```

Laptop reference dimensions (Apple): 15.5 mm thick closed, 312.6 mm wide,
221.2 mm deep, 1.55 kg.

| parameter   | value | meaning                                              |
|-------------|-------|------------------------------------------------------|
| `laptop_t`  | 15.5  | closed thickness without the rubber feet             |
| `desk_gap`  | 5     | desk to underside of the lower laptop                |
| `stack_gap` | 10    | top of the lower laptop to underside of the upper    |
| `clearance` | 0.5   | vertical slack of a laptop in its channel            |
| `engage`    | 7     | how far the shelves reach in from the laptop side    |
| `wall_t`    | 4     | vertical wall                                        |
| `top_t`     | 3     | lip above the upper laptop                           |
| `length`    | 60    | rail length along the laptop side                    |
| `foot_out`  | 12    | outward foot                                         |
| `foot_h`    | 12    | height where the foot meets the wall                 |
| `flare`     | 0.8   | channel opens by this much at both rail ends         |
| `lead`      | 4     | length of that lead-in                               |

Result: 23 mm wide, 49.5 mm tall, 60 mm long, 24.2 cm3.

## Decisions

- Side rails, not blocks under the laptops: a channel that the laptop
  slides in has to wrap an edge, and the middle of the left and right
  sides is the only edge stretch free of ports, hinge and exhaust.
- Channel height is laptop thickness plus `clearance`. The middle shelf
  is `stack_gap - clearance` thick, so with both laptops resting on
  their shelves the gap between them is the full 10 mm.
- `engage` is 7 mm: the rubber feet sit near the corners, further in
  than that, so they pass outside the shelves when a laptop slides
  through. The feet inset is not confirmed by measurement (see Open).
- `length` is 60 mm: centred on the 221 mm side it spans 81 to 141 mm
  from the back edge and stays in front of the ports, which take up
  roughly the rear third of each side. Longer rails are steadier but
  come closer to the headphone jack and the SD slot.
- Outward foot: without it the base would be 11 mm wide under a 49.5 mm
  tall part and an empty stand would fall over while the first laptop
  goes in.
- Lead-in at both rail ends (0.8 mm over 4 mm on the floor, ceiling and
  wall of each channel) so a laptop edge finds the channel, and so
  first-layer squish does not narrow the entrance.
- Outer corners rounded 1.2 mm, inner corners filleted 1.0 mm. The
  fillets are smaller than the edge radius of the laptop body, so they
  do not lift it off the shelf.
- Modelled in print orientation (profile on the bed, rail length up):
  no overhangs, and every layer contains the whole E, so the shelves
  bend within the layers and not across layer bonds.
- OpenSCAD, not CadQuery: the part is one extruded 2D profile with four
  tapered cuts; no STEP export is needed.
- The STL is a build product in `out/` and is not committed.

## Use

1. Push one stand onto each side of the lower laptop at mid depth, or
   stand them 313.6 mm apart (wall to wall, inside) and slide the laptop
   in from the front.
2. Slide the upper laptop into the upper channels from the front.
3. Keep the stands snug against the laptop sides. They are not joined
   to each other; only friction on the desk stops them from moving
   apart. Thin self-adhesive rubber dots under the base help; subtract
   their thickness from `desk_gap` to keep the 5 mm.

## Print notes

- Print two, as modelled, no supports. 0.2 mm layers, 3 or more
  perimeters, 20% infill or more. PLA or PETG; PETG if the laptops run
  warm for long periods in clamshell mode.
- Fit test first: `make macbook-stand SCAD_ARGS="-D length=10"` gives a
  10 mm slice of the profile. Check that it slips over the laptop edge
  without force, then rebuild at full length. Tune `clearance`.

## Checks (2026-11-09)

- Watertight, consistent winding, one body, Euler number 2.
- Sections at mid length: solid from 0 to 5.0, 21.0 to 30.5 and 46.5 to
  49.5 mm, so both channels are 16.0 mm and the laptops rest 5.0 and
  30.5 mm above the desk (10.0 mm apart for 15.5 mm laptops).
- At the rail ends the channels are 17.6 mm and the wall 3.2 mm.
- Printability in specs/printability.md.

## Open

- Laptop numbers come from the published dimensions, not from a
  measurement of the actual machines. Measure the closed thickness
  without feet, the distance of the rubber feet from the side edge
  (must be more than `engage` plus the side play), and where the side
  intake slots on the underside end.
- The intake slots run along the left and right underside edges. The
  bottom shelf covers a 60 x 7 mm strip there. If it overlaps a slot,
  move the stands forward or shorten `length`.

## Security Note

The part is generated from local source only; nothing is downloaded and
no model file from outside is read. The build needs no secrets. Check
the fit with the 10 mm test piece before trusting the stands with two
laptops, and keep the stands snug against the sides: they are not joined
and a stand knocked outward by more than the 7 mm shelf depth drops the
laptop edge.
