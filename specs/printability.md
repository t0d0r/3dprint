# Printability check

`make printcheck MODEL=<file> [BED="x y z"]` runs `scripts/printability.py`.
Default bed is 220 x 220 x 250 mm.

## What it reports

- Mesh health: watertight, consistent winding, volume.
- For each of the six axis-aligned orientations, with the part resting on
  the bed: fits the bed (either way round), height, footprint, bed
  contact area, overhang area (faces tilted more than 45 degrees past
  vertical, first layer excluded) and a rough support volume (overhang
  area times height). Rows are sorted best first.
- Wall thickness: rays cast inward from 20000 sampled surface points.
  Reports min, 5th percentile, median and the share of surface thinner
  than 0.8 mm (two 0.4 mm perimeters).

## Limits

- Only axis-aligned orientations are tried. Tilted orientations are left
  to the slicer's auto-orient.
- Support volume is a ranking metric, not a filament estimate.
- Thickness by ray casting measures local thickness at sampled points;
  it can miss very small features and reports glancing hits on fillets
  as thin.

## Results

### models/drawer-20cm.stl (2026-11-08)

- Open-front tray: 120 x 201 mm back plate, 30 mm deep side walls and
  floor, chamfered top on the sides, lip at the base, vertical groove on
  the outside of one side wall. Walls about 1.27 mm.
- Orientation: as modelled, base lip on the bed. Fits the bed, zero
  overhangs, no supports, 33.5 cm2 bed contact. Every other orientation
  needs supports.
- 201 mm tall on a 30 x 120 mm footprint: use a brim or good adhesion
  and moderate speed; wobble at height is the main risk.
- 0.2% of the surface is thinner than 0.8 mm (min 0.62 mm), on the back
  plate. Print with 3 perimeters at 0.4 mm and thin-wall detection on;
  no model change needed.
- Rough weight 29 g PLA; the slicer gives the real number.

### models/drawer-20cm-front-slope.stl (2026-11-08)

- Built by `make drawer-swap`, see specs/drawer-swap.md.
- Orientation: still door down. 21.8 cm2 of downward-facing surface at
  the top: the inside of the new back wall, which must bridge 113 mm
  between the side walls. All other orientations are worse.
- Wall thickness unchanged by the swap or the front braces: median
  1.30 mm, min 0.63 mm on the rails, 0.2% under 0.8 mm.
- 70.1 cm3 with the front braces, about 31 g PLA rough.

### out/macbook-stack-stand-left.stl, -right.stl (2026-11-09)

- Built by `make macbook-stand`, see specs/macbook-stack-stand.md.
- 185 x 51.5 x 31 mm as exported, 58.2 cm3 each, watertight, one body
  (100 mm rail with end pads, 80 mm bar with its own window, cross
  plate, two screw holes).
- Orientation: as exported, lying on the shelf tips. No supports,
  7.5 cm2 bed contact in strips; brim recommended.
- The check ranks this orientation below standing on end, because it
  counts every downward face as overhang and does not know bridges:
  41 cm2 is bridged with both ends supported (three 48 mm rib bridges
  in the rail at 14 mm, the 56 mm rib of the bar at 9 mm, 16 mm
  bridges across the channels at 15 mm), the rest is the 45 degree
  flanks.
  Standing on end leaves the arms of the cross plate unsupported
  180 mm above the bed and makes a 185 mm tall print on a 31 x 51.5 mm
  footprint.
- Thinnest structural section 4.0 mm (the wall); the shelves are 5,
  9.5 and 5 mm, 4.2, 7.9 and 4.2 mm at the flared front end, with
  3 mm root fillets. 0.1% of the surface reads under 0.8 mm: feather edges where
  the screw head pockets run out through the sloped foot and where
  the 45 degree cuts meet the rounded shelf tips.
- About 72 g PLA each if printed solid; one left and one right.

## out/car-phone-mount-vertical.stl, -horizontal.stl

- Vertical 225.3 x 72.5 x 94.7 mm, 224 cm3 solid; horizontal
  225.3 x 73.9 x 57.2 mm, 246 cm3 solid. As exported (car frame,
  underside of the plug on the bed), both watertight.
- As exported: 99 and 117 cm2 bed contact, 0.4 cm2 of downward face,
  no supports. Neither fits a 220 mm bed straight; both fit
  diagonally, or straight on 235 mm and larger.
- Layers lie across the 5 mm backrest (specs/car-phone-mount.md).
- About 97 and 107 g at 20% infill by the rough factor; 10 to 15% is
  enough. PETG or ASA, not PLA: the part sits on a dashboard in the
  sun.
- Fit test `out/car-phone-mount-fit.stl`: three flat rings, 2 mm
  thick, 225.3 x 92.8 mm, 13.0 cm3. The same for both variants.

## out/tube-clip.stl

- Two clips, 60 x 63.2 x 40 mm as exported (standing on an end face),
  24.7 cm3 together, watertight.
- As exported: 6.2 cm2 bed contact, no supports. The 0.3 cm2 reported
  as overhang are the upper halves of the four 3.8 mm screw holes,
  which lie horizontally. Every
  other orientation needs supports and puts the layers across the
  snap arm.
- Wall thickness min 1.18 mm (pad under the countersinks), 5th
  percentile 2.40 mm (the ring), median 3.00 mm.
- About 11 g at 20% infill by the rough factor for both; PETG
  recommended (specs/tube-clip.md).

## out/tube-edge-clip.stl

- Two clips, 86 x 39.9 x 52 mm as exported (standing on the front
  face of the web), 37.9 cm3 together, watertight.
- As exported: 14.9 cm2 bed contact, no overhang, no supports. Every
  other orientation needs supports.
- Wall thickness 5th percentile 2.40 mm (the ring), median 4.00 mm;
  the 0.09 mm minimum is the feather edge where the bump runs out
  into the jaw.
- About 17 g at 20% infill by the rough factor for both; PETG
  recommended (specs/tube-clip.md).

## out/deco-arm-platform-tray.stl, out/deco-arm-platform-rim.stl

- Tray as exported (top face down): 114.4 x 114.4 x 19 mm, 39.7 cm3,
  watertight. 75 cm2 on the bed (vent windows open), 1.8 cm2 of overhang (the tie
  groove, a 7 mm bridge), no supports. Thinnest wall 1.0 mm, the pad
  beside the pin cap pocket; floor 4 mm.
- Rim as exported (upper edge down): 118.7 x 118.7 x 10 mm, 10.2 cm3,
  watertight, no overhang. Wall 2.0 mm.
- Fit piece: 45 x 52 x 19 mm, 18 cm3.
- Arm dimensions are photo readings; print the fit piece first
  (specs/deco-arm-platform.md).

## out/lamp-charger-stand-sides.stl, out/lamp-charger-stand-top.stl

- Built by `make lamp-stand`, see specs/lamp-charger-stand.md.
- Side walls as exported (skirt down): two bodies, 144 x 195.4 x
  73 mm, 58.5 cm3, watertight. 11.5 cm2 on the bed, a 2.4 mm strip:
  brim. 39.8 cm2 counted as overhang: the undersides of the relief
  bars and the inside of the wall near the rear ends, which leans 44
  degrees from the vertical. No supports.
- Skin 1.2 mm measured level; 0.7% of the samples under 0.8 mm are
  glancing hits at the bar edges.
- Plate as exported (top face down): 150 x 155.1 x 10 mm, 96.4 cm3,
  watertight, 177 cm2 on the bed, no supports.
- About 25 g and 42 g PLA at 20 percent infill, rough.
