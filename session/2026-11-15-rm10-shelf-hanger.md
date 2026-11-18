# 2026-11-15 RM10 shelf hanger

New part, separate from the three-device mount of
session/2026-11-09-kvm-shelf-mount.md.

## Done

- `models/Comet-Pro-RM10-10inch-3d-printable-rack-mount-1-lot.stl`
  measured: 255 x 43.5 x 4 mm panel, 57.76 mm sleeve with an
  85 x 38.4 mm opening, lying at 45 degrees on the bed. Numbers in
  specs/rm10-shelf-hanger.md.
- `scripts/rm10_shelf_hanger.scad`: imports that mesh, cuts the panel
  to +-72 mm and adds a clip for the front edge of an 8 mm shelf:
  plate under the shelf, web, upper jaw reaching 40 mm, three ribs
  between sleeve and plate.
- `make rm10-hanger` builds `out/rm10-shelf-hanger.stl` and four
  previews; `make rm10-hanger-save` copies the STL to `models/`.
- `models/rm10-shelf-hanger.stl` saved: 144 x 62.2 x 57.8 mm as
  exported, 104.5 cm3, watertight.
- `scripts/rm10_shelf_hanger_plain.scad`: second variant with no
  holes. The sleeve is drawn from the measured inner outline of the
  rack mount (33 points), closed 2.4 mm walls, 2 mm air channels
  between ribs instead of vent slots, 45 degree wedge stops instead
  of the end lip, 120 mm wide clip. Does not import the source mesh.
- `make rm10-hanger-plain`, `make rm10-hanger-plain-save`;
  `models/rm10-shelf-hanger-plain.stl` saved: 120 x 64.7 x 59.5 mm as
  exported, 109.2 cm3, watertight, 1 cm2 of overhang.
- `make check` passes.

## Decisions

- Clip instead of screws: 8 mm of shelf holds little thread, the load
  is 170 g plus cables, and the shelf stays undrilled.
- Slot 8.3 mm; the hanger is held by its weight, not by clamping.
- Sleeve floor 48 mm under the shelf so the 47 mm head clears the
  shelf wherever it ends up; the gap above the sleeve keeps the top
  vents open.
- The upper jaw is built as a hull of boxes. A rotated extrusion left
  vertices a rounding error away from the web and the exported STL
  had edges shared by four and six faces.
- Printed on the front face like the source model, no new overhangs.
- Plain variant: slots and lip of the source are the only bridged
  features, so the sleeve is redrawn rather than patched. Cooling
  comes from channels that are open front and back, which need no
  bridging.

## Open

- Not printed. Shelf thickness and edge shape not measured.
- Plain variant: seat_d (55 mm) is read from the rounded lip of the
  source; temperature in the closed sleeve is untested.
- Licence of the source model unknown; source and derived STL are not
  committed. Nothing of this part is committed yet, and the KVM mount
  work of 2026-11-09 is still uncommitted in the same files
  (Makefile, specs/README.md, specs/printability.md, todo/todo.md).

## Files touched

- scripts/rm10_shelf_hanger.scad, scripts/rm10_shelf_hanger_plain.scad (new)
- models/rm10-shelf-hanger.stl, models/rm10-shelf-hanger-plain.stl (new)
- Makefile (rm10-hanger, rm10-hanger-save, rm10-hanger-plain, rm10-hanger-plain-save)
- specs/rm10-shelf-hanger.md (new), specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make rm10-hanger`, `make rm10-hanger-plain` and look at
  out/rm10-shelf-hanger-*.png
- `make printcheck MODEL=out/rm10-shelf-hanger-plain.stl`

## Next step

Measure the shelf, print one variant in PETG, test the clip and the
device fit.

## Security Note

No secrets in this work. The source STL is third-party data and is
only read as geometry (Python runs with -I). Its licence is not
recorded, so it stays out of git for now.
