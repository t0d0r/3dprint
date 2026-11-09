# MacBook Pro 14" stacking stand

Source: `scripts/macbook_stack_stand.scad`. Build: `make macbook-stand`.
Output: `out/macbook-stack-stand-left.stl` and `-right.stl` (print one
of each) and previews: `-part.png` (right stand as printed),
`-assembly.png` (seen from behind), `-side.png` (from the right),
`-section.png` (cut through a pad) and `-plan.png` (lower laptop and
stands seen from below, intake slots in red, back edge at the bottom
of the picture).
Fit test: `make macbook-stand-fit` -> `out/macbook-stack-stand-fit.stl`.

## Goal

Two closed MacBook Pro 14" (M4, 2024) laptops lie flat, one above the
other, on two small stands.

- The lower laptop sits 5 mm above the desk, in a channel it slides in.
- The upper laptop sits 10 mm above the lower one, in its own channel.
- The stands go on the left and right sides, in front of the ports.
- The air intake slots on the underside of each laptop stay mostly open.
- The stack is steady front to back: the supports are 100 mm apart.
- A laptop slid in from the front stops at a back stop and cannot go
  out through the back of the stand.
- Each stand can be screwed to the desk with two screws.

## Design

One stand is a rail with an E-shaped cross-section: a vertical wall with
three shelves. The side edges of the laptops go into the two channels.
Two stands are used, one on the left side and one on the right side.
They are mirror images of each other.

Behind the rail only the middle shelf goes on, as a flat bar between
the two laptops, 80 mm to the back edge of the laptops. There it ends
in a cross plate as tall as the stand. Seen from the side, bar and
plate form a T lying on its side. There is no wall, foot or shelf
beside the bar.

```
    side view, front of the laptops on the left

    +------------------+                               +---+
    |   top lip        |   upper laptop                |   |
    |                  | ............................. |   |
    |   middle shelf   +-------------------------------+   |  bar, 5 mm
    |                  +-------------------------------+   |
    |   bottom shelf   |   lower laptop                |   |
    +------------------+ ............................. +---+
    0       rail      100            bar              180 185 mm
                                                   cross plate
```

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
| `ext`       | 80    | rail rear end to the stop face; 0 = no back stop     |
| `bar_t`     | 5     | thickness of the bar behind the rail                 |
| `cap_t`     | 5     | thickness of the cross plate                         |
| `gusset`    | 4     | 45 degree brace between bar and plate, upper side    |
| `side`      | right | which stand to export: "right" or "left"             |
| `foot_out`  | 12    | outward foot                                         |
| `foot_h`    | 12    | height where the foot meets the wall                 |
| `foot_tip`  | 4     | thickness of the foot at its outer end               |
| `screw_n`   | 2     | screw holes in the outward foot; 0 for none          |
| `screw_inset` | 15  | hole centre to the rail end                          |
| `screw_d`   | 4.5   | clearance hole, for a 4 mm countersunk wood screw    |
| `screw_head_d` | 8.5 | head pocket diameter                                |
| `screw_seat` | 1.5  | material under the countersink                       |
| `flare`     | 0.8   | channel opens by this much at the front end          |
| `lead`      | 4     | length of that lead-in                               |

Preview-only parameters: `vent_from_back` 24 and `vent_len` 105
(intake slot, measured on the machine), `free_from_back` 80 (rail
position when `ext` is 0).

Result: 185 mm long, 49.5 mm tall, 31 mm wide, 52.0 cm3 each.

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
  cut makes the window.
- The transitions are 45 degrees so that they print without supports:
  lying on the shelf tips, each pad widens toward the wall at 45
  degrees and the ribs bridge the 48 mm between the pads. (The slope
  was chosen when the part still printed standing on end, where the
  upper pad grew out of the rib; it serves both orientations.) A
  steeper transition would open more of the slot but lengthen the
  bridges.
- The rib is 1 mm, the inner fillet radius: the cut ends where the
  fillets end, the wall keeps three stiffening ribs, and no cut face
  is coplanar with the wall.
- Back stop: the laptops slide in from the front, and without a stop
  they can be pushed out through the back. Only the middle shelf is
  continued, because a wall or a shelf beside the laptops would stand
  in front of the ports and under the intake slot. The bar runs in
  the 10 mm gap between the laptops, where nothing is in the way.
- The bar is 5 mm thick and sits at the bottom of the gap, 0.5 mm
  above the lower laptop: this leaves 4.5 mm of air under the upper
  laptop, whose intake slot runs over the bar from 24 to 80 mm from
  the back edge. The bar is as wide as the shelf plus the wall, 19 mm.
- The cross plate is as tall as the stand, 0 to 49.5 mm: it stops
  both laptops over their full thickness, and its lower arm stands on
  the desk and carries the free end of the bar. It is 19 mm wide and
  covers the outer 14.5 mm of each back corner; the exhaust in the
  middle of the back edge stays free.
- The stop face is exactly `ext` behind the rail, so the rail position
  is no longer chosen by hand: with `ext` 80 the rail sits 80 to
  180 mm from the back edge when the laptops touch the stop.
- The brace between bar and plate is on the upper side only. Under
  the bar the lower laptop passes with 0.5 mm, so nothing can be added
  there; above it the upper laptop is 4.5 mm away and the 4 mm brace
  ends 0.5 mm below it.
- With a back stop there are no lead-ins at the rear end of the rail;
  the laptops only enter from the front.
- Left and right stands are mirror images (the stand is no longer the
  same from both ends). `side` selects which one is exported.
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
- Lead-in at the front end of the rail (0.8 mm over 4 mm on the floor,
  ceiling and wall of each channel) so a laptop edge finds the
  channel. With `ext` 0 the rear end gets the same lead-in.
- Outer corners rounded 1.2 mm, inner corners filleted 1.0 mm. The
  fillets are smaller than the edge radius of the laptop body, so they
  do not lift it off the shelf.
- Printed lying on the shelf tips, outer wall face and foot up (was:
  standing on the front end). Standing, the part would be 185 mm tall
  on a 31 x 49.5 mm footprint, and the arms of the cross plate would
  hang in the air 180 mm above the bed. Lying, it is 31 mm tall, the
  bar and the plate lie on the bed and their layers run along the bar,
  which is the direction the stop is loaded in. The shelves are now
  loaded across the layers, at well under 1 MPa for a 1.6 kg laptop.
- The STL is exported in print orientation. The model frame in the
  source is unchanged: profile in XY, rail length along Z.
- OpenSCAD, not CadQuery: the part is one extruded 2D profile with a
  few cuts; no STEP export is needed.
- The fit test is its own output (`part = "fit"`, `make
  macbook-stand-fit`): a 10 mm slice of the bare profile without
  lead-ins, window or screw holes. The earlier recipe, the full part
  with `-D length=10`, failed on the screw hole assertion and wrote
  over the stand STL.
- The STL is a build product in `out/` and is not committed.

## Use

1. Left stand on the left, right stand on the right, cross plates at
   the back, 313.6 mm apart wall to wall on the inside (laptop width
   plus 0.5 mm play per side), parallel to each other.
2. Slide the lower laptop in from the front, under the bars, until
   its back edge meets the cross plates. Then the upper one, above
   the bars.
3. Sliding in from the front only works if the rubber feet clear the
   15 mm shelves (see Open). If they catch: stands that are not
   screwed down can be pushed onto the laptop edges from the sides,
   lower laptop first; the cross plates then go behind the back edges.
4. Loose stands: keep them snug against the laptop sides. They are not
   joined to each other; only friction on the desk stops them from
   moving apart. Thin self-adhesive rubber dots under the base help;
   subtract their thickness from `desk_gap` to keep the 5 mm.
5. Screwed stands: 4 mm countersunk wood screws; the screw passes
   1.5 mm of plastic before the desk, so length is chosen by the desk
   top alone. The driver runs 6 mm from the wall: a plain shaft or a
   bare bit fits, a wide bit holder does not. Check the fit with the
   stands loose before drilling the desk.

## Print notes

- Print one left and one right stand, as exported: lying on the shelf
  tips, no supports. 185 x 49.5 mm on the bed, 31 mm tall. 0.2 mm
  layers, 3 or more perimeters, 20% infill or more. PLA or PETG; PETG
  if the laptops run warm for long periods in clamshell mode.
- Bed contact is 8.3 cm2 in strips (shelf tips, bar, cross plate):
  use a brim.
- Bridges, all with both ends supported: the three ribs in the window
  bridge 48 mm, 14 mm above the bed; the inner face of the wall
  bridges 16 mm across each channel, 15 mm above the bed. Normal
  bridge settings with part cooling. The bridged faces are not
  contact surfaces.
- The shelf tips are rounded and lie on the bed; the first two layers
  there overhang slightly and may look rough.
- The screw holes print as horizontal holes, as before.
- Fit test first: `make macbook-stand-fit` gives
  `out/macbook-stack-stand-fit.stl`, a 10 mm slice of the bare
  profile, printed standing. Check that it slips over the laptop edge
  without force. Tune `clearance` (`SCAD_ARGS="-D clearance=0.8"`
  works for both targets).
- About 65 g PLA each if printed solid; less with infill.

## Checks (2026-11-09)

- Both STL files: watertight, consistent winding, one body, Euler
  number -2 (two screw holes), no edge shared by more than two faces.
  The left mesh mirrored equals the right one in volume and bounds.
- Sections across the length of the right stand, in the model frame:
  0 to 100 mm the full profile (0 to 49.5 mm high, foot included);
  100 to 180 mm only the bar, 21.0 to 26.0 mm high, 19.0 mm wide;
  at 179.9 mm the brace reaches 29.9 mm; 180 to 185 mm the cross
  plate, 0 to 49.5 mm high, 19.0 mm wide.
- Lower laptop top at 20.5 mm, bar underside at 21.0 mm; bar top at
  26.0 mm, upper laptop underside at 30.5 mm.
- Rail unchanged from the 100 mm version: channel heights 16.0 mm,
  shelf reach 15.0 mm in the pads and 1.0 mm in the window, screw
  holes at 15 and 85 mm.
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
- `ext` 80 mm puts the rail 80 mm from the back edge and rests on the
  unmeasured port position. If the last port ends further forward
  than 78 mm, raise `ext`; the rail then moves forward by the same
  amount.
- Corner radius of the laptop in plan view is not measured (assumed
  about 10 mm). The cross plate reaches 14.5 mm in from the laptop
  side, so about 4.5 mm of it meets the straight part of the back
  edge. With a larger radius the laptop goes slightly further back
  before it stops.
- The bar is a 5 x 19 mm strip, 80 mm long, held at the rail and
  standing on the desk at the plate. It is not meant to carry a
  laptop; the upper laptop rests on the pads of the rail.
- Whether the remaining slot opening is enough under sustained load
  with the lid closed is not tested. Watch temperatures on the first
  long run.

## Security Note

The part is generated from local source only; nothing is downloaded and
no model file from outside is read. The build needs no secrets. Check
the fit with the 10 mm test piece before trusting the stands with two
laptops, and keep the stands snug against the sides: they are not joined
and a stand knocked outward by more than the 15 mm channel depth drops
the laptop edge. The back stop is a stop for a laptop being slid in by
hand, not a guard against a hard shove. Do not force a laptop through a channel if its rubber
feet catch on a shelf. Before screwing into the desk, check what is
under the surface at that spot and pick a screw shorter than the desk
top is thick.
