# 2026-11-16 Deco arm platform

New part, independent of the earlier ones.

## Done

- `scripts/deco_arm_platform.scad`: platform for a TP-Link Deco
  (110 mm cylinder) on the swivel knuckle of a monitor arm. Tray with
  a saddle of two split cheeks, a pocket for the pin cap and one
  cable tie; separate loose rim band.
- Saddle turned by `arm_angle` (90): seen from above, the link to the
  VESA head and the spring arm meet at 90 degrees, and the cheeks
  follow the knuckle towards the spring arm.
- `make deco-platform` builds `out/deco-arm-platform-{tray,rim}.stl`
  and four previews; `make deco-platform-fit` builds the saddle test
  piece; `make deco-platform-save` copies the STLs to `models/`.
- `models/deco-arm-platform-tray.stl` (114.4 x 114.4 x 14 mm,
  41.6 cm3) and `models/deco-arm-platform-rim.stl`
  (118.7 x 118.7 x 10 mm, 10.2 cm3) saved, both watertight.
- specs/deco-arm-platform.md written; printability results added.
- `make check` passes.

## Decisions

- Arm dimensions come from ruler photos, +-4 mm. They are defaults;
  a fit piece of the saddle is printed before the tray.
- Cheeks and a cable tie instead of a snug socket: the tie takes up
  what the estimates miss, and the arm stays unchanged.
- Rim as a separate band: the tray prints on its flat top face with
  no supports. A one-piece tray with a rim needs supports under the
  whole floor; a pedestal with 45 degree flanks came out 25 to 50 mm
  tall and 165 cm3.
- The tie crosses the top face in a groove so the Deco stands flat.
- Tray axis 10.35 mm further from the plate than the pin axis, so
  the rim clears the plate by 2 mm.
- Plate-side cheek has no front segment, to leave room for the link
  to the head.

## Open

- Not printed. `knuckle_w`, `knuckle_len`, `boss_d`, `boss_h`,
  `pin_to_plate` are not measured with calipers.
- Which arm part carries the pin cap and how far the head swivels is
  not confirmed.
- The KVM mount and RM10 hanger work is still uncommitted in
  Makefile, specs/README.md, specs/printability.md and todo/todo.md;
  the commit of this part holds only its own lines of those files.

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

Print the fit piece, try it on the knuckle, correct the arm
parameters, then print tray and rim.

## Security Note

No secrets in this work. The platform carries network equipment on a
movable arm; a fall can unplug it. Check the cable tie and leave
slack in the cables.
