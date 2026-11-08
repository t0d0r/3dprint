# Drawer with the slope at the front

`make drawer-swap` builds `models/drawer-20cm-front-slope.stl` from
`models/drawer-20cm.stl` with `scripts/drawer_swap.py`.

## Goal

Same drawer, with the two ends exchanged: the back end is a vertical wall
at 90 degrees to the floor, the front end (behind the door) is the ramp
that used to be at the back. The door plate is unchanged. The slide rails
stay where they are on the original (decision 2026-11-08: the cabinet's
grooves are laid out for them).

## Geometry of the original

Axes as in the STL: X is the drawer's height (floor at high X, open edge
at low X), Y its width, Z its length. The door plate is at low Z.

- door plate 120 x 30 x 5.1 mm, inner face at z = 71.73
- body: floor 1.3 mm, side walls 21 mm down to the open edge, big
  (about 10 mm) rounds between floor and walls; the outer wall faces
  carry about 0.03 mm of tessellation noise (y 104.094 to 104.124)
- slide rails on the outside of both walls: 2.9 mm proud, 2.85 mm tall
  (x 515.4 to 518.2, i.e. 4 mm below the open edge), running from the
  door face to z = 245.4 (22 mm before the back end)
- back end: the floor bends up into a ramp at 33 degrees from the
  length axis, ending at the open edge; the walls are trimmed along it
  and their corners are rounded in plan view (about 12 mm)
- a fillet of about 3 mm radius where the body meets the door

## Method

1. Split at the door face: door = everything 0.02 mm inside the door
   plate; body = everything 3.5 mm past the door face (beyond the
   fillet). Cuts never lie on the door face itself: a coplanar cut keeps
   that face as a zero-thickness sheet.
2. Split the rails off the body. The core is the body clipped 0.005 mm
   inside the outermost points of the wall faces (so its outer faces are
   flat and no skin of rail material is left on them). The rails are
   everything outside the wall planes plus a 0.3 mm bite of wall,
   limited to the rails' own X band and length, so they overlap the
   wall when they are put back. Trying to split exactly on the wall
   plane left the rails separated from the wall by a few microns: the
   boolean union cannot fuse faces that are not exactly coplanar.
3. Extend the rails 0.3 mm into the door plate with a prism of their own
   profile, replacing the 3.5 mm lost to the fillet cut.
4. Mirror the core about its own mid-length, then push its ramp tip
   0.3 mm into the door plate.
5. Rebuild the 2.9 mm of length lost to the fillet cut by extruding the
   core's clean U profile (simplified to 0.02 mm; the raw section has
   about 1500 near-duplicate vertices).
6. Close the back with a 1.3 mm wall: the convex hull of the U profile,
   which is flush with the outer faces of the side walls because the
   core carries no rails.
7. Union core, fill, back wall, door, rails and rail extensions with
   manifold, then `Manifold.simplify(1e-3)`. Without the simplify step
   the boolean leaves slivers whose vertices merge when STL rounds to
   32-bit floats, and the reloaded mesh is no longer 2-manifold.
8. Checks on the reloaded output: watertight, one body, no face left
   inside the wall between a rail's bite and the core (that would mean
   an unfused rail), and genus 0 or 2 (see below).

## Result (2026-11-08)

- 30 x 120 x 201.1 mm, 68.3 cm3 (original 65.8), watertight, one body.
- Back wall 21.1 x 112.9 x 1.3 mm, flush with the walls, sharp corners
  in plan view (the original ramp tip had 12 mm rounds).
- Ramp descends from the floor to the door, meeting the door plate at
  its open-edge side.
- Rails at the original position: from the door face to z = 245.4,
  fused with the walls.
- Behind the door the rails stand free for about 15 mm: the mirrored
  ramp tip, with its rounded corners, is thinner there than the rails
  are tall, so each rail is backed only by the door until the ramp's
  underside drops below the rail band. Air passes over the rail into
  the space under the ramp, which makes the mesh genus 2 (one handle
  per side). Printed door-down, rail and ramp tip are separate islands
  for the first few millimetres and merge higher up; the slicer does not
  care. The rail's 0.3 mm bite shows as a step on its inner side in that
  stretch, under the ramp.
- Outer wall faces are 0.03 mm further in than the original's outermost
  points (flattened by the core clip). Below any printer's resolution.

## Printing

Standing on the door is still the only orientation without supports
for the body, but the inside of the new back wall is a flat
21 x 113 mm ceiling at the top of the print (21.8 cm2 facing down). The
original ramp at 33 degrees was self-supporting; a 90 degree wall is
not. Options, in order of preference:

1. Print it as a bridge: 113 mm span between the side walls, 1.3 mm
   thick, at the very end of the print. Expect some sagging on the
   inside of the back wall; the outside is unaffected. Use slow bridge
   speed and full part cooling.
2. Supports under the back wall only, which means supports rising
   about 190 mm from the door inside the tray. Lots of material and
   contact marks on the floor.
3. Change the design: a self-supporting inner slope would bring back
   the ramp in some form.

The rails rise straight from the door plate, so the free-standing
stretch behind the door prints without supports.

## Security Note

The script reads only mesh geometry with `python -I`. It writes a single
STL into `models/`.
