# Deco arm platform

Platform for a TP-Link Deco on top of the swivel knuckle of a monitor
arm, beside the VESA head that carries a printed plate. Source:
`scripts/deco_arm_platform.scad`. Build: `make deco-platform`;
`make deco-platform-fit` builds a test piece of the saddle;
`make deco-platform-save` copies both STLs to `models/`.

## Requirement

- Carries one Deco: a cylinder of 110 mm diameter, 114 mm tall.
- Sits on the arm itself, not on the VESA plate and not on the desk.
- No drilling or change to the arm; removable.

## Source measurements

The Deco is 110 x 110 x 114 mm; the ruler photo agrees (about
108 mm).

The arm numbers are read from two photos with a steel ruler held
against the arm. The ruler is not in the plane of the parts and one
photo is taken at an angle, so each number is good to about +-4 mm.
They are defaults for the fit piece, not final values.

| parameter      | value | what                                              |
|----------------|-------|---------------------------------------------------|
| `knuckle_w`    | 28    | width of the knuckle block                        |
| `knuckle_len`  | 36    | flat top from the pin axis to the end of the block |
| `boss_d`       | 24    | cap of the swivel pin on top of the knuckle       |
| `boss_h`       | 1.5   | height of the cap above the flat top              |
| `pin_to_plate` | 51    | pin axis to the face of the VESA plate            |
| `arm_angle`    | 90    | plan angle between knuckle and the link to the head |

Seen from above the arm is an L: the link from the VESA head and the
spring arm meet at the knuckle at 90 degrees. The knuckle block with
the pin cap is taken to be part of the spring arm side, with the link
to the head entering it below the top face. This is read from the
photos and not confirmed.

## Geometry

Frame: +X away from the VESA plate, Y along the plate, Z up. The Deco
stands on Z = 0 with its axis on the origin. The top of the knuckle
is at Z = -4.

Two pieces.

Tray:

- Floor disc, 114.4 mm diameter, 4 mm thick. It lies on the flat top
  of the knuckle.
- The Deco axis is 10.35 mm further from the plate than the pin axis
  (`tray_off`, derived), so the rim clears the plate by 2 mm
  (`plate_gap`).
- Saddle, turned by `arm_angle` about the pin axis: two cheeks 5 mm
  thick and 10 mm tall, 29 mm apart (`knuckle_w` + 1), beside the
  knuckle from 2 mm to 36 mm from the pin axis. They stop the tray
  from turning and sliding. Each cheek is split at the cable tie.
  The cheek on the plate side has only its rear segment: the link to
  the head leaves the knuckle under the front one.
- Pocket 26 mm x 1.5 mm in the underside for the pin cap.
- One cable tie, 22 mm from the pin axis: two 7 x 3 mm slots through
  the floor right beside the knuckle, in the gap of the cheeks, and a
  1.8 mm deep groove in the top face between them. The tie runs in
  the groove under the Deco and around the knuckle. The tie takes
  tipping loads; the weight rests on the knuckle.

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

Tray 41.6 cm3, rim 10.2 cm3.

## Fit piece

`make deco-platform-fit`: the saddle (cheeks, pocket, slots, groove)
on a 47 x 56 mm plate, 11 cm3. Print it first, put it on the knuckle
and check: width between the cheeks, pocket over the pin cap, room
for the tie, and that the head still swivels. Then set the
parameters, for example
`make deco-platform SCAD_ARGS='-D knuckle_w=30 -D boss_d=26'`.

## Print notes

- Tray: upside down, top face on the bed. No supports. The tie groove
  in the bed face is a 7 mm bridge.
- Rim: upside down, upper edge on the bed. No supports.
- PETG or PLA. The Deco runs warm but not hot; PLA is enough indoors
  away from the sun.
- 4 perimeters for the cheeks.

## Limits and open points

- All arm numbers are estimates until the fit piece has been tried.
- The tray reaches 59 mm from its axis; the plate is 61 mm away. If
  the head swivels about the pin, the plate and whatever is mounted
  on it swing towards the Deco. The range that stays free is not
  known.
- The Deco stands above the plate edge level only if the plate ends
  below the knuckle top; otherwise the Deco stands in front of the
  plate, 2 mm from it.
- One tie on a 28 x 36 mm seat carries a 114 mm tall device. It is
  enough against a nudge, not against a pull on the cables. Route
  the Deco cables with slack.

## Security Note

No secrets in this part. The Deco is network equipment: if it falls
it can pull its power and Ethernet cables and take the network down,
so check the tie after the first days and keep cable slack.
