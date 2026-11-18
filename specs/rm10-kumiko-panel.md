# RM10 kumiko panel

Decorative kumiko cover for the RM10 shelf hanger without holes
(specs/rm10-shelf-hanger.md, variant without holes). A separate part:
the hanger works without it. Source: `scripts/rm10_kumiko_panel.scad`.
Build: `make kumiko-panel`; `make kumiko-panel-save` copies the STL to
`models/rm10-kumiko-panel.stl`.

## Requirement

- A panel for the front of the hanger, fixed to the hanger.
- The panel is a kumiko lattice.
- The cover is L-shaped: it also covers the top of the clip, the
  upper jaw that lies on the shelf.
- Rounded corners, radius 10 mm or what suits.

## Geometry

Frame as the hanger: X along the shelf edge, Y to the back with the
hanger front face at Y = 0, Z up, shelf underside at Z = 0.

- Pattern: asanoha (hemp leaf). A grid of equilateral triangles, each
  with three bars from its centre to its corners.
- Two flat panels make the L: a front panel against the front face
  of the hanger and a top panel on the upper jaw. One rigid L was
  rejected: the six bar directions of the pattern are 30 degrees
  apart, so a lattice printed standing always has bars 30 degrees
  from the bed, whichever way it is turned. Printed flat it has no
  overhang.
- Corner joint: two tenons on the top edge of the front panel, 10 mm
  wide, 2 mm thick, 3 mm tall, 40 mm left and right of the middle,
  go through two mortises in the top panel (0.15 mm slack each side)
  and end flush with its top face. They fix the top panel sideways
  and front to back; its weight keeps it down.
- The corner of the L is square: the top panel lies on the top edge
  of the front panel and reaches 1.5 mm in front of it.
- Size follows the pattern, and both panels use the same triangle
  and the same width so the pattern runs round the corner. Front
  panel: 4 rows over the height and 8 triangle sides over the width,
  inside a 4 mm frame. Its height is the hanger face (64.7 mm) plus
  6 mm below, 70.7 mm; its top edge is level with the top of the
  jaw. That gives triangles 15.7 mm tall with 18.1 mm sides and a
  width of 152.8 mm, 16.4 mm beyond the 120 mm face at each side.
  Top panel: 3 rows, 56.5 mm deep, with a 5.5 mm frame at the front
  edge for the mortises. It covers the 44 mm jaw and 8 mm of shelf
  behind it. Beside the jaw it is 4.3 mm above the shelf.
- Rounded corners, radius 10 mm (`corner_r`), on the free corners:
  the two bottom corners of the front panel and the two back corners
  of the top panel. The frame keeps its 4 mm width round them. The
  four corners at the joint stay square so the panels meet along a
  straight edge.
- Frame, rim and grid bars are 3 mm thick; grid bars 1.6 mm wide.
  Leaf bars are 1 mm wide and 2 mm thick. All bars are flush at the
  visible face, the print face; real kumiko sets the leaf bars back
  there, which would need bridging here.
- Opening in the front panel: the outline of the sleeve cavity,
  89 x 42.3 mm, with a 3 mm solid rim. It is the cavity and not the
  device outline because the head of the device rises just in front
  of the hanger face; the 2 mm all round are the room for that.
- Fixing of the front panel: five tabs on the back, 8 mm long,
  pushed into the air channels of the sleeve between its ribs: one
  under the device (17 mm wide), one in each lower corner, one at
  each side. A tab is 1.7 mm thick in a 2 mm channel (0.1 mm slack
  to the wall, 0.2 mm to the device outline) and keeps 0.4 mm from
  the ribs. No tab above the device, for the same reason as the
  opening. With the device in, the tabs are trapped between the
  device and the sleeve wall.
- The tabs close about a fifth of the channel cross-section at the
  front.
- Grid and leaf bars run on inside the frame to 1 mm from its outer
  edge. Cutting them at the inner edge of the frame left edges shared
  by four faces in the STL.
- The script takes the sleeve outline, gap, ribs and face size from
  `scripts/rm10_shelf_hanger_plain.scad` through `use`. A `-D`
  override of a hanger parameter does not reach the panels; change
  the hanger file instead.

Front panel 152.8 x 73.7 x 11 mm with tenons and tabs, 14.3 cm3. Top
panel 152.8 x 56.5 x 3 mm, 13.4 cm3.

## Assembly

1. Push the front panel onto the hanger, tabs into the sleeve.
2. Lay the top panel on the jaw and over the two tenons.
3. Slide the device in.

The hanger goes onto the shelf first; the top panel lies on the jaw,
not under it.

## Print notes

- The STL holds both panels, visible faces on the bed, tabs up,
  152.8 x 188.1 mm on the bed. `-D 'part="front_panel"'` or
  `"top_panel"` exports one of them. No overhangs, no supports.
- The visible faces show the bed surface; a textured plate suits it.
- A colour that contrasts with the hanger shows the pattern where
  the hanger is behind the lattice.
- PLA is enough: the panels carry no load. The tabs sit next to the
  device, so PETG if the device runs warm.
- 0.4 mm nozzle: the 1 mm leaf bars are two perimeters. The slicer
  must not drop them as thin walls.

## Open

- Not printed. The tab slack is a first value; if the panel is loose
  lower `tab_out`, if it does not go in raise it. The same for the
  mortises and `tenon_clr`.
- The top panel is only held down by its weight (about 6 g). A drop
  of glue on the tenons fixes it for good.
- The start of the head rise is scaled from pictures. If the head
  touches the rim, widen the opening at the top.
- Does not fit the hanger made from the rack mount (no channels to
  take the tabs).

## Security Note

A decorative part with no security function. It does not lock the
device in: panel and device come out by hand. The KVM itself still
belongs on a management network or behind a VPN.
