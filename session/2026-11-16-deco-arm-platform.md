# 2026-11-16 Deco arm platform

New part, independent of the earlier ones.

## Done

- `scripts/deco_arm_platform.scad`: platform for a TP-Link Deco
  (110 mm cylinder) on the swivel link of a monitor arm. Tray with a
  7 mm pad on the flat top of the link, one cheek on the side away
  from the plate, a pocket for the pin cap and one cable tie;
  separate loose rim band.
- First version (commit d35a517) used arm numbers from photos taken
  at an angle and a saddle with two cheeks directly under the floor.
  Reworked from three straight ruler photos: link 26 mm wide, flat
  top 13 mm behind and 31 mm in front of the pin axis, elbow housing
  5 mm above it, pin 57 mm from the plate.
- `make deco-platform` builds `out/deco-arm-platform-{tray,rim}.stl`
  and four previews; `make deco-platform-fit` builds the saddle test
  piece; `make deco-platform-save` copies the STLs to `models/`.
- `models/deco-arm-platform-tray.stl` (114.4 x 114.4 x 19 mm,
  50.0 cm3) and `models/deco-arm-platform-rim.stl`
  (118.7 x 118.7 x 10 mm, 10.2 cm3) saved, both watertight.
- specs/deco-arm-platform.md written; printability results added.
- `make check` passes.

## Decisions

- The arm is an L in plan: head block straight back from the plate
  to the pin, link along the plate to the elbow. The saddle sits on
  the link and is turned by `arm_angle` (90).
- Pad between link and floor: the elbow housing stands above the
  flat top and the head block swivels at the level of the top, so
  the floor is lifted 7 mm over both.
- No cheek on the plate side: the head block is there. The cable tie
  in its 2.5 mm slot holds the tray on that side.
- Cheek 8 mm tall, within the 10 mm top cap of the fork, so it stays
  off the swivel ring of the head block. The tie sits beyond the
  ring for the same reason.
- Deco axis 9 mm along the link from the pin, over the middle of the
  flat top, and 4.35 mm away from the plate so the rim clears it by
  2 mm.
- Rim as a separate band: the tray prints on its flat top face with
  no supports. A one-piece tray with a rim needs supports under the
  whole floor; a pedestal with 45 degree flanks came out 25 to 50 mm
  tall and 165 cm3.
- The tie crosses the top face in a groove so the Deco stands flat.
- A fit piece of the saddle is printed before the tray.

## Open

- Not printed. The arm numbers are photo readings, about +-1.5 mm.
- Deco diameter taken as 110 mm; the device model is not confirmed.
- Height of the elbow housing, width of the head block and the swivel
  range with the tray in place are not confirmed.
- The KVM mount and RM10 hanger work is still uncommitted in
  Makefile, specs/README.md, specs/printability.md and todo/todo.md;
  the commits of this part hold only its own lines of those files.

## Files touched

- scripts/deco_arm_platform.scad (new)
- models/deco-arm-platform-tray.stl, models/deco-arm-platform-rim.stl (new)
- Makefile (deco-platform, deco-platform-fit, deco-platform-save)
- specs/deco-arm-platform.md (new), specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make deco-platform` and look at
  out/deco-arm-platform-{part,assembly,side,below}.png
- `make deco-platform-fit`
- `make printcheck MODEL=out/deco-arm-platform-tray.stl`

## Next step

Print the fit piece, try it on the link, correct the arm parameters,
then print tray and rim.

## Security Note

No secrets in this work. The platform carries network equipment on a
movable arm; a fall can unplug it. Check the cable tie and leave
slack in the cables.
