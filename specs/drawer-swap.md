# Drawer with the slope at the front

`make drawer-swap` builds `models/drawer-20cm-front-slope.stl` from
`models/drawer-20cm.stl` with `scripts/drawer_swap.py`.

## Goal

Same drawer, with the two ends exchanged: the back end is a vertical wall
at 90 degrees to the floor, the front end (behind the door) is the ramp
that used to be at the back. The door plate is unchanged.

## Geometry of the original

Axes as in the STL: X is the drawer's height (floor at high X, open edge
at low X), Y its width, Z its length. The door plate is at low Z.

- door plate 120 x 30 x 5.1 mm, inner face at z = 71.73
- body: floor 1.3 mm, side walls 21 mm down to the open edge, big
  (about 10 mm) rounds between floor and walls
- slide rails 0.6 mm proud on the outside of both walls, 4.4 mm from
  the open edge, z 129.5 to 245.3 (58 mm behind the door to 22 mm
  before the back)
- back end: the floor bends up into a ramp at 33 degrees from the
  length axis, ending at the open edge; the walls are trimmed along it
- a fillet of about 3 mm radius where the body meets the door

## Method

1. Split at the door face: door = everything 0.02 mm inside the door
   plate; body = everything 3.5 mm past the door face (beyond the
   fillet). Cuts never lie on the door face itself: a coplanar cut keeps
   that face as a zero-thickness sheet.
2. Mirror the body about its own mid-length, then push its ramp tip
   0.3 mm into the door plate.
3. Rebuild the 2.9 mm of length lost to the fillet cut by extruding the
   body's clean U profile (simplified to 0.02 mm; the raw section has
   about 1500 near-duplicate vertices).
4. Close the back with a 1.3 mm wall: the convex hull of the U profile,
   clipped flush with the outer faces of the side walls so it does not
   follow the rails.
5. Union with manifold, then `Manifold.simplify(1e-3)`. Without the
   simplify step the boolean leaves slivers whose vertices merge when
   STL rounds to 32-bit floats, and the reloaded mesh is no longer
   2-manifold. The script reloads its own output and asserts it is
   watertight.

## Result (2026-11-08)

- 30 x 120 x 201.1 mm, 68.4 cm3 (original 65.8), watertight, one body.
- Back wall 21.1 x 113.0 x 1.3 mm, flush with the walls, sharp corners
  in plan view (the original ramp tip had 12 mm rounds).
- Ramp now descends from the floor to the door, meeting the door plate
  at its open-edge side.
- Rails moved with the body: now z 93.9 to 266.5, i.e. 22 mm behind the
  door to 1 mm before the back. If the cabinet's grooves depend on the
  original rail position, the rails must be kept in place instead (cut
  them off before mirroring and union the originals back).

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

## Security Note

The script reads only mesh geometry with `python -I`. It writes a single
STL into `models/`.
