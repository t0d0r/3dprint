"""Swap the ends of the drawer: ramp to the front, square wall at the back.

Usage: python -I scripts/drawer_swap.py <in.stl> <out.stl>

The drawer is a tray (floor at high X, side walls down to an open edge at
low X, slide rails on the outside of the walls) with a door plate at one
end of Z and a ramped far end. The script separates the door, cuts the
body past the fillet where it meets the door, splits the slide rails off
the body (taking RAIL_BITE of wall with them so they overlap the wall
when put back), mirrors the body along Z so the ramp ends up against the
door, rebuilds the cut-away length at the new back end from the clean U
profile, closes it with a vertical wall as thick as the floor, and unions
everything back together with the rails at their original position,
extended across the fillet zone to the door.
"""
import sys

import manifold3d
import numpy as np
import trimesh
from shapely.geometry import MultiPolygon
from shapely.ops import unary_union
from trimesh.intersections import slice_mesh_plane

WALL_T = 1.3      # floor thickness, measured from the original (mm)
OVERLAP = 0.3     # how far parts sink into each other before union (mm)
RAIL_BITE = 0.3   # wall thickness kept on the rails so they overlap the wall (mm)
FILLET = 3.5      # length of the body/door fillet flare to cut away (mm)
EPS = 0.02        # keep cuts off the door face by this much (mm)
SIMPLIFY = 1e-3   # final sliver clean-up tolerance (mm)

src, dst = sys.argv[1], sys.argv[2]
m = trimesh.load(src, force="mesh")
assert m.is_watertight, "input is not watertight"
zmin, zmax = m.bounds[:, 2]
xlo, xhi = m.bounds[0, 0] - 1, m.bounds[1, 0] + 1
ymin, ymax = m.bounds[0, 1] - 1, m.bounds[1, 1] + 1


def section_at(mesh, z):
    sec = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    p2, to_3d = sec.to_2D()
    return sec, p2, to_3d


def material_area(z):
    return sum(p.area for p in section_at(m, z)[1].polygons_full)


def prism(poly, z0, z1, to_3d):
    """Extrude a 2D section polygon (or multipolygon) between two Z values."""
    polys = list(poly.geoms) if isinstance(poly, MultiPolygon) else [poly]
    parts = []
    for p in polys:
        e = trimesh.creation.extrude_polygon(p, abs(z1 - z0))
        e.apply_transform(to_3d)
        e.apply_translation([0, 0, min(z0, z1) - e.bounds[0, 2]])
        parts.append(e)
    return trimesh.util.concatenate(parts)


def box(x0, x1, y0, y1, z0, z1):
    return trimesh.creation.box(bounds=[[x0, y0, z0], [x1, y1, z1]])


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

# Outer planes of the side walls, measured at their free edge (low X) in a
# section at mid-length. The slide rails sit outside these planes.
sec0, _, _ = section_at(body, (z_body + far) / 2)
v0 = sec0.vertices
edge = v0[v0[:, 0] < v0[:, 0].min() + 1.0]
ylo, yhi = edge[:, 1].min(), edge[:, 1].max()

# The wall faces are not perfectly flat (about 0.03 mm of tessellation
# noise), so the core is clipped just inside their outermost points; that
# gives it flat outer faces and leaves no skin of rail material behind.
bv, bn, bc = body.vertices, body.face_normals, body.triangles_center


def wall_face_y(y0, s):
    f = (bn[:, 1] * s > 0.999) & (abs(bc[:, 1] - y0) < 0.2)
    return bv[body.faces[f]][:, :, 1]


y_core_lo = wall_face_y(ylo, -1).max() + 0.005
y_core_hi = wall_face_y(yhi, 1).min() - 0.005
print(f"side walls: outer faces at y={y_core_lo:.3f} and y={y_core_hi:.3f}")
core = trimesh.boolean.intersection([body, box(xlo, xhi, y_core_lo, y_core_hi, zmin - 1, zmax + 1)],
                                    engine="manifold")

# Rails: everything outside the wall planes plus RAIL_BITE of wall, limited
# to the rails' own X band and length so no other wall material comes along.
outside = bv[(bv[:, 1] < ylo - 0.1) | (bv[:, 1] > yhi + 0.1)]
rail_x0, rail_x1 = outside[:, 0].min() - 0.1, outside[:, 0].max() + 0.1
rail_zend = outside[:, 2].max() if door_low else outside[:, 2].min()
rz0, rz1 = sorted([z_body + door_sign, rail_zend])   # 1 mm towards the door
rails = trimesh.boolean.difference([body, box(xlo, xhi, ylo + RAIL_BITE, yhi - RAIL_BITE, zmin - 1, zmax + 1)],
                                   engine="manifold")
rails = trimesh.boolean.intersection([rails, box(rail_x0, rail_x1, ymin, ymax, rz0, rz1)], engine="manifold")
assert rails.body_count == 2, f"expected 2 rails, got {rails.body_count}"
print(f"rails: z {z_body:.2f}..{rail_zend:.2f}, x {rail_x0 + 0.1:.2f}..{rail_x1 - 0.1:.2f}, "
      f"proud {ylo - rails.bounds[0, 1]:.2f}/{rails.bounds[1, 1] - yhi:.2f} mm")

# The rails lost their first FILLET mm with the body cut; extend them from
# inside the door plate to just past the cut, using their own profile.
rsec, rp2, r_to_3d = section_at(rails, (z_body + rail_zend) / 2)
rail_ext = prism(unary_union(rp2.polygons_full).simplify(0.02, preserve_topology=True),
                 z_face + door_sign * OVERLAP, z_body - door_sign * OVERLAP, r_to_3d)

# Mirror the core about its own mid-length so the ramp ends up at the
# door, then push its tip OVERLAP into the door plate.
c = (far + z_body) / 2
T = np.eye(4); T[2, 2] = -1; T[2, 3] = 2 * c
core.apply_transform(T)
core.apply_translation([0, 0, door_sign * (FILLET + OVERLAP)])
core_far = far + door_sign * (FILLET + OVERLAP)      # core's new back end

# Clean U profile, from well inside the core.
sec, p2, to_3d = section_at(core, far + door_sign * 15)
# Simplify the profile: the raw section has ~1500 near-duplicate vertices
# that would turn into sliver triangles when extruded.
u_poly = unary_union(p2.polygons_full).simplify(0.02, preserve_topology=True).buffer(0)

# Fill the cut-away length with the U profile, then close it with a wall.
z_wall_in = far + door_sign * WALL_T
fill = prism(u_poly, core_far + door_sign * OVERLAP, z_wall_in - door_sign * 0.1, to_3d)
hull = u_poly.convex_hull
wall = prism(hull, z_wall_in, far, to_3d)
assert abs(wall.extents[1] - (y_core_hi - y_core_lo)) < 0.05, "back wall is not flush with the side walls"
print(f"back wall: {wall.extents.round(2)} mm (x y z); fill {fill.extents[2]:.2f} mm long")

out = trimesh.boolean.union([core, fill, wall, door, rails, rail_ext], engine="manifold")

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
      f"winding {chk.is_winding_consistent}, bodies {chk.body_count}, genus {(2 - chk.euler_number) // 2}, "
      f"volume {chk.volume/1000:.1f} cm3 (was {m.volume/1000:.1f}), "
      f"extents {chk.extents.round(1)} (was {m.extents.round(1)})")
assert chk.is_watertight and chk.body_count == 1
# The mirrored body brings the ramp tip, with its rounded corners, to the
# door, so right behind the door each rail is backed by nothing but the
# door until the ramp's underside drops below the rail band. Air passes
# over the rail into the space under the ramp there: topologically one
# handle per side. Printed door-down, rail and ramp tip are two islands
# that merge a few layers up. Any further handle would be a real defect.
genus, genus0 = (2 - chk.euler_number) // 2, (2 - m.euler_number) // 2
assert genus in (genus0, genus0 + 2), f"unexpected topology: genus {genus} (was {genus0})"
# How long the free-standing stretch is: rays through the wall (past the
# rail's bite) at increasing distance from the door, until the wall
# reaches down past the rail band.
steps = np.arange(0.2, 30, 0.25)
origins = np.c_[np.full_like(steps, xlo), np.full_like(steps, y_core_lo + RAIL_BITE + 0.2),
                z_face - door_sign * steps]
loc, ray_id, _ = chk.ray.intersects_location(origins, np.tile([1.0, 0, 0], (len(steps), 1)))
covered = [k for k in range(len(steps)) if len(loc[ray_id == k]) and loc[ray_id == k][:, 0].max() >= rail_x1]
free = steps[covered[0]] if covered else float("nan")
print(f"rails free-standing for the first {free:.1f} mm behind the door")
# No face may be left inside the wall between a rail's bite and the
# core's outer face: that would mean the rail did not fuse with the wall.
cc, cn = chk.triangles_center, chk.face_normals
inner = (abs(cn[:, 1]) > 0.999) & (cc[:, 0] > rail_x0) & (cc[:, 0] < rail_x1) \
    & (((cc[:, 1] > y_core_lo + 0.01) & (cc[:, 1] < ylo + RAIL_BITE - 0.01))
       | ((cc[:, 1] < y_core_hi - 0.01) & (cc[:, 1] > yhi - RAIL_BITE + 0.01)))
assert not inner.any(), f"{inner.sum()} faces left between rails and walls"
print("wrote", dst)
