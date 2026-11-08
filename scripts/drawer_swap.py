"""Swap the ends of the drawer: ramp to the front, square wall at the back.

Usage: python -I scripts/drawer_swap.py <in.stl> <out.stl>

The drawer is a tray (floor at high X, side walls down to an open edge at
low X, slide rails on the outside of the walls) with a door plate at one
end of Z and a ramped far end. The script separates the door, cuts the
body past the fillet where it meets the door, mirrors the body along Z so
the ramp ends up against the door, rebuilds the cut-away length at the
new back end from the clean U profile, closes it with a vertical wall as
thick as the floor, and unions everything.
"""
import sys

import manifold3d
import numpy as np
import trimesh
from shapely.ops import unary_union
from trimesh.intersections import slice_mesh_plane

WALL_T = 1.3      # floor thickness, measured from the original (mm)
OVERLAP = 0.3     # how far parts sink into each other before union (mm)
FILLET = 3.5      # length of the body/door fillet flare to cut away (mm)
EPS = 0.02        # keep cuts off the door face by this much (mm)
SIMPLIFY = 1e-3   # final sliver clean-up tolerance (mm)

src, dst = sys.argv[1], sys.argv[2]
m = trimesh.load(src, force="mesh")
assert m.is_watertight, "input is not watertight"
zmin, zmax = m.bounds[:, 2]


def section_at(mesh, z):
    sec = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    p2, to_3d = sec.to_2D()
    return sec, p2, to_3d


def material_area(z):
    return sum(p.area for p in section_at(m, z)[1].polygons_full)


# The door plate is solid (about 120 x 30 mm); the body is a thin U.
door_low = material_area(zmin + 0.5) > material_area(zmax - 0.5)
door_sign = -1 if door_low else 1
far = zmax if door_low else zmin

# Exact plane of the door's inner face: the large face whose normal
# points into the body, close to the door end.
nz = m.face_normals[:, 2]
cz = m.triangles_center[:, 2]
near = (cz - zmin < 10) if door_low else (zmax - cz < 10)
sel = near & (nz * -door_sign > 0.999)
big = m.area_faces[sel] > 1.0
z_face = np.average(cz[sel][big], weights=m.area_faces[sel][big])
door_t = (z_face - zmin) if door_low else (zmax - z_face)
assert 3 < door_t < 10, "door plate not found"
print(f"door at {'low' if door_low else 'high'} Z, inner face z={z_face:.3f}, thickness {door_t:.2f} mm")

n = np.array([0, 0, door_sign], float)
z_door = z_face + door_sign * EPS
z_body = z_face - door_sign * FILLET
door = slice_mesh_plane(m, plane_normal=n, plane_origin=[0, 0, z_door], cap=True)
body = slice_mesh_plane(m, plane_normal=-n, plane_origin=[0, 0, z_body], cap=True)
a_cut, a_ref = material_area(z_body), material_area(z_body - door_sign * 15)
assert abs(a_cut - a_ref) / a_ref < 0.02, f"cut still inside the fillet: {a_cut:.1f} vs {a_ref:.1f}"

# Mirror the body about its own mid-length so the ramp ends up at the
# door, then push its tip OVERLAP into the door plate.
c = (far + z_body) / 2
T = np.eye(4); T[2, 2] = -1; T[2, 3] = 2 * c
body.apply_transform(T)
body.apply_translation([0, 0, door_sign * (FILLET + OVERLAP)])
body_far = far + door_sign * (FILLET + OVERLAP)      # body's new back end

# Clean U profile, from well inside the body.
sec, p2, to_3d = section_at(body, far + door_sign * 15)
# Simplify the profile: the raw section has ~1500 near-duplicate vertices
# that would turn into sliver triangles when extruded.
u_poly = unary_union(p2.polygons_full).simplify(0.02, preserve_topology=True).buffer(0)


def prism(poly, z0, z1):
    """Extrude a 2D section polygon between two Z values."""
    p = trimesh.creation.extrude_polygon(poly, abs(z1 - z0))
    p.apply_transform(to_3d)
    p.apply_translation([0, 0, min(z0, z1) - p.bounds[0, 2]])
    return p


# Fill the cut-away length with the U profile, then close it with a wall.
z_wall_in = far + door_sign * WALL_T
fill = prism(u_poly, body_far + door_sign * OVERLAP, z_wall_in - door_sign * 0.1)
hull = u_poly.convex_hull
# The hull also spans the slide rails; clip it flush with the outer faces
# of the side walls, measured at their free edge (low X).
v = sec.vertices
edge = v[v[:, 0] < v[:, 0].min() + 1.0]
ylo, yhi = edge[:, 1].min(), edge[:, 1].max()
wall = prism(hull, z_wall_in, far)
clip = trimesh.creation.box(bounds=[[m.bounds[0, 0] - 1, ylo, m.bounds[0, 2] - 1],
                                    [m.bounds[1, 0] + 1, yhi, m.bounds[1, 2] + 1]])
wall = trimesh.boolean.intersection([wall, clip], engine="manifold")
print(f"back wall: {wall.extents.round(2)} mm (x y z); fill {fill.extents[2]:.2f} mm long")

out = trimesh.boolean.union([body, fill, wall, door], engine="manifold")

# Collapse slivers left by the booleans. Without this, STL's 32-bit floats
# merge their vertices on reload and the mesh is no longer 2-manifold.
mf = manifold3d.Manifold(manifold3d.Mesh(
    vert_properties=np.asarray(out.vertices, np.float64),
    tri_verts=np.asarray(out.faces, np.uint32))).simplify(SIMPLIFY)
assert mf.status() == manifold3d.Error.NoError, mf.status()
mm = mf.to_mesh()
out = trimesh.Trimesh(np.asarray(mm.vert_properties)[:, :3], np.asarray(mm.tri_verts), process=False)
out.export(dst)

# Verify the way a slicer will see it: reload the file and merge vertices.
chk = trimesh.load(dst, force="mesh")
print(f"result: faces {len(chk.faces)}, watertight {chk.is_watertight}, "
      f"winding {chk.is_winding_consistent}, bodies {chk.body_count}, "
      f"volume {chk.volume/1000:.1f} cm3 (was {m.volume/1000:.1f}), "
      f"extents {chk.extents.round(1)} (was {m.extents.round(1)})")
assert chk.is_watertight and chk.body_count == 1
print("wrote", dst)
