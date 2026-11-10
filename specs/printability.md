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
