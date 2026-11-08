# Toolchain

| tool          | version    | source                                   |
|---------------|------------|------------------------------------------|
| Python        | 3.12       | Homebrew python@3.12                     |
| trimesh       | 5.x        | pip, in .venv                            |
| CadQuery      | 2.8        | pip, in .venv                            |
| manifold3d    | latest     | pip, in .venv                            |
| numpy-stl     | latest     | pip, in .venv                            |
| OpenSCAD      | 2026.10.11 | Homebrew cask openscad@snapshot          |
| OrcaSlicer    | installed  | /Applications/OrcaSlicer.app             |
| Blender       | installed  | /Applications/Blender.app                |

## Decisions

- Python 3.12, not the Homebrew default 3.15: manifold3d and CadQuery
  ship no wheels for 3.15 and building manifold3d from source fails.
  `make build` uses `/opt/homebrew/opt/python@3.12/bin/python3.12`.
- OpenSCAD snapshot, not the stable cask: the stable cask is disabled in
  Homebrew because it fails the macOS Gatekeeper check, and the snapshot
  includes the Manifold geometry backend, which is much faster. Scripts
  pass `--backend=manifold`.
- Dependencies in a project `.venv`, not system-wide: Homebrew Python is
  externally managed (PEP 668) and refuses system installs.

## Roles

- OpenSCAD: parametric parts written as code; quick for boxes, brackets,
  holes and text.
- CadQuery: parametric parts in Python when STEP export or fillets are
  needed.
- trimesh (with manifold3d): load, inspect, repair, boolean, slice, scale
  and convert existing meshes.
- OrcaSlicer: slicing; also has a CLI for scripted slicing.
- Blender: manual work when a GUI is faster, or headless via
  `/Applications/Blender.app/Contents/MacOS/Blender -b -P script.py`.
