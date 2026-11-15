# Car phone mount

Phone holder for a car dashboard. A plug with the shape of the storage
slot above the radio fills the slot; a neck comes out of the mouth and
carries a cradle the phone stands in. Source:
`scripts/car_phone_mount.scad`. Build: `make phone-mount`;
`make phone-mount-fit` builds the fit test; `make phone-mount-save`
copies both STLs to `models/car-phone-mount-vertical.stl` and
`models/car-phone-mount-horizontal.stl`.

## Requirement

- A plug that goes into the slot between the top of the dashboard and
  the trim above the radio. The plug fills the whole opening and lies
  entirely inside its shape; it follows the curves of the slot.
- A phone holder that comes out of the plug.
- The phone is a Xiaomi 15T Pro in a case.
- Two variants: phone vertical (portrait) and phone horizontal
  (landscape).
- No screws, no glue, no marks on the car.

## The slot

Read off nine photos of the slot with a 150 mm steel ruler standing in
it and lying in it. None of these is measured with a caliper.

| what | value | parameter | how sure |
|------|-------|-----------|----------|
| width of the mouth on the floor | about 228 mm | `mouth_w` | +-10 mm |
| level part of the upper edge of the mouth | about 160 mm | `mouth_top` | +-15 mm |
| clear height of the mouth, middle | about 26 mm | `mouth_h` | +-3 mm |
| bow of the mouth seen from above | about 10 mm | `bow` | a guess, +-6 mm |
| width of the back panel on the floor | about 195 mm | `back_w` | +-10 mm |
| level part of its upper edge | about 165 mm | `back_top` | +-15 mm |
| height of the back panel | about 24 mm | `back_ht` | +-3 mm |
| depth, middle of the mouth to back panel | about 40 to 50 mm | `slot_d` 40 | +-8 mm |

- The slot is a funnel: the mouth is wider and higher than the back
  panel.
- Seen from the front the mouth is flat at the bottom; the upper edge
  is level in the middle and drops to the floor at both ends.
- Seen from above the mouth bows towards the cabin; the back panel is
  straight (the ruler lies flat against it). The slot is deepest in
  the middle.
- The trim under the slot continues about 15 mm in front of the mouth
  as a shelf.
- The car is a Kia Sportage of 2013 (third generation, SL).
- A "PASSENGER AIR BAG" marking sits on the back panel. The 2013
  owner's manual (US edition, page 3-48) describes an indicator
  light that illuminates the words PASSENGER AIR BAG "OFF" and
  places it on the center facia panel, so the marking is taken to be
  that lamp. Its position along the slot is not known from the
  photos.

## The phone

Xiaomi 15T Pro: 162.7 x 77.9 x 7.96 mm, 210 g (manufacturer's spec
page and GSMArena, checked 2026-11-15; not measured here). The case is not measured: 1.5 mm at each
edge (`case_side`) and 2.5 mm under the back (`case_back`) are
assumed, so 165.7 x 80.9 x 10.5 mm in the case.

| variant | channel width | channel depth | backrest | phone top above the slot floor |
|---------|---------------|---------------|----------|--------------------------------|
| vertical | 82 mm | 12 mm | 95 mm | about 160 mm |
| horizontal | 167 mm | 13.5 mm | 55 mm | about 85 mm |

- Channel width is the case plus 1 mm of play, rounded up.
- Horizontal: the channel is 1.5 mm deeper, because the camera end of
  the phone stands in one corner pocket. The charging port is at one
  short side, 40 mm above the ledge, clear of the 11 mm pocket wall.
- `variant` selects the set; `make phone-mount` builds both.

## Geometry

Car frame: X across the car, Y out of the slot towards the cabin with
the middle of the mouth at Y = 0, Z up with the floor of the slot at
Z = 0.

- Plug: solid loft between the section of the slot 5 mm in front of
  the back panel (`back_gap`) and the section at the mouth, cut off
  at the bowed mouth, so no part of it stands out of the slot. Each
  section has a flat floor, a level upper edge and sloped ends with
  10 mm upper and 3 mm lower corner radii. 225 mm wide, 35 mm long in
  the middle, 25 mm at the ends, 23.5 mm high at the mouth.
- Play: 1.5 mm at each end (`side_clr`); in height 2.5 mm for two
  1 mm pads and 0.5 mm of play (`pad_t`, `plug_clr`).
- Pads: 1 mm felt or foam tape on the top and the bottom of the plug.
  They take up the play, stop rattling and keep the plastic off the
  trim.
- Indicator window: `lamp_w` > 0 cuts a tunnel `lamp_w` x `lamp_h`
  through the plug at `lamp_x`, so a lamp or marking on the back
  panel stays visible. Off by default because the position is not
  known. An assert keeps it clear of the neck.
- Neck: solid, 86 mm wide (`neck_w`), from inside the plug to the
  foot of the backrest 22 mm in front of the mouth (`neck_l`). It
  lies on the shelf in front of the mouth. The cradle may be wider
  than the neck: the horizontal cradle is 173 mm and overhangs the
  neck by 43.5 mm at each side, standing on its own foot.
  `cradle_x` moves neck and cradle along the slot; an assert keeps
  the neck under the level part of the mouth.
- Cradle: backrest 5 mm thick, leaning back 20 degrees (`tilt`);
  ledge 4 mm, filled down to Z = 0 as a foot; lip 3 mm thick in
  front of the phone.
- Lip: 12 mm high (`lip_h`) over 18 mm at each end (`corner_w`),
  5 mm between them (`lip_low`). The low part ends below the screen,
  so the gesture area at the lower screen edge stays free.
- Corner pockets: 3 mm side walls, 11 mm high, close the channel at
  both ends, so the phone cannot slide sideways. They stay below the
  side buttons.
- Cable window: 16 mm wide, straight down through ledge and foot in
  the middle. It opens 23 mm in front of the mouth, past the shelf.

Outer size (X, Y, Z): vertical 225.3 x 72.5 x 94.7 mm, 224 cm3
solid; horizontal 225.3 x 73.9 x 57.2 mm, 246 cm3 solid.

## How it holds

- The plug fills the funnel, so it cannot move sideways, up or down,
  and it cannot go in further than its shape allows.
- The phone, about 0.2 to 0.25 kg, sits 25 to 40 mm in front of the
  mouth. Its weight presses the front of the plug down on the trim
  and the rear of the plug up against the ceiling of the slot.
- Nothing stops the part from being pulled straight out. Braking
  pushes it into the slot; the pads hold it against acceleration.
- With the pads fitted the plug should go in with a light push and
  not rock. Too loose: thicker pads, or raise `mouth_h` and
  `back_ht`.
- An assert checks that the backrest stays 2 mm in front of the mouth
  up to 10 mm above the slot (`lip_clear`), so it does not lean into
  the edge of the dash. If the dash top rises behind its edge, raise
  `neck_l` or lower `tilt`.

## Parameters

`make phone-mount SCAD_ARGS='-D mouth_h=27 -D bow=8'` builds for other
numbers.

- `mouth_*`, `back_*`, `bow`, `slot_d`: the slot. Change these after
  the fit test.
- `lamp_w`, `lamp_x`, `lamp_h`, `lamp_z`: the indicator window.
- `cradle_x`: position of the cradle along the slot.
- `variant`: "vertical" or "horizontal".
- `body_l`, `body_w`, `body_t`, `case_side`, `case_back`, `play`:
  the phone and its case.
- `tilt`, `neck_l`, `neck_w`: how the phone stands.
- `lip_h`, `lip_low`, `corner_w`: the lip.

## Print notes

- Fit test first: `make phone-mount-fit` gives three flat rings, 2 mm
  thick, 13.2 cm3 together: the outline of the plug seen from the
  front, the outline of its rear end, and its outline seen from
  above. Hold the first against the mouth, push the second to the
  back of the slot, lay the third on the floor of the slot. Each
  should go in with about 1.5 mm of play at the ends.
- Orientation: as exported, the flat underside of the plug on the
  bed, 98 cm2 bed contact. No supports: the plug narrows upwards,
  the backrest and the lip lean 20 degrees, the ledge is filled down
  to the bed.
- Both variants are 225.3 mm long: on a 220 mm bed it goes diagonally; a 235 or 256 mm
  bed takes it straight.
- The layers lie across the backrest, the weak direction. The load is
  the phone leaning on it; do not lever on the backrest. 5 mm thick
  for that reason.
- Material: PETG at least, ASA or ABS better. A dashboard in the sun
  goes past 70 degrees C; PLA softens at about 55 and will sag.
- Four perimeters, 10 to 15 % infill; the plug is a large solid.

## Open

- Not printed. All slot numbers come from photos; `bow` is the least
  certain.
- No published dimensions of the slot were found (searched for the
  Kia Sportage of 2010 to 2015 and the related Hyundai ix35).
- Decided: no indicator window. The plug stays solid and covers the
  back panel with the passenger airbag lamp; the lamp is seen by
  pulling the plug out. `lamp_w`, `lamp_x` and `cradle_x` remain in
  the script, off.
- The slope of the slot floor is not known. It adds to or takes from
  the 20 degree tilt.
- The case is not measured; measure the phone in its case (width,
  length, thickness at the lower edge and at the camera) and set
  `case_side`, `case_back`.
- Vertical, the phone stands about 160 mm above the slot floor.
  Whether that blocks the view of the road depends on the seat
  position; horizontal is about 85 mm high.

## Security Note

No secrets and no network in this part. The safety points are
physical: the plug covers the back panel of the slot, where a
passenger airbag marking sits; if that is an indicator lamp it must
stay visible (`lamp_w`, `lamp_x`). The holder must not block the view
of the road and must sit clear of airbag covers. It is a friction
fit, not a tested mount: in a crash the phone and the holder can come
loose. PLA deforms in a hot car. Do not handle the phone while
driving.
