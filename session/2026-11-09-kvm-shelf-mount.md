# 2026-11-09 KVM shelf mount

Continues session/2026-11-09-macbook-stack-stand.md. New, unrelated part.

## Done

- `scripts/kvm_shelf_mount.scad`: parametric under-shelf mount for one
  GL.iNet GL-RM10 and two JetKVM Mini W in a row (mini, RM10, mini).
  Top plate with two screw ears, three open-front bays, wedge stops at
  the back. Geometry and reasons in specs/kvm-shelf-mount.md.
- `make kvm-mount`: exports `out/kvm-shelf-mount.stl`, renders part,
  assembly, front and plan previews, prints mesh info.
  `make kvm-mount-save` copies the STL to `models/`.
- First version treated the RM10 as a 93 wide, 84 deep box. The
  product page drawings show 84 wide, 93 deep and a wedge-like side
  profile (37.5 mm rear body, 47 mm head with a leaning screen, foot
  rails 16.5 mm in, ports all on the back). Bay changed to 85 x 47.6 x
  97.5 mm, floor slots moved between the foot rails, ears 13 mm, the
  preview stand-in follows the real profile.
- RM10 now sticks out 37 mm in front of the mount (`rm_out`) so the
  curve of its head is visible. RM10 bay and plate shortened to
  60.5 mm; two hold-down ribs above the rear body against tipping.
- `models/kvm-shelf-mount.stl` saved: 209 x 53.6 x 60.5 mm as
  exported, 86.5 cm3, watertight.
- Printability recorded in specs/printability.md.
- `make check` passes.

## Decisions

- Device sizes come from published figures and drawings only (RM10
  84 x 93 x 47, Mini W 42 x 42 x 23); the Mini W port faces are not
  documented. Front and back
  of every bay stay open so the design does not depend on them.
- Mini bays are 44.5 mm deep and flush with the front of the mount.
- Printed standing on the front face, so no supports are needed; the
  stops are 45 degree wedges for that reason.
- The RM10 bay keeps the 47.6 mm height so the head in front of the
  mount clears the shelf; ribs, not a lower ceiling, hold the rear
  body down.
- Ear width 13 mm gives a 209 mm part for the 220 mm bed.
- PETG recommended because of the RM10 surface temperature.

## Open

- No device was measured. See the Open list in specs/kvm-shelf-mount.md.
- Not printed yet. Not committed.

## Files touched

- scripts/kvm_shelf_mount.scad (new)
- models/kvm-shelf-mount.stl (new)
- Makefile (kvm-mount, kvm-mount-save)
- specs/kvm-shelf-mount.md (new), specs/README.md, specs/printability.md
- todo/todo.md

## Verify

- `make check`
- `make kvm-mount` and look at out/kvm-shelf-mount-*.png
- `make printcheck MODEL=out/kvm-shelf-mount.stl`

## Next step

Measure the three devices, set the parameters, rebuild, print in PETG.

## Security Note

No secrets in this work. Device figures come from public pages; the
downloaded datasheet PDF was only read, never executed, and is not in
the repository.
