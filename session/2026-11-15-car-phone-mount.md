# 2026-11-15 Car phone mount

New part, independent of the other notes of this day.

## Done

- `scripts/car_phone_mount.scad`: parametric phone holder for the
  storage slot above a car radio. The plug has the shape of the whole
  slot: a solid loft from the back section to the mouth section,
  sloped ends, cut off at the bowed mouth. 86 mm neck and cradle in
  the middle: backrest leaning back 20 degrees, 12 mm lip, corner
  pockets, cable window.
- First cut, replaced the same day: an 86 mm wide hollow box as plug,
  printed standing on an end face. It did not follow the shape of the
  slot.
- Two variants for a Xiaomi 15T Pro in a case (`variant`): vertical,
  82 mm channel and 95 mm backrest; horizontal, 167 mm channel and
  55 mm backrest on the same 86 mm neck.
- `make phone-mount` builds
  `out/car-phone-mount-{vertical,horizontal}.stl` and previews;
  `make phone-mount-fit` builds three flat templates;
  `make phone-mount-save` copies both STLs to `models/`.
- `models/car-phone-mount-vertical.stl` (225.3 x 72.5 x 94.7 mm,
  224 cm3) and `-horizontal.stl` (225.3 x 73.9 x 57.2 mm, 246 cm3)
  saved, both watertight. The single `models/car-phone-mount.stl` of
  the first cuts is removed.
- specs/car-phone-mount.md written; printability results added.
- `make check` passes.

## Decisions

- Slot numbers are read off photos with a ruler in the slot (table in
  the spec). Uncertain by several mm; `bow`, 10 mm, is a guess.
  Hence the templates.
- The plug fills the whole opening and stays inside it: the front
  face follows the bow of the mouth.
- Floor width of the sections is interpolated so that it reaches
  `mouth_w` at the ends of the mouth (Y = -bow), height and upper
  width so that they reach the mouth values in the middle (Y = 0).
- Fit test is three flat 2 mm rings (front view, rear section, plan)
  instead of a slice: a slice cannot show the outline of a 225 mm
  plug.
- Printed in the car frame, plug underside on the bed, because the
  plug is wider than the cradle. The ledge is filled down to the bed
  and the plug is solid, so nothing needs supports. Cost: layers lie
  across the backrest, so it is 5 mm thick instead of 4.
- Cable window goes straight down through ledge and foot.
- Phone 162.7 x 77.9 x 8.0 mm from the published figures; the case
  is assumed at 1.5 mm per edge and 2.5 mm under the back.
- The neck is narrower than the horizontal cradle, because the upper
  edge of the mouth is level over about 160 mm only. The neck ends
  inside the backrest and the foot, so it shares no face with them.
- Lip 12 mm only over 18 mm at each end, 5 mm between: a full lip
  covered the lower edge of the screen.
- Horizontal channel 13.5 mm deep for the camera end of the phone.
- No indicator window: the plug stays solid and covers the passenger
  airbag lamp on the back panel; the plug pulls out to see it.
  `lamp_*` and `cradle_x` stay in the script, off.
- No screws or glue; 1 mm felt or foam pads top and bottom.
- The pocket side walls end inside the profile and 1 mm under the lip
  top. Walls flush with the lip left coincident faces and a mesh that
  did not read as watertight.
- Material PETG or ASA; PLA sags on a dashboard in the sun.

## Open

- Not printed. Slot not measured with a caliper.
- Slope of the slot floor and the shape of the dash top behind its
  edge unknown; `neck_l` and `tilt` compensate.
- The case is not measured.
- Phone dimensions confirmed against the manufacturer's spec page.
- The car is a Kia Sportage of 2013. No published dimensions of the
  slot found. The owner's manual places the PASSENGER AIR BAG OFF
  indicator light on the center facia panel, so the marking in the
  slot is a lamp; its position along the slot is unknown.
- Bed size of the printer not known; 225 mm goes diagonally on 220.
- Committed: the script, both STLs, the spec, this note, and the car
  phone mount parts of Makefile, specs/README.md,
  specs/printability.md and todo/todo.md. The KVM mount, RM10 hanger
  and tube clip parts of those files stay uncommitted in the working
  tree; the RM10 hanger waits on the licence of the rack mount STL.

## Files touched

- scripts/car_phone_mount.scad (new)
- models/car-phone-mount-vertical.stl, -horizontal.stl (new)
- Makefile (phone-mount, phone-mount-fit, phone-mount-save)
- specs/car-phone-mount.md (new), specs/README.md,
  specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make phone-mount` and look at
  out/car-phone-mount-{vertical,horizontal}-{part,assembly,side}.png
- `make phone-mount-fit`
- `make printcheck MODEL=out/car-phone-mount-vertical.stl`

## Next step

Print the three templates, try them in the slot, correct the slot
parameters. Measure the phone in its case. Then print the full part in PETG or
ASA.

## Security Note

No secrets in this work. The plug covers the back panel of the
slot: a passenger airbag indicator there must stay visible. The
holder must not block the view of the road, and it is a friction
fit that can come loose in a crash.
