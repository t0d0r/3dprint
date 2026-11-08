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
- slide rails on the outside of both walls: 2.9 mm proud, 2.85 mm tall
  (x 515.4 to 518.2, i.e. 4 mm below the open edge), running from the
  door face to z = 245.4 (22 mm before the back end)
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
5. Side braces (added 2026-11-08, see below): extrude the wall band of
   the U profile (wall plus corner round, 12 mm wide) from 0.3 mm inside
   the door to 40 mm behind it, and foot it on the door with three
   1 mm steps that widen the band by 1, 2 and 3 mm on the inside.
6. Union with manifold, then `Manifold.simplify(1e-3)`. Without the
   simplify step the boolean leaves slivers whose vertices merge when
   STL rounds to 32-bit floats, and the reloaded mesh is no longer
   2-manifold. The script reloads its own output and asserts it is
   watertight.

## Result (2026-11-08)

- 30 x 120 x 201.1 mm, 70.1 cm3 with braces (original 65.8), watertight,
  one body, genus 0.
- Back wall 21.1 x 113.0 x 1.3 mm, flush with the walls, sharp corners
  in plan view (the original ramp tip had 12 mm rounds).
- Ramp now descends from the floor to the door, meeting the door plate
  at its open-edge side.
- Rails moved with the body: now 22 mm behind the door to 1 mm before
  the back (originally from the door face to 22 mm before the back).
  Decision 2026-11-08: they stay there. A variant with the rails at
  their original position was built and verified (commit 1a0004f) and
  then reverted on request; its downside was a 15 mm stretch behind the
  door where the rails stood free of the wall, because the mirrored ramp
  tip with its rounded corners is thinner there than the rails are
  tall. The reverted script can be recovered from git if needed.

## Front braces

Without them the mirrored body met the door plate only with the 1.3 mm
ramp tip and the two rounded wall corners, far too little to pull the
drawer by the plate (the original joined the door with the full U
profile and a 3 mm fillet). The braces continue both side walls, with
their corner round, at full height from the door to 40 mm behind it,
where the ramp has long merged with the floor; under the ramp they are
exposed as two triangular gussets that end in a curved lip at floor
level. The front corners are square again in plan view, like the
original's. Where they meet the door, three 1 mm steps on the inside
act as a 3 mm fillet (outside, the brace stays flush with the wall).

- 70.1 cm3 in all, 1.7 cm3 more than without braces.
- Each brace sits 0.1 mm inside the wall plane and 0.05 mm inside the
  other surfaces of the body, so it fuses with the existing wall instead
  of leaving a coplanar skin (the wall faces carry 0.03 mm of noise).
  Where the original rounded corner emerges from the brace, 8 to 20 mm
  behind the door, the wall is 0.1 mm proud of the brace: a ledge below
  a layer line.
- The U profile used for the braces still carries the rails, so the
  band is clipped to the inside of the wall planes; without that clip a
  0.05 mm fin of rail ran along each brace.
- Printed door-down all brace faces are vertical, and the steps widen
  towards the door, so nothing new needs support.

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
