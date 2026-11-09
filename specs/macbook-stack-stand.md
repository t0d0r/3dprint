# MacBook Pro 14" stacking stand

Source: `scripts/macbook_stack_stand.scad`. Build: `make macbook-stand`.
Output: `out/macbook-stack-stand.stl` (print two) and three previews:
`out/macbook-stack-stand-assembly.png`, `-section.png` (cut through a
pad) and `-plan.png` (lower laptop and stands seen from below, intake
slots in red, back edge at the bottom of the picture).
Fit test: `make macbook-stand-fit` -> `out/macbook-stack-stand-fit.stl`.

## Goal

Two closed MacBook Pro 14" (M4, 2024) laptops lie flat, one above the
other, on two small stands.

- The lower laptop sits 5 mm above the desk, in a channel it slides in.
- The upper laptop sits 10 mm above the lower one, in its own channel.
- The stands go on the left and right sides, in front of the ports.
- The air intake slots on the underside of each laptop stay mostly open.
- The stack is steady front to back: the supports are 100 mm apart.
- Each stand can be screwed to the desk with two screws.

## Design

One stand is a rail with an E-shaped cross-section: a vertical wall with
three shelves. The side edges of the laptops go into the two channels.
Two identical stands are used, one on the left side and one on the right
side; the second is the first turned around.

The shelves and the top lip are full depth only over the first and last
12 mm of the rail (the pads). Between the pads they are cut back to a
1 mm rib along the wall, with a 45 degree transition:

```
    rail seen from above, wall at the bottom of the sketch

    |<-12->|<-14->|<---------- 48 ---------->|<-14->|<-12->|
    +------+                                        +------+   15 mm
    | pad   \                                      /   pad |
    |        \____________________________________/        |    1 mm rib
    +======================================================+   wall
    0     12     26                          74     88    100  mm
```

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
| `length`    | 100   | rail length along the laptop side                    |
| `pad_len`   | 12    | full-depth shelf at each rail end; 0 = full length   |
| `stub`      | 1     | shelf rib left along the wall between the pads       |
| `foot_out`  | 12    | outward foot                                         |
| `foot_h`    | 12    | height where the foot meets the wall                 |
| `foot_tip`  | 4     | thickness of the foot at its outer end               |
| `screw_n`   | 2     | screw holes in the outward foot; 0 for none          |
| `screw_inset` | 15  | hole centre to the rail end                          |
| `screw_d`   | 4.5   | clearance hole, for a 4 mm countersunk wood screw    |
| `screw_head_d` | 8.5 | head pocket diameter                                |
| `screw_seat` | 1.5  | material under the countersink                       |
| `flare`     | 0.8   | channel opens by this much at both rail ends         |
| `lead`      | 4     | length of that lead-in                               |

Preview-only placement parameters: `rail_from_back` 80 (laptop back
edge to the rear end of the rail), `vent_from_back` 24 and `vent_len`
105 (intake slot, measured on the machine).

Result: 31 mm wide, 49.5 mm tall, 100 mm long, 39.5 cm3.

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
- `length` is 100 mm (was 68 mm): the 68 mm rail felt unsteady front
  to back. What steadies the stack is the distance between the points
  that carry it, so the rail is longer and carries at its two ends.
- End pads and window: the intake slot on the underside of the laptop
  runs along the side edge from 24 to 129 mm from the back edge
  (measured: starts at 24 mm, 105 mm long). A full-length shelf under
  it would close 49 mm of the slot on each laptop. The shelves are
  therefore full depth only over 12 mm at each rail end and cut back
  to a 1 mm rib in between. The top lip is cut the same way, so one
  cut makes the window and the part stays symmetric end to end; the
  left and right stands are the same part.
- The transitions are 45 degrees because of the print orientation: the
  pad at the upper end of the print grows out of the rib without
  supports. The pad at the lower end has the same slope so the part is
  symmetric. A steeper transition would open more of the slot but
  needs supports.
- The rib is 1 mm, the inner fillet radius: the cut ends where the
  fillets end, the wall keeps three stiffening ribs, and no cut face
  is coplanar with the wall.
- Placement: rear end of the rail 80 mm from the back edge, front end
  at 180 mm. The ports take up roughly the rear third of each side
  (to about 74 mm, not measured), so the rail starts just in front of
  them; centred on the side it would cover the headphone jack and the
  SD slot. The rail centre is 130 mm from the back edge, 19 mm in
  front of the middle of the laptop; the pads are centred 86 and
  174 mm from the back edge, so the middle of the laptop (110.6 mm)
  lies between them with 24 mm to spare at the rear.
- Slot cover with this placement: the rear pad closes the slot from 80
  to 92 mm and its transition part of 92 to 106 mm. From 24 to 80 mm
  and from 106 to 129 mm the slot is open: about 75% of its length
  fully open, 12% under a pad, 13% under the transition.
- Outward foot: without it the base would be 19 mm wide under a 49.5 mm
  tall part and an empty stand would tip while the first laptop goes
  in.
- Screw holes are in the outward foot, not in the bottom shelf: the
  screws stay reachable with both laptops in place, and no screw head
  sits under a laptop. Two holes, 15 mm from each rail end (70 mm
  apart), on the centre line of the foot, 6 mm outside the wall.
- Each hole is a 4.5 mm clearance hole with a 90 degree countersink
  for a 4 mm countersunk wood screw, and an 8.5 mm pocket above it
  that runs out through the sloped top of the foot. 1.5 mm of material
  stays under the countersink; the head ends 3.5 mm above the desk,
  below the foot surface all round.
- `foot_tip` is 4 mm (was 2.5 mm): with the thinner tip the pocket rim
  on the outer side was 0.4 mm thick. Now 1.7 mm of foot remains
  outside the pocket.
- Lead-in at both rail ends (0.8 mm over 4 mm on the floor, ceiling and
  wall of each channel) so a laptop edge finds the channel, and so
  first-layer squish does not narrow the entrance.
- Outer corners rounded 1.2 mm, inner corners filleted 1.0 mm. The
  fillets are smaller than the edge radius of the laptop body, so they
  do not lift it off the shelf.
- Modelled in print orientation (profile on the bed, rail length up):
  no supports, and every layer of a pad contains the whole E, so the
  shelves bend within the layers and not across layer bonds.
- OpenSCAD, not CadQuery: the part is one extruded 2D profile with a
  few cuts; no STEP export is needed.
- The fit test is its own output (`part = "fit"`, `make
  macbook-stand-fit`): a 10 mm slice of the bare profile without
  lead-ins, window or screw holes. The earlier recipe, the full part
  with `-D length=10`, failed on the screw hole assertion and wrote
  over the stand STL.
- The STL is a build product in `out/` and is not committed.

## Use

1. Push one stand onto each side of the lower laptop, rear end of the
   rail 80 mm from the back edge of the laptop (just in front of the
   last port; move it if a port or plug is in the way). The channels
   are open toward the laptop, so this never touches the rubber feet.
2. Slide the upper laptop into the upper channels from the front. If
   its rear feet catch on the middle shelf, stack both laptops first
   with a 10 mm spacer between them and push the stands on from the
   sides over both edges at once.
3. Loose stands: keep them snug against the laptop sides. They are not
   joined to each other; only friction on the desk stops them from
   moving apart. Thin self-adhesive rubber dots under the base help;
   subtract their thickness from `desk_gap` to keep the 5 mm.
4. Screwed stands: fix them 313.6 mm apart, wall to wall on the inside
   (laptop width plus 0.5 mm play per side), parallel to each other.
   4 mm countersunk wood screws; the screw passes 1.5 mm of plastic
   before the desk, so length is chosen by the desk top alone. The
   driver runs 6 mm from the wall: a plain shaft or a bare bit fits, a
   wide bit holder does not.
5. Screwed stands cannot be pushed on from the sides. Both laptops then
   have to slide in from the front, and that only works if the rubber
   feet clear the 15 mm shelves (see Open). Check this with the stands
   loose before drilling the desk.

## Print notes

- Print two, as modelled, no supports. 0.2 mm layers, 3 or more
  perimeters, 20% infill or more. PLA or PETG; PETG if the laptops run
  warm for long periods in clamshell mode.
- Fit test first: `make macbook-stand-fit` gives
  `out/macbook-stack-stand-fit.stl`, a 10 mm slice of the bare
  profile. Check that it slips over the laptop edge without force.
  Tune `clearance` (`SCAD_ARGS="-D clearance=0.8"` works for both
  targets).
- 100 mm tall on a 31 x 49.5 mm footprint: use a brim if the bed
  adhesion is marginal.
- The undersides of the three upper pads are 45 degree overhangs,
  14 mm long. They print without supports; good part cooling helps.
- About 49 g PLA each if printed solid; less with infill.
- The screw holes print as horizontal holes. No supports; the top of
  the 8.5 mm pocket sags slightly, which the screw head does not touch.

## Checks (2026-11-09)

- Watertight, consistent winding, one body.
- Sections at mid length: solid from 0 to 5.0, 21.0 to 30.5 and 46.5 to
  49.5 mm, so both channels are 16.0 mm and the laptops rest 5.0 and
  30.5 mm above the desk (10.0 mm apart for 15.5 mm laptops).
- At the rail ends the channels are 17.6 mm and the wall 3.2 mm.
- Shelf reach beyond the wall, measured from sections along the rail,
  the same for the bottom shelf, the middle shelf and the top lip:
  15.0 mm from 0 to 12 mm, falling 1 mm per mm to 1.0 mm at 26 mm,
  1.0 mm to 74 mm, rising to 15.0 mm at 88 mm, 15.0 mm to 100 mm.
- Channel heights inside a pad: 16.0 mm both, as before.
- Screw holes: Euler number -2 (two through holes), 4.50 mm at the
  base, centres 15 and 85 mm along the 100 mm rail.
- `make macbook-stand-fit`: 31 x 49.5 x 10 mm, watertight.
- Printability in specs/printability.md.

## Open

- Laptop numbers come from the published dimensions, not from a
  measurement of the actual machines. Measure the closed thickness
  without feet, the distance of the rubber feet from the side edge
  and the position of the last port on each side. The intake slot
  length is measured (24 to 129 mm from the back edge, taken as
  measured from the back edge); its distance from the side edge and
  its width are not.
- Rubber feet against the 15 mm shelves: if the feet sit less than
  15 mm from the side edge, a laptop cannot be slid through a channel
  lengthwise. Loose stands can be fitted from the sides (see Use).
  Stands screwed to the desk cannot, so for them this has to be solved
  in the part: a relief for the feet in the bottom and middle shelves,
  or `engage` below the measured feet inset.
- Screw size is assumed (4 mm countersunk). Other screws need
  `screw_d` and `screw_head_d` changed; a head wider than 9 mm needs a
  wider foot (`foot_out`).
- `rail_from_back` 80 mm rests on the unmeasured port position. If
  the last port ends further forward than 78 mm, the rail has to move
  forward and the front pad comes closer to the front edge; if the
  ports end earlier, the rail can move back toward the middle.
- Whether the remaining slot opening is enough under sustained load
  with the lid closed is not tested. Watch temperatures on the first
  long run.

## Security Note

The part is generated from local source only; nothing is downloaded and
no model file from outside is read. The build needs no secrets. Check
the fit with the 10 mm test piece before trusting the stands with two
laptops, and keep the stands snug against the sides: they are not joined
and a stand knocked outward by more than the 15 mm channel depth drops
the laptop edge. Do not force a laptop through a channel if its rubber
feet catch on a shelf. Before screwing into the desk, check what is
under the surface at that spot and pick a screw shorter than the desk
top is thick.
