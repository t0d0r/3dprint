"""Smoke test: build a part with CadQuery, export it, read it back with trimesh.

Usage: python -I scripts/smoke_test.py <output-dir>
"""
import sys
from pathlib import Path

import cadquery as cq
import trimesh

out = Path(sys.argv[1] if len(sys.argv) > 1 else "out")
out.mkdir(parents=True, exist_ok=True)

# A 30x20x10 mm block with a 5 mm through hole.
part = cq.Workplane("XY").box(30, 20, 10).faces(">Z").workplane().hole(5)
cq.exporters.export(part, str(out / "cq_block.step"))
cq.exporters.export(part, str(out / "cq_block.stl"))

m = trimesh.load(out / "cq_block.stl", force="mesh")
assert m.is_watertight, "exported mesh is not watertight"
assert all(abs(a - b) < 0.1 for a, b in zip(m.extents, (30, 20, 10))), m.extents
print("smoke test ok:", m.extents.round(1), "mm,", round(m.volume, 1), "mm3")
