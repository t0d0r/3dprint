# RM10 shelf hanger

Hanger that holds one GL.iNet Comet Pro (GL-RM10) under a shelf. It is
the 10 inch rack mount
`models/Comet-Pro-RM10-10inch-3d-printable-rack-mount-1-lot.stl` with
the rack ears cut off and a clip for the shelf edge added. Source:
`scripts/rm10_shelf_hanger.scad`. Build: `make rm10-hanger`;
`make rm10-hanger-save` copies the STL to `models/rm10-shelf-hanger.stl`.

The rack mount model is third-party and is not part of the repository.
It and `models/rm10-shelf-hanger.stl`, which contains its sleeve, are
listed in `.gitignore` and exist only in the local working tree.
`make rm10-hanger` needs the rack mount STL at the path above; a fresh
clone has to get the file from its original source first. The plain
hanger (`make rm10-hanger-plain`) does not import it.

## Requirement

- Reuses the sleeve of the rack mount, which is fitted to the device.
- Hangs from a shelf 8 mm thick.

## Source model

Measured from the mesh (it lies at 45 degrees on the bed):

- Front panel 255 x 43.5 x 4 mm with four rack slots, 10 x 6.5 mm.
- Sleeve behind the panel, 57.76 mm from the panel front face to its
  end, opening 85 x 38.4 mm, walls about 2 mm. The end of the sleeve
  turns inwards by about 3 mm; that lip stops the device.
- The floor of the sleeve has two channels for the foot rails, 18 to
  30 mm each side of the middle. That fixes which side is down.
- Vent slots in every wall of the sleeve. The top slots run 2 to 17 mm
  each side of the middle.
- Two gusset fins at each side between sleeve and panel, out to
  71.2 mm from the middle.
- Sleeve floor 1.95 mm above the lower panel edge; sleeve top 40.52 mm
  and upper panel edge 41.55 mm above the sleeve floor.
- Only the rear body of the device (about 37.5 mm tall) is in the
  sleeve. The 47 mm head with the screen stays in front of the panel.

## Geometry

Frame: X along the shelf edge, Y from the panel front face (0) to the
back, Z up, shelf underside at Z = 0.

- Cut: the panel is kept from -72 to +72 mm, which removes the rack
  ears and slots and keeps the gussets. Width 144 mm.
- Fixing: a clip pushed onto the front edge of the shelf, no screws.
  An 8 mm shelf leaves about 6 mm of thread for a wood screw, and a
  clip needs no holes in the shelf. The device weighs 170 g.
- Plate under the shelf: 144 x 57.76 x 4 mm, as long as the sleeve.
- Web: the panel continues upwards, 4 mm thick, in front of the shelf
  edge. Panel and web are one flat face, the print face.
- Upper jaw: 144 mm wide, 4 mm thick, reaches 40 mm over the shelf,
  2 mm lead-in chamfer at its tip.
- Slot 8.3 mm (`shelf_t` + `clip_clr` 0.3). The hanger is held by its
  weight, not by clamping: the jaw rests on the shelf and the plate
  bears against the underside. With 0.3 mm of slack it tilts by less
  than half a degree.
- Height: the sleeve floor is 48 mm under the shelf (`rm_h` 47 +
  `head_clr` 1), so the head would clear the shelf even if it were
  under it. This leaves a 3.5 mm air gap between the sleeve top and
  the plate, open at the back, above the top vent slots.
- Ribs: three 3 mm ribs along the depth join the sleeve top to the
  plate, at X = 0 and +-24 mm, on the solid strips beside the top
  slots, sunk 0.8 mm into the sleeve wall.
- The shelf edge sits 4 mm behind the panel face. The head of the
  device is about 37 mm in front of the panel, so about 41 mm in front
  of the shelf edge.

Outer size 144 x 57.8 x 62.2 mm (width, depth, height), 104.5 cm3.
The hanger reaches 50 mm below the shelf and 12.3 mm above its
underside.

## Variant without holes

Source: `scripts/rm10_shelf_hanger_plain.scad`. Build:
`make rm10-hanger-plain`; `make rm10-hanger-plain-save` copies the STL
to `models/rm10-shelf-hanger-plain.stl`.

Requirement: a part with no holes to print. The sleeve of the rack
mount has vent slots in every wall and a lip at its end; both are
bridged or overhang when printed. This variant has neither.

- The sleeve is drawn in the script, not imported. Only the inner
  outline of the rack mount sleeve is reused, as 33 points measured
  from the mesh at 30 mm depth (85 x 38.3 mm, foot channels 18 to
  30 mm from the middle). The mesh is not needed to build.
- Closed walls 2.4 mm. No rack panel, ears or gussets: the front
  panel is 120 mm wide and is one piece with the web of the clip.
- Air instead of slots: the sleeve is 2 mm (`gap`) larger than the
  outline all round. The device rests on 3 mm ribs that run front to
  back: four below, four above (X = +-10 and +-36 mm, clear of the
  foot rails) and two at each side (12 and 26 mm above the sleeve
  floor). The channels between the ribs are open at the front and at
  the back, also in front of the side vents of the device (3 to 9 mm
  above the feet).
- Stops instead of the lip: one wedge on each side wall, 10 to 28 mm
  above the sleeve floor, growing towards the back at 45 degrees and
  reaching 4 mm over the back face of the device. The device back
  face sits 55 mm behind the panel face (`seat_d`), where the lip of
  the rack mount holds it, plus 0.5 mm slack.
- The sleeve top is joined to the plate by a solid block; there are
  no top slots to keep open.
- The opening is 0.4 mm larger over the first millimetre against the
  elephant foot.
- Clip as above, 120 mm wide: slot 8.3 mm, jaw 40 mm.

Outer size 120 x 59.5 x 64.7 mm (width, depth, height), 109.2 cm3.
It reaches 52.4 mm below the shelf.

Print: on the front face. Every wall is vertical; the stops and the
jaw tip grow at 45 degrees. No bridges, no supports.

Open for this variant:

- The sleeve is closed, so cooling depends on the 2 mm channels. Check
  the device temperature after some hours; widen `gap` if it runs
  hotter than in the open.
- `seat_d` is read from the lip of the rack mount, which is rounded.
  If the head does not come up to the panel, shorten `seat_d`.

## Parameters

`make rm10-hanger SCAD_ARGS='-D shelf_t=10'` builds for another shelf.
`grip_d` sets the reach of the upper jaw, `clip_clr` the slack,
`half_w` the width of the cut.

## Print notes

- Orientation: on the front face (the STL is exported that way), as
  the rack mount is printed. 144 x 62.2 mm on the bed, 57.8 mm tall.
  Plate, web, jaw and ribs are vertical walls or lie on the bed. The
  only overhangs are those of the source model: its slots and the lip
  at the end of the sleeve.
- Layers run across both jaws, the weak direction for a clip. The
  load is small (about 90 N mm from the device and its cables), but do
  not lever the clip open; push it straight on.
- Material: PETG or ABS/ASA; the device surface is reported at 45 to
  50 C, close to where PLA creeps.

## Open

- Measure the shelf. If the clip is tight or loose, change `clip_clr`.
- The edge of the shelf must be free for 144 mm and square; a rounded
  or profiled edge needs a different web.
- Not printed yet; the fit of the device is that of the source model.
- The licence of the source model is not recorded. The source STL and
  the derived STL are not committed until it is known.

## Security Note

A KVM-over-IP device gives full keyboard, video and mouse control of
the attached machine. Keep it on a management network or behind a VPN,
with current firmware and a changed default password. A clip without
screws gives no physical protection: the device and the hanger can be
taken off the shelf by hand. The source STL is third-party data; the
scripts only read its geometry.
