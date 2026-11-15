# Deco arm platform

Platform for a TP-Link Deco on top of the swivel link of a monitor
arm, behind the VESA head that carries a printed plate. Source:
`scripts/deco_arm_platform.scad`. Build: `make deco-platform`;
`make deco-platform-fit` builds a test piece of the saddle;
`make deco-platform-save` copies both STLs to `models/`.

## Requirement

- Carries one Deco: a cylinder of 110 mm diameter, 114 mm tall.
- Sits on the arm itself, not on the VESA plate and not on the desk.
- No drilling or change to the arm; removable.
- Air reaches the vent slots in the base of the Deco.

## The arm

Seen from above the arm is an L:

- The head block runs from the VESA plate straight back, about 44 mm
  long, to a vertical swivel pin.
- From the pin a link runs along the plate to the elbow of the spring
  arm. The link is a fork around the pin: a top cap about 10 mm
  thick, the ring of the head block about 21 mm, a bottom cap; 37 mm
  in all. Its end around the pin is round.
- The top of the link is flat and level with the top of the head
  block. The elbow housing at the far end of the link stands about
  5 mm higher.
- The pin shows as a flat metal cap in the top of the link.

## Source measurements

The Deco is 110 mm in diameter. Its base, from a photo: a ring of
radial vent slots near the edge, from about 43 to 52 mm radius, and
five rubber feet inside that ring, at about 33 to 41 mm radius. The
middle of the base is closed.

The arm numbers are read from three photos with a steel ruler held
against the parts: one from behind along the link, one from the side
across the head block and the pin, one from above. Earlier photos
were taken at an angle and are not used. Reading error about +-1.5 mm
for the link, more for the head block.

| parameter      | value | what                                             |
|----------------|-------|--------------------------------------------------|
| `link_w`       | 26    | width of the link (25.5 read)                    |
| `link_len`     | 31    | flat top from the pin axis to the elbow housing  |
| `link_back`    | 13    | round end of the link behind the pin axis        |
| `elbow_h`      | 5     | elbow housing above the flat top                 |
| `cap_d`        | 20    | pin cap with its ring (15.5 mm metal disc)       |
| `pin_to_plate` | 57    | pin axis to the face of the VESA plate           |
| `arm_angle`    | 90    | plan angle between the link and straight back    |

## Geometry

Frame: +X away from the VESA plate, Y along the plate, Z up. The Deco
stands on Z = 0 with its axis on the origin. The top of the link is
at Z = -11.

Two pieces.

Tray:

- Floor disc, 114.4 mm diameter, 4 mm thick.
- Pad, 7 mm high (`pad_h`), on the flat top of the link, 1 mm inside
  the link outline on the plate side. It lifts the floor over the
  elbow housing (2 mm of air) and over the head block, which swivels
  under the floor.
- One cheek, 5 mm thick and 8 mm tall, beside the link on the side
  away from the plate, from the pin axis to 31 mm, split at the tie.
  8 mm stays within the top cap of the fork, so the cheek does not
  touch the ring of the head block. There is no cheek on the plate
  side: the head block is there. On that side the cable tie in its
  slot holds the tray.
- Pocket 22 mm x 1.5 mm in the pad for the pin cap.
- One cable tie, 20.5 mm from the pin axis, clear of the swivel ring:
  two 7 x 2.5 mm slots through pad and floor right beside the link,
  and a 1.8 mm deep groove in the top face between them. The tie runs
  in the groove under the Deco and around the link.
- Vents (`vents`, on by default): eight windows through the floor
  between 42 and 53 mm radius (`vent_r1`, `vent_r2`), under the slot
  ring of the Deco, with 8 mm spokes between them; 25.8 cm2 open.
  The feet stand on the solid floor inside the windows, the saddle
  ends at 26 mm radius. 4.2 mm of floor stays outside the windows
  and carries the rim. Under the floor the air is free: the pad
  holds it 7 mm above the arm.
- The Deco axis is 4.35 mm further from the plate than the pin axis
  (`tray_off`, derived), so the rim clears the plate by 2 mm, and
  9 mm along the link from the pin (`tray_along`), the middle of the
  flat top.

Rim:

- A loose band, 118.7 mm outside, 10 mm tall. The lower 4 mm has a
  bore of 114.7 mm and sits around the floor edge; above it the bore
  is 112 mm, so a 1.2 mm step rests on the floor. It stands 6 mm
  above the floor around the Deco.
- Held by its weight and by the Deco inside it. A drop of glue fixes
  it if wanted.

The rim is a separate piece so that the tray prints on its flat top
face. A rim on the tray would lift the floor off the bed and need
supports under all of it.

Tray 39.7 cm3, rim 10.2 cm3.

## Fit piece

`make deco-platform-fit`: the saddle (pad, cheek, pocket, slots,
groove) on a 45 x 52 mm plate, 18 cm3. Print it first, put it on the
link and check: the cheek against the side of the link, the pad
inside the flat top, the pocket over the pin cap, room for the tie,
and that the head still swivels. Then set the parameters, for example
`make deco-platform SCAD_ARGS='-D link_w=27 -D link_len=29'`.

## Print notes

- Tray: upside down, top face on the bed. No supports. The tie groove
  in the bed face is a 7 mm bridge; the vent windows are vertical
  holes.
- Rim: upside down, upper edge on the bed. No supports.
- PETG or PLA. PLA is enough indoors away from the sun.
- 4 perimeters for the cheek.

## Limits and open points

- The seat is 43 x 25 mm under a device 114 mm tall, held by one tie.
  It is enough against a nudge, not against a pull on the cables.
  Route the Deco cables with slack.
- The rim is 2 mm from the plate with the arm at 90 degrees. If the
  head swivels about the pin, the plate and whatever is mounted on it
  swing towards the Deco; the free range is not known.
- `elbow_h` and the width of the head block are the least certain
  readings. If the floor touches the elbow housing, raise `pad_h`.
- The radii of the slot ring and the feet are read from a photo
  without a ruler. If a foot lands on a window, raise `vent_r1`.
- Whether the pin cap stands above the flat top is not known; the
  pocket allows 1.5 mm.

## Security Note

No secrets in this part. The Deco is network equipment: if it falls
it can pull its power and Ethernet cables and take the network down,
so check the tie after the first days and keep cable slack.
