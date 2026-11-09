# Todo

- [x] set up toolchain: OpenSCAD, Python 3.12 venv, trimesh, CadQuery (specs/toolchain.md)
- [x] project scaffold: Makefile, specs, todo, session, git (specs/overview.md)
- [x] mesh_info script: size, volume, watertight check (scripts/mesh_info.py)
- [x] printability check for models/drawer-20cm.stl (specs/printability.md)
- [ ] script OrcaSlicer CLI slicing from make, reporting time and filament
- [x] render PNG previews of a mesh (make preview)
- [ ] slice both drawer models in OrcaSlicer, record real time and filament in specs/printability.md
- [x] drawer variant: ramp at the front, 90 degree back wall, door unchanged (specs/drawer-swap.md)
- [x] section script: cross-section plots and outlines (make sections)
- [x] decide whether the slide rails stay at their original position in the swapped drawer: no, they move with the body (specs/drawer-swap.md)
- [x] front braces: side walls continued to the door with a stepped fillet, the plate was held by the ramp tip only (specs/drawer-swap.md)
- [ ] decide how to print the back wall ceiling: bridge, supports, or design change (specs/drawer-swap.md)
- [x] stacking stand for two closed MacBook Pro 14" laptops, parametric OpenSCAD part (specs/macbook-stack-stand.md)
- [ ] measure the laptop (thickness, feet inset from the side, last port position, side vent position) and print the 10 mm fit test before the full stands (specs/macbook-stack-stand.md)
- [x] stand: channel depth 15 mm (was 7), rail length 68 mm (was 60) (specs/macbook-stack-stand.md)
- [ ] stand: decide on a relief for the rubber feet in the 15 mm shelves once the feet inset is measured (specs/macbook-stack-stand.md)
- [x] stand: two countersunk screw holes in the outward foot, 20 mm from the rail ends (specs/macbook-stack-stand.md)
