# KVM shelf mount

Under-shelf mount for one GL.iNet Comet Pro (GL-RM10) and two JetKVM
Mini W, side by side in one row. Source: `scripts/kvm_shelf_mount.scad`.
Build: `make kvm-mount`; `make kvm-mount-save` copies the STL to
`models/kvm-shelf-mount.stl`.

## Requirement

- Holds one GL-RM10 and two JetKVM Mini W next to each other in one row.
- Fixed with screws to the underside of a shelf.
- The RM10 sticks out in front of the mount so the curve of its head
  stays visible.

## Devices

| device         | w x d x h mm  | weight | source                          |
|----------------|---------------|--------|---------------------------------|
| GL-RM10        | 84 x 93 x 47  | 170 g  | GL.iNet dimension drawing       |
| JetKVM Mini W  | 42 x 42 x 23  | n/a    | press coverage, September 2026  |

The RM10 is not a box. From the dimension and interface drawings on
the product page (scaled from the pictures, not measured on a unit):

- The screen face is 84 mm wide; the depth front to back is 93 mm. A
  first cut of the mount had the two swapped.
- Side profile: the rear body is about 37.5 mm tall over the rear
  56 mm. Then the top sweeps up to the 47 mm head, reached about
  17.5 mm behind the front edge. The screen face leans back; its lower
  edge is the foremost point, about 9 mm above the feet.
- Two foot rails under the body, about 2.5 mm tall, centred about
  16.5 mm in from each side.
- Vent slits along both sides, about 3 to 9 mm above the feet.
- All ports are on the back face: USB-A, USB-C, reset and USB-C power
  in the upper row, Ethernet, HD OUT and HD IN in the lower row. The
  outer 9 mm at each side of the back face are free.

For the Mini W no source says on which face the ports and buttons
sit. It is described with the screen on its 42 x 42 top face and
buttons on a side. The front and the back of every bay are fully open
so the design does not depend on that.

## Geometry

Frame: X along the row, Y from the front (0) to the back, Z up, shelf
underside at Z = 0.

- Order: mini, RM10, mini. Symmetric, and the heavy device hangs in the
  middle between the two ears.
- Top plate 209 x 60.5 x 3 mm against the shelf. It closes the bays
  into tubes, which makes the row stiff with screws only at the ends.
- Ears: the plate goes on 13 mm beyond each outer wall, 4 mm thick
  there. Two holes per ear, 14 mm from the front and from the back
  edge: 4.5 mm clearance, 8.5 mm countersink on the underside, for
  4 mm countersunk wood screws. The part is 209 mm wide, inside a
  220 mm bed.
- Bays, inside: mini 43 x 23.6 mm, RM10 85 x 47.6 mm (0.5 mm slack per
  side, 0.6 mm above the device). Walls and floors 3 mm. The RM10 bay
  keeps the full 47.6 mm under the plate although only the 37.5 mm
  rear body is inside it: the head in front of the mount is 47 mm
  tall and must still clear the shelf.
- RM10 overhang (`rm_out`): the device sticks out 37 mm in front of
  the mount, which is where its top starts to rise, so the whole head
  and the leaning screen are in front of the walls. 56 mm of the body
  stay on the floor, with the foot rails on it from 37 to about 84 mm
  behind the front edge of the device. `rm_out = 0` puts the whole
  device back in the bay.
- Hold-down ribs: two 3 mm ribs hang from the plate along the depth
  of the RM10 bay, down to 1.5 mm above the rear body, with a 3 mm
  lead-in chamfer at the front. With 40% of the device in front of
  the floor a pull on the screen or a push on the back could tip it;
  the ribs stop that and keep the air gap above the body open. The
  1.5 mm slack is large because the body height is scaled from a
  picture.
- Depth: the RM10 bay and the plate are 60.5 mm (93 device less 37
  overhang, 0.5 slack, 4 stop). The
  mini bays are 44.5 mm (42, 0.5, 2) and flush with the front, so a
  mini does not sit at the end of a tunnel. Behind the mini bays there
  is only the plate; the mini cables leave there.
- The mini floors are 24 mm above the RM10 floor; the space under them
  is open.
- Stops: two triangular wedges per bay, on the side walls at the back
  end, full bay height, reaching in 4 mm (RM10) and 2 mm (mini). They
  grow at 45 degrees towards the back so they print without support.
  The device edge meets the start of the slope. A stop covers the
  outer 4 mm (2 mm) of the back face at each side; everything between
  stays open for the ports.
- Nothing holds a device at the front; it rests on the floor and the
  cables hold it against the stops. Plugging a cable in pushes the
  device forward, hold it while doing so.
- Lead-in: every bay opens by 0.8 mm over the first 3 mm, which also
  absorbs the elephant foot of the first layers.
- RM10 floor: three 8 x 32.5 mm slots along the depth in the middle,
  24 mm solid at each side so the foot rails (14 to 20 mm in) never
  sit over a slot. Two 8 mm slots in each RM10 bay wall, 2 to 10 mm
  above the floor, below the mini floors, in front of the side vents.
- The RM10 sits on its feet, so its screen leans up towards the shelf
  edge. Hung with the feet up the screen would lean down, but the
  image would be upside down; not designed for.
- Mini floor: 30 mm window with 45 degree back corners, 6.5 mm ledges.
  A mini laid screen down shows its display from below.

Outer size 209 x 60.5 x 53.6 mm, 86.5 cm3. With the RM10 in place the
assembly is 97.5 mm deep. Place the mount at least 37 mm behind the
shelf edge if the head should stay under the shelf.

## Print notes

- Orientation: standing on the front face (the STL is exported that
  way), 209 x 53.6 mm on the bed, 60.5 mm tall. No supports: walls,
  floors and plate are vertical, slots bridge 8 mm, the mini windows
  bridge 12 mm, the screw holes are horizontal 4.5 mm holes.
- Material: PETG or ABS/ASA. The RM10 surface is reported at 45 to
  50 C after a day of running, close to where PLA creeps under load.
- 3 perimeters. A brim helps: the contact area is thin strips.
- Screws: 4 mm countersunk wood screws, length = 4 mm ear plus the
  shelf thickness minus 3 mm (4 x 16 for an 18 mm shelf).

## Open

- Measure both devices and set `rm_*`, `mini_*` before printing; a
  rounded edge can make a device smaller than the listed size, a foot
  can make it taller.
- Find the port faces of the Mini W. If it has ports on opposite faces
  one set points to the front. Side buttons and a card slot on a side
  face are covered by the bay walls while the mini is in the bay.
- The RM10 profile numbers are scaled from pictures. Measure the
  height of the rear body (`rm_body_h`, sets the hold-down ribs) and
  where the top starts to rise (`rm_rise_d`, the limit for `rm_out`).
- Whether the RM10 has vents in its underside is not known.

## Security Note

Two KVM-over-IP devices give full keyboard, video and mouse control of
the attached machines; mounting them does not change that. Keep them
on a management network or behind a VPN, with firmware current and
default passwords changed. An open shelf mount gives no physical
protection: anyone at the desk can unplug or swap a device.
