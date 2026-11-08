"""Printability report for an FDM print.

Usage: python -I scripts/printability.py <model-file> [bed_x bed_y bed_z]

For each of the six axis-aligned orientations the script reports: bed
fit, height, footprint, overhang area beyond 45 degrees, and a rough
support volume (overhang area times height above the bed). It then
estimates wall thickness by ray casting from sampled surface points.
Model files are untrusted input; this script only reads geometry.
"""
import sys

import numpy as np
import trimesh

OVERHANG_DEG = 45.0
MIN_WALL_MM = 0.8      # two 0.4 mm perimeters
SAMPLES = 20000

if len(sys.argv) not in (2, 5):
    sys.exit(__doc__)
path = sys.argv[1]
bed = tuple(float(v) for v in sys.argv[2:5]) if len(sys.argv) == 5 else (220.0, 220.0, 250.0)

m = trimesh.load(path, force="mesh")
print(f"file: {path}")
print(f"faces: {len(m.faces)}  watertight: {m.is_watertight}  "
      f"winding: {m.is_winding_consistent}  volume: {m.volume/1000:.1f} cm3")
print(f"bed: {bed[0]:.0f} x {bed[1]:.0f} x {bed[2]:.0f} mm\n")

# Six orientations: which original axis points down, and in which sense.
# Each entry rotates the mesh so that the named face ends up on the bed.
orients = {
    "-Z down (as is)":   trimesh.transformations.identity_matrix(),
    "+Z down (flipped)": trimesh.transformations.rotation_matrix(np.pi, [1, 0, 0]),
    "-Y down":           trimesh.transformations.rotation_matrix(-np.pi / 2, [1, 0, 0]),
    "+Y down":           trimesh.transformations.rotation_matrix(np.pi / 2, [1, 0, 0]),
    "-X down":           trimesh.transformations.rotation_matrix(np.pi / 2, [0, 1, 0]),
    "+X down":           trimesh.transformations.rotation_matrix(-np.pi / 2, [0, 1, 0]),
}

cos_limit = np.cos(np.radians(90 + OVERHANG_DEG))  # normal z below this = overhang
rows = []
for name, T in orients.items():
    r = m.copy()
    r.apply_transform(T)
    r.apply_translation(-r.bounds[0])          # sit on the bed at z=0
    ext = r.extents
    fits = all(ext[i] <= bed[i] + 1e-6 for i in range(3)) or \
        (ext[1] <= bed[0] and ext[0] <= bed[1] and ext[2] <= bed[2])
    nz = r.face_normals[:, 2]
    centroids_z = r.triangles_center[:, 2]
    overhang = (nz < cos_limit) & (centroids_z > 0.3)   # ignore faces on the bed
    oh_area = r.area_faces[overhang].sum()
    support_vol = (r.area_faces[overhang] * np.abs(nz[overhang]) * centroids_z[overhang]).sum()
    # Faces on the first layer: how much touches the bed.
    bed_faces = (centroids_z < 0.3) & (nz < -0.9)
    bed_area = r.area_faces[bed_faces].sum()
    rows.append((name, fits, ext, oh_area, support_vol, bed_area))

print(f"{'orientation':<20}{'fits':<6}{'H mm':>7}{'footprint mm':>16}"
      f"{'bed contact':>13}{'overhang':>11}{'support':>11}")
for name, fits, ext, oh, sv, ba in sorted(rows, key=lambda x: (not x[1], x[4])):
    print(f"{name:<20}{'yes' if fits else 'NO':<6}{ext[2]:>7.1f}"
          f"{ext[0]:>8.1f}x{ext[1]:<7.1f}{ba/100:>10.1f}cm2{oh/100:>8.1f}cm2{sv/1000:>8.1f}cm3")
print("\nsupport = rough volume of material under overhangs; lower is better.")

# Wall thickness: shoot a ray inward from sampled surface points.
pts, fidx = trimesh.sample.sample_surface(m, SAMPLES)
normals = m.face_normals[fidx]
origins = pts - normals * 1e-3
hits, ray_idx, _ = m.ray.intersects_location(origins, -normals, multiple_hits=False)
thick = np.linalg.norm(hits - origins[ray_idx], axis=1)
thick = thick[thick > 0.05]
thin = (thick < MIN_WALL_MM).mean() * 100
print(f"\nwall thickness from {len(thick)} samples:")
print(f"  min {thick.min():.2f} mm   5th pct {np.percentile(thick, 5):.2f} mm   "
      f"median {np.median(thick):.2f} mm")
print(f"  {thin:.1f}% of surface thinner than {MIN_WALL_MM} mm")
