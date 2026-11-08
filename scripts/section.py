"""Plot cross-sections of a mesh to PNG and print simplified outlines.

Usage: python -I scripts/section.py <model-file> <out-dir>
Cuts the mesh at the middle of each axis and draws the three sections.
"""
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import trimesh

m = trimesh.load(sys.argv[1], force="mesh")
out = Path(sys.argv[2]); out.mkdir(parents=True, exist_ok=True)
mid = m.bounds.mean(axis=0)
names = "XYZ"
for axis in range(3):
    normal = np.zeros(3); normal[axis] = 1
    sec = m.section(plane_origin=mid, plane_normal=normal)
    if sec is None:
        continue
    p2, T = sec.to_2D()
    a, b = [i for i in range(3) if i != axis]
    fig, ax = plt.subplots(figsize=(10, 10))
    for poly in p2.polygons_full:
        xs, ys = poly.exterior.xy
        ax.plot(xs, ys, "k-", lw=1)
        for ring in poly.interiors:
            xs, ys = ring.xy
            ax.plot(xs, ys, "r-", lw=1)
    ax.set_aspect("equal"); ax.grid(True, lw=0.3)
    ax.set_title(f"section normal {names[axis]} at {mid[axis]:.1f}")
    fig.savefig(out / f"section_{names[axis]}.png", dpi=110); plt.close(fig)
    print(f"\n== section normal {names[axis]} ({len(p2.polygons_full)} polygons) ==")
    for poly in p2.polygons_full:
        s = poly.simplify(0.3)
        print(" outer:", np.round(np.array(s.exterior.coords)[:-1], 1).tolist())
        for ring in s.interiors:
            print(" hole: ", np.round(np.array(ring.coords)[:-1], 1).tolist())
