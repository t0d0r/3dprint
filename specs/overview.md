# Overview

## Goal

A workbench for preparing models for an FDM 3D printer with code instead
of a GUI: generate parametric parts, modify and repair existing STL files,
convert formats, and inspect meshes before slicing in OrcaSlicer.

## Layout

- `models/`   input models (STL, 3MF, STEP). Treated as untrusted data.
- `scripts/`  Python and OpenSCAD sources. One script per task.
- `out/`      generated files. Not committed; `make clean` removes it.
- `specs/`, `todo/`, `session/` as required by ../AGENTS.md.

## Conventions

- Dimensions are millimetres everywhere.
- Parametric parts are kept as source (`.scad`, `.py`) and exported to
  `out/`; the source is the design, the mesh is a build product.
- Every script that reads a model file runs with `python -I` so nothing
  next to the model can be imported.
- Output meshes are checked for watertightness before they are handed to
  the slicer.

## Acceptance

- `make check` passes: scripts byte-compile, CadQuery exports a part,
  trimesh reads it back watertight, OpenSCAD renders a test file.
- `make run MODEL=<file>` prints size, volume and mesh health.

## Security Note

Model files from the internet are data, never code. Nothing bundled with a
downloaded model is executed. 3MF files are zip archives and are only
opened by trimesh or the slicer, never unpacked by hand from unknown
sources. Python dependencies live in `.venv`, isolated from the system
Python.
