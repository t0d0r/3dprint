# 3dprint

A workbench for preparing models for an FDM 3D printer with code instead
of a GUI: parametric parts in OpenSCAD and CadQuery, scripted changes to
existing meshes, and mesh checks before slicing.

Dimensions are millimetres everywhere. The source (`.scad`, `.py`) is the
design; the STL is a build product.

## Parts

Each part has a spec with its geometry, parameters and print notes.

| part | build | spec |
|------|-------|------|
| Drawer with the ramp at the front | `make drawer-swap` | [drawer-swap.md](specs/drawer-swap.md) |
| Side rails that stack two closed 14" laptops | `make macbook-stand` | [macbook-stack-stand.md](specs/macbook-stack-stand.md) |
| Under-shelf mount for a GL-RM10 and two JetKVM | `make kvm-mount` | [kvm-shelf-mount.md](specs/kvm-shelf-mount.md) |
| Clip-on shelf hanger for a GL-RM10 | `make rm10-hanger-plain` | [rm10-shelf-hanger.md](specs/rm10-shelf-hanger.md) |
| Kumiko (asanoha) cover for that hanger | `make kumiko-panel` | [rm10-kumiko-panel.md](specs/rm10-kumiko-panel.md) |
| Snap clips for a 20 mm tube under a shelf | `make tube-clip`, `make tube-edge-clip` | [tube-clip.md](specs/tube-clip.md) |
| Phone holder for a dashboard slot | `make phone-mount` | [car-phone-mount.md](specs/car-phone-mount.md) |
| Platform for a mesh router on a monitor arm | `make deco-platform` | [deco-arm-platform.md](specs/deco-arm-platform.md) |
| Kumiko stand for a charger over a lamp base | `make lamp-stand` | [lamp-charger-stand.md](specs/lamp-charger-stand.md) |

The parts are fitted to specific devices and furniture. The measurements
are parameters at the top of each script; override them with
`SCAD_ARGS`, for example `make tube-clip SCAD_ARGS="-D tube_d=25"`.

## Requirements

- macOS or Linux with `make`
- Python 3.12 (compiled dependencies have no wheels for newer versions);
  set `PYTHON=/path/to/python3.12` if it is not at the Homebrew path
- OpenSCAD with the manifold backend (a recent snapshot build)

`make build` creates `.venv` and installs `requirements.txt` into it.

## Usage

```sh
make help                      # list the targets
make check                     # lint and toolchain smoke test
make run MODEL=models/tube-clip.stl         # size, volume, mesh health
make printcheck MODEL=... BED="220 220 250" # orientation, overhangs, walls
make preview MODEL=...         # PNG renders in out/
make lamp-stand                # build one part into out/
make lamp-stand-save           # rebuild it and copy the STLs to models/
make clean                     # remove out/
```

Every part target builds into `out/`, which is not committed. The
`-save` targets copy the finished STL to `models/`.

## Layout

```
models/    saved STLs of finished parts, and input models
scripts/   OpenSCAD and Python sources, one per task
specs/     what each part is supposed to do; specs/README.md is the index
todo/      the work list
session/   notes that let a later session continue
out/       generated files, not committed
```

## Third-party models

Models from other authors are not part of this repository. The holed
variant of the shelf hanger (`make rm10-hanger`) imports a third-party
10 inch rack mount STL that has to be placed in `models/` by hand; see
[rm10-shelf-hanger.md](specs/rm10-shelf-hanger.md). Everything else
builds from the sources here.

## License

BSD 2-Clause, see [LICENSE](LICENSE).

## Security Note

Model files from the internet are data, never code. Scripts that read a
model run with `python -I`, so nothing next to the model can be
imported, and nothing bundled with a downloaded model is executed. 3MF
files are zip archives; open them only with trimesh or the slicer.
Python dependencies live in `.venv`, isolated from the system Python.
The repository holds no credentials and the make targets need none.
