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

### out/macbook-stack-stand.stl (2026-11-09)

- Built by `make macbook-stand`, see specs/macbook-stack-stand.md.
- 23 x 49.5 x 60 mm, 24.2 cm3, watertight, one body.
- Orientation: as modelled, E profile on the bed, rail length up. Zero
  overhangs, no supports, 3.6 cm2 bed contact. Every other orientation
  needs supports and puts the layer lines across the shelf roots.
- Thinnest section 2.1 mm (top lip at the flared rail ends); nothing
  under 0.8 mm.
- About 30 g PLA each if printed solid; two are needed.
