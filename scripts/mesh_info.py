"""Print size, volume and mesh health for an STL/OBJ/3MF file.

Usage: python -I scripts/mesh_info.py <model-file>
Model files are untrusted input; this script only reads geometry.
"""
import sys

import trimesh

PLA_DENSITY_G_CM3 = 1.24
# Rough factor for a typical print with 2-3 perimeters and 20% infill.
INFILL_FACTOR = 0.35

if len(sys.argv) != 2:
    sys.exit(__doc__)

m = trimesh.load(sys.argv[1], force="mesh")
vol_cm3 = m.volume / 1000
print(f"file:        {sys.argv[1]}")
print(f"faces:       {len(m.faces)}")
print(f"watertight:  {m.is_watertight}")
print(f"winding ok:  {m.is_winding_consistent}")
print(f"bbox mm:     {m.extents.round(1)} (x y z)")
print(f"volume:      {vol_cm3:.1f} cm3")
print(f"solid PLA:   {vol_cm3 * PLA_DENSITY_G_CM3:.0f} g")
print(f"approx 20%:   {vol_cm3 * PLA_DENSITY_G_CM3 * INFILL_FACTOR:.0f} g (slicer gives the real number)")
