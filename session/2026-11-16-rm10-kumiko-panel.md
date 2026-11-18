# 2026-11-16 RM10 kumiko panel

Continues session/2026-11-15-rm10-shelf-hanger.md. New part for the
hanger without holes.

## Done

- `scripts/rm10_kumiko_panel.scad`: front panel in the asanoha
  pattern, opening for the device, five 8 mm
  tabs that plug into the air channels of the sleeve. Geometry in
  specs/rm10-kumiko-panel.md.
- `scripts/rm10_shelf_hanger_plain.scad`: functions `hanger_face()`
  and `hanger_ribs()` added so the panel script reads the hanger
  numbers through `use`. The hanger geometry is unchanged.
- `make kumiko-panel` builds `out/rm10-kumiko-panel.stl` and three
  previews; `make kumiko-panel-save` copies the STL to `models/`.
- `models/rm10-kumiko-panel.stl` saved: watertight, no overhang.
- The cover is now an L of two flat panels: the front panel
  (152.8 x 70.7 mm, top edge level with the top of the jaw) and a top
  panel (152.8 x 56.5 mm) on the upper jaw. Two tenons on the front
  panel go through mortises in the top panel. Same triangle and width
  on both, so the pattern runs round the corner.
- Free corners rounded with a 10 mm radius: bottom of the front
  panel, back of the top panel. The corners at the joint are square.
- The STL holds both panels laid out for one print (two bodies,
  152.8 x 188.1 x 11 mm, 27.7 cm3); `part="front_panel"` and
  `part="top_panel"` export one each. Preview from above added.
- `make check` passes.

## Decisions

- A separate part in this repository, not a new repository: it needs
  the outline and the ribs of the hanger script and the same
  toolchain.
- Fixed by tabs in the existing air channels, so the hanger needs no
  change and no clip has to flex across its layers.
- No tab above the device and an opening as large as the cavity: the
  head of the device rises just in front of the hanger face.
- Panel size is derived from the pattern (rows, cols) so no triangle
  is cut at the frame.
- All bars flush at the front; the leaf bars are shallower at the
  back. A recess at the front would be bridged when printed face down.
- Two flat panels instead of one rigid L: the bar directions of the
  pattern are 30 degrees apart, so a standing lattice always has
  bars 30 degrees from the bed. Flat panels have no overhang.
- Tenons through mortises join the panels; no lips or clips on the
  top panel, it stays flat.
- Grid and leaf bars run on inside the frame to 1 mm from its outer
  edge; cut at the rounded inner edge they left non-manifold edges.
- Leaf bars reach 0.3 mm into the rim. Ending exactly on it
  left edges shared by four faces in the STL.

## Open

- Not printed; tab slack, tenon slack and head clearance untested.
- The top panel is held down by its weight only.
- Only for the plain hanger.
- Nothing of the RM10 parts is committed (see the 2026-11-15 note).

## Files touched

- scripts/rm10_kumiko_panel.scad (new)
- scripts/rm10_shelf_hanger_plain.scad
- models/rm10-kumiko-panel.stl (new)
- Makefile (kumiko-panel, kumiko-panel-save)
- specs/rm10-kumiko-panel.md (new), specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make kumiko-panel` and look at out/rm10-kumiko-panel-*.png
- `make printcheck MODEL=out/rm10-kumiko-panel.stl`

## Next step

Print the plain hanger and both panels, test tabs and tenons with the
device in.

## Security Note

No secrets in this work. The panel is decorative and gives no
physical protection.
