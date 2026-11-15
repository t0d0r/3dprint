# Tube clip

Snap clip that holds a tube of 20 mm outer diameter under a shelf. The
clip is fixed to the underside of the shelf with double-sided tape.
Two clips carry one tube about 300 mm long. Source:
`scripts/tube_clip.scad`. Build: `make tube-clip`;
`make tube-clip-save` copies the STL to `models/tube-clip.stl`.

## Requirement

- Holds a tube of 20 mm outer diameter, about 300 mm long.
- Fixed with double-sided tape to the underside of the shelf; it
  must hold without screws.
- Two clips.
- Screw holes as a second way to fix the clip, usable or not.

## Geometry

Frame: X across the tube, Y along the tube, Z up, shelf underside at
Z = 0. The mouth of the clip faces +X.

- Pad: 60 x 40 x 3 mm (`pad_w`, `clip_len`, `pad_t`), flat on top.
  It is the tape face, 24 cm2 per clip.
- Ring: bore 20.2 mm (`tube_d` + `tube_clr` 0.2), wall 2.4 mm, 40 mm
  long. The tube axis is 15.1 mm under the shelf, the tube 5 mm under
  it (`pad_t` + `drop` 2).
- Mouth to the side, not downwards: 17 mm clear between the lips
  (`mouth`), 3 mm less than the tube, so the tube snaps in. With the
  mouth at the side the weight of the tube and of anything hung on it
  rests on the closed lower half of the ring. A mouth facing down
  would put that load on the snap.
- Above the mouth the ring, the 14 mm neck and the pad are one solid
  nose. Only the lower arm bends: about 180 degrees of ring from the
  lower lip round the bottom to the neck.
- Both lips end in a 2.4 mm round, the lead-in for the tube.
- 3 mm fillets where ring and neck meet the pad.
- Screw holes (`screws`, on by default): one hole in the pad at each
  side of the ring, 22.5 mm from the tube axis, at mid length. 3.8 mm
  for a 3.5 mm countersunk wood screw, 90 degree countersink of
  7.5 mm on the underside, which leaves 1.15 mm of pad under the
  head. The driver passes 10 mm beside the ring and beside the tube,
  so the screws can go in with the tube in place. The holes take
  0.2 cm2 of the 24 cm2 tape face. `-D screws=false` builds the pad
  without them.

Outer size of one clip 60 x 40 x 27.6 mm (across, along the tube,
height below the shelf), 12.35 cm3.

## Numbers behind the snap

Estimated with the lower arm as a curved beam fixed at the neck,
E = 2000 MPa:

- Opening the mouth by 3 mm strains the outer fibre by about 1 %. PETG
  takes that repeatedly; PLA takes it for a few insertions.
- Force on the lip about 45 N, so a firm push. `wall` 3 mm doubles
  it, `mouth` 18 halves the strain.
- `mouth` below 80 % of the tube diameter is rejected by an assert.

## Tape

- Rule of thumb for acrylic foam tape (VHB class): 55 cm2 of tape per
  kg of static load. Two pads give 48 cm2, so about 0.85 kg for tube
  and load together when the whole pad is covered. Ordinary foam
  mounting tape holds less.
- The load pulls the tape straight off the shelf (tension), its
  weaker direction after peel. Keep the load near the clips; a load
  on the overhanging ends of the tube levers on the pads.
- The pad face is printed as a vertical wall and shows layer lines.
  Foam tape fills them; thin film tape does not.
- Mounting: degrease pad and shelf, snap both clips onto the tube
  first, then press the pair against the shelf. That lines the clips
  up and keeps the snap force off fresh tape. Full strength after
  about 24 to 72 hours.

## Screws

- The screw must be shorter than pad plus shelf: the head sits flush
  in the 3 mm pad, so a screw of length L enters the shelf by
  L - 3 mm. For the 8 mm shelf of specs/rm10-shelf-hanger.md that is
  3.5 x 10 mm at most (7 mm in the shelf).
- Tape and screws together: stick the clip first, then drive the
  screws through the tape. Do not overtighten; 1.15 mm of plastic
  under the head cracks before the screw strips.
- Pan head screws also fit; the head then stands 2 to 3 mm below the
  pad, clear of the tube.

## Shelf-edge clip

Second model for the same tube. Source: `scripts/tube_edge_clip.scad`.
Build: `make tube-edge-clip`; `make tube-edge-clip-save` copies the
STL to `models/tube-edge-clip.stl` (two clips).

Requirement: holds the 20 mm tube under the 8 mm shelf and is pushed
onto the front edge of the shelf, with no tape and no screws. Used
together with the taped clips on one tube, all clips hold the tube in
one straight line.

Frame of the profile: u from the shelf edge into the shelf, v up,
shelf underside at v = 0. The tube runs along the shelf edge.

- One profile extruded 30 mm along the tube (`clip_len`).
- Web 4 mm in front of the shelf edge, plate 48 x 4 mm under the
  shelf, jaw 3 mm thick reaching 40 mm over the shelf.
- Slot 8.3 mm (`shelf_t` 8 + `clip_clr` 0.3) with square corners at
  its root.
- Bump of 4 mm radius under the jaw tip closes the slot to 7.2 mm
  (`pinch` 0.8). The jaw bends up by 0.8 mm on an 8 mm shelf: about
  7 N of grip, strain under 0.3 %. The bump also rounds the tip
  upwards as a lead-in. The plate is 8 mm longer than the jaw, so
  the shelf lies on the plate before it meets the bump.
- Ring as in the taped clip: bore 20.2 mm, wall 2.4 mm, mouth 17 mm,
  solid nose above the mouth, 3 mm fillets to the plate.
- The mouth faces the front. Pushing the tube in pushes the clip
  onto the shelf; pulling the tube out pulls the clip off, so hold
  the clip then.
- In line with the taped clip:
  - Height: the taped clip holds the tube 5 mm under its pad face,
    plus the tape. This clip holds it `ref_gap` 5 + `tape_t` under
    the shelf. `tape_t` is 1.0 mm, a common foam tape; set it to the
    real tape thickness, or to 0 when the taped clips are only
    screwed. The tube axis is then 16.1 mm under the shelf in both.
  - Distance from the edge: the tube axis is 32 mm behind the shelf
    edge (`tube_u`). The 60 mm pad of a taped clip on the same axis
    ends 2 mm behind the edge. Stick the taped clips with their axis
    32 mm from the edge and the mouth to the front.
- The tube axis is under the jaw (32 of 40 mm), so the load presses
  the jaw onto the shelf and does not lever the clip off.

Outer size of one clip 52 x 30 x 39.9 mm (depth, along the tube,
height), 15.2 cm3. It reaches 28.6 mm below the shelf and 11.3 mm
above its underside.

Print: standing on an end face, two clips, 52 x 85.8 mm on the bed,
30 mm tall, no overhangs, no supports. The layers run along the jaw
and around the ring, so both springs bend along the layers. PETG.

Open for this model:

- Needs a free, square front edge. A rounded or profiled edge, or an
  edge band thicker than the board, changes the slot.
- Nothing but 7 N of pinch and the load holds the clip; it can be
  pulled off forwards by hand. That is the intent.
- If the clip is loose or too tight, change `pinch` or `clip_clr`.

## Parameters

`make tube-edge-clip SCAD_ARGS='-D tape_t=0.8'` sets the tape
thickness for the alignment; `shelf_t`, `pinch`, `grip_d`, `tube_u`
fit another shelf.

`make tube-clip SCAD_ARGS='-D tube_d=25'` builds for another tube.
`tube_clr` sets how tightly the tube sits (0 to grip, 0.4 to turn
freely), `mouth` the snap, `clip_len` and `pad_w` the tape area,
`count` the number of clips in the STL.

## Print notes

- Orientation: standing on an end face (the STL is exported that way,
  two clips, 60 x 63.2 mm on the bed, 40 mm tall). The profile is
  extruded upwards: no overhangs, no supports, and the layers run
  around the ring, the strong direction for the snap arm.
- 6.2 cm2 bed contact for both; brim optional.
- The screw holes lie horizontally in this orientation. At 3.8 mm
  they print without supports; the check reports their upper halves
  as 0.3 cm2 of overhang.
- Material: PETG. PLA works if the tube is put in once and left.
- Four or more perimeters, so the 2.4 mm ring wall is solid.

## Open

- Whether the tube runs along the shelf edge is assumed; the edge
  clip cannot hold a tube that runs front to back.
- Not printed. The tube diameter is nominal; measure it and set
  `tube_d`.
- The load on the tube is not known. Above about 0.85 kg in total use
  more tape area (`clip_len`, `pad_w`) or screws.
- The shelf surface is not known. Tape holds poorly on raw chipboard,
  textured or dusty surfaces.

## Security Note

No secrets and no network in this part. The safety point is physical:
tape can let go without warning under long load or heat, so do not
hang anything heavy, fragile or hot from the tube, and nothing above
a place where people sit.
