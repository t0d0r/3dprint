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
     12   4   15    mm

The sketch is not to scale: the shelves are 15 mm deep, about as deep
as the channels are tall.
```

Laptop reference dimensions (Apple): 15.5 mm thick closed, 312.6 mm wide,
221.2 mm deep, 1.55 kg.

| parameter   | value | meaning                                              |
|-------------|-------|------------------------------------------------------|
| `laptop_t`  | 15.5  | closed thickness without the rubber feet             |
| `desk_gap`  | 5     | desk to underside of the lower laptop                |
| `stack_gap` | 10    | top of the lower laptop to underside of the upper    |
| `clearance` | 0.5   | vertical slack of a laptop in its channel            |
| `engage`    | 15    | channel depth: how far the shelves reach in          |
| `wall_t`    | 4     | vertical wall                                        |
| `top_t`     | 3     | lip above the upper laptop                           |
| `length`    | 68    | rail length along the laptop side                    |
| `foot_out`  | 12    | outward foot                                         |
| `foot_h`    | 12    | height where the foot meets the wall                 |
| `flare`     | 0.8   | channel opens by this much at both rail ends         |
| `lead`      | 4     | length of that lead-in                               |

Result: 31 mm wide, 49.5 mm tall, 68 mm long, 36.8 cm3.

## Decisions

- Side rails, not blocks under the laptops: a channel that the laptop
  slides in has to wrap an edge, and the middle of the left and right
  sides is the only edge stretch free of ports, hinge and exhaust.
- Channel height is laptop thickness plus `clearance`. The middle shelf
  is `stack_gap - clearance` thick, so with both laptops resting on
  their shelves the gap between them is the full 10 mm.
- `engage` is 15 mm (was 7 mm): the channels hold 15 mm of each laptop
  edge, so a stand has to move outward by more than 15 mm before an
  edge drops, and the laptops sit on twice the shelf area. The cost:
  the shelves now reach the band where the rubber feet are expected
  (roughly 10 to 25 mm in from the side, not measured). A 16.0 mm
  channel does not pass a laptop standing on its feet, so sliding a
  laptop in lengthwise may jam at the feet; see Use and Open.
- `length` is 68 mm: 60 mm of full-height channel plus the two 4 mm
  lead-ins. Centred on the 221 mm side it spans 77 to 145 mm from the
  back edge. The ports take up roughly the rear third of each side
  (to about 74 mm), so the margin to the headphone jack and the SD slot
  is a few millimetres and is not measured. Longer rails are steadier
  but come closer to those ports.
- Outward foot: without it the base would be 19 mm wide under a 49.5 mm
  tall part and an empty stand would tip while the first laptop goes
  in.
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

1. Push one stand onto each side of the lower laptop at mid depth.
   The channels are open toward the laptop, so this never touches the
   rubber feet.
2. Slide the upper laptop into the upper channels from the front. If
   its rear feet catch on the middle shelf, stack both laptops first
   with a 10 mm spacer between them and push the stands on from the
   sides over both edges at once.
3. Keep the stands snug against the laptop sides. They are not joined
   to each other; only friction on the desk stops them from moving
   apart. Thin self-adhesive rubber dots under the base help; subtract
   their thickness from `desk_gap` to keep the 5 mm.

## Print notes

- Print two, as modelled, no supports. 0.2 mm layers, 3 or more
  perimeters, 20% infill or more. PLA or PETG; PETG if the laptops run
  warm for long periods in clamshell mode.
- Fit test first: `make macbook-stand SCAD_ARGS="-D length=10 -D flare=0"`
  gives a 10 mm slice of the profile. `flare=0` matters: with the
  lead-ins on, only 2 mm of a 10 mm slice has the real channel height
  and the piece feels looser than the full stand. Check that it slips
  over the laptop edge without force, then rebuild at full length
  (the test overwrites `out/macbook-stack-stand.stl`). Tune `clearance`.
- About 46 g PLA each if printed solid; less with infill.

## Checks (2026-11-09)

- Watertight, consistent winding, one body, Euler number 2.
- Sections at mid length: solid from 0 to 5.0, 21.0 to 30.5 and 46.5 to
  49.5 mm, so both channels are 16.0 mm and the laptops rest 5.0 and
  30.5 mm above the desk (10.0 mm apart for 15.5 mm laptops).
- At the rail ends the channels are 17.6 mm and the wall 3.2 mm.
- Shelves and top lip end 19.0 mm from the outer wall face: 4 mm wall
  plus 15.0 mm channel depth.
- Printability in specs/printability.md.

## Open

- Laptop numbers come from the published dimensions, not from a
  measurement of the actual machines. Measure the closed thickness
  without feet, the distance of the rubber feet from the side edge,
  the position of the last port on each side, and where the side
  intake slots on the underside end.
- Rubber feet against the 15 mm shelves: if the feet sit less than
  15 mm from the side edge, a laptop cannot be slid through a channel
  lengthwise. Either fit the stands from the sides (see Use), or cut a
  relief for the feet in the bottom and middle shelves, or reduce
  `engage` below the measured feet inset.
- The intake slots run along the left and right underside edges. The
  bottom shelf now covers a 68 x 15 mm strip there, about twice the
  earlier area. If it overlaps a slot, move the stands forward, shorten
  `length`, or open a window in the bottom shelf.

## Security Note

The part is generated from local source only; nothing is downloaded and
no model file from outside is read. The build needs no secrets. Check
the fit with the 10 mm test piece before trusting the stands with two
laptops, and keep the stands snug against the sides: they are not joined
and a stand knocked outward by more than the 15 mm channel depth drops
the laptop edge. Do not force a laptop through a channel if its rubber
feet catch on a shelf.
