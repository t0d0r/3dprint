# 3dprint - scripts and models for 3D printing
# Python 3.12 is required: compiled packages have no wheels for newer versions.

PYTHON ?= /opt/homebrew/opt/python@3.12/bin/python3.12
VENV    := .venv
PY      := $(VENV)/bin/python
PIP     := $(VENV)/bin/pip
OPENSCAD ?= openscad
MODEL   ?= models/drawer-20cm.stl

.DEFAULT_GOAL := help
.PHONY: help build test lint check run clean info printcheck preview sections drawer-swap macbook-stand macbook-stand-fit macbook-stand-save phone-mount phone-mount-fit phone-mount-save tube-clip tube-clip-save tube-edge-clip tube-edge-clip-save deco-platform deco-platform-fit deco-platform-save lamp-stand lamp-stand-save

help: ## list targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-8s %s\n", $$1, $$2}'

build: $(VENV)/.ok ## create the venv and install requirements

$(VENV)/.ok: requirements.txt
	test -x $(PY) || $(PYTHON) -m venv $(VENV)
	$(PIP) install -q --upgrade pip
	$(PIP) install -q -r requirements.txt
	touch $@

test: build ## run the toolchain smoke test (CadQuery, trimesh, OpenSCAD)
	mkdir -p out
	$(PY) -I scripts/smoke_test.py out
	@command -v $(OPENSCAD) >/dev/null || { echo "openscad not found; install: brew install --cask openscad@snapshot"; exit 1; }
	echo 'difference(){cube(20,center=true);cylinder(h=30,r=5,center=true,$$fn=64);}' > out/scad_test.scad
	$(OPENSCAD) --backend=manifold -q -o out/scad_test.stl out/scad_test.scad

lint: build ## byte-compile all scripts
	$(PY) -m py_compile scripts/*.py

check: lint test ## lint and test; must pass before a commit

run: build ## print mesh info for MODEL (default: models/drawer-20cm.stl)
	$(PY) -I scripts/mesh_info.py "$(MODEL)"

info: run ## alias for run

printcheck: build ## orientation, overhang and wall-thickness report for MODEL (BED="x y z")
	$(PY) -I scripts/printability.py "$(MODEL)" $(BED)

preview: ## render out/preview_{iso,front,back,top,bottom}.png of MODEL with OpenSCAD
	mkdir -p out
	echo 'import("$(abspath $(MODEL))");' > out/preview.scad
	for v in iso:60,0,35 front:90,0,0 back:60,0,215 top:0,0,0 bottom:180,0,0; do \
	  $(OPENSCAD) -q -o out/preview_$${v%%:*}.png --imgsize=900,900 --autocenter --viewall \
	    --camera=0,0,0,$${v#*:},0 --colorscheme=Tomorrow out/preview.scad || exit 1; done

sections: build ## plot out/section_{X,Y,Z}.png cross-sections of MODEL
	$(PY) -I scripts/section.py "$(MODEL)" out

drawer-swap: build ## build models/drawer-20cm-front-slope.stl from models/drawer-20cm.stl
	$(PY) -I scripts/drawer_swap.py models/drawer-20cm.stl models/drawer-20cm-front-slope.stl

MBS := scripts/macbook_stack_stand.scad
MBS_PNG := $(OPENSCAD) -q --render --backend=manifold $(SCAD_ARGS) --colorscheme=Tomorrow

macbook-stand: build ## build out/macbook-stack-stand-{left,right}.stl and previews (SCAD_ARGS passes -D overrides)
	mkdir -p out
	for side in left right; do \
	  $(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D "side=\"$$side\"" -o out/macbook-stack-stand-$$side.stl $(MBS) || exit 1; done
	$(MBS_PNG) -o out/macbook-stack-stand-part.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(MBS)
	$(MBS_PNG) -D 'part="assembly"' -o out/macbook-stack-stand-assembly.png --imgsize=1200,700 --camera=0,0,20,62,0,150,900 $(MBS)
	$(MBS_PNG) -D 'part="section"' -o out/macbook-stack-stand-section.png --imgsize=1000,700 \
	  --projection=ortho --camera=-150,0,24,90,0,0,220 $(MBS)
	$(MBS_PNG) -D 'part="assembly"' -o out/macbook-stack-stand-side.png --imgsize=1200,500 \
	  --projection=ortho --camera=0,0,24,90,0,90,620 $(MBS)
	$(MBS_PNG) -D 'part="plan"' -o out/macbook-stack-stand-plan.png --imgsize=1200,900 \
	  --projection=ortho --autocenter --viewall --camera=0,0,0,180,0,0,0 $(MBS)
	$(PY) -I scripts/mesh_info.py out/macbook-stack-stand-left.stl
	$(PY) -I scripts/mesh_info.py out/macbook-stack-stand-right.stl

macbook-stand-save: macbook-stand ## rebuild the stand and copy the left and right STL to models/
	cp out/macbook-stack-stand-left.stl out/macbook-stack-stand-right.stl models/
	ls -l models/macbook-stack-stand-*.stl

macbook-stand-fit: build ## build out/macbook-stack-stand-fit.stl, a 10 mm slice of the profile for a fit test
	mkdir -p out
	$(OPENSCAD) --backend=manifold -q --hardwarnings $(SCAD_ARGS) -D 'part="fit"' -o out/macbook-stack-stand-fit.stl $(MBS)
	$(PY) -I scripts/mesh_info.py out/macbook-stack-stand-fit.stl

CPM := scripts/car_phone_mount.scad

phone-mount: build ## build out/car-phone-mount-{vertical,horizontal}.stl, the dashboard slot phone holder, and previews (SCAD_ARGS passes -D overrides, e.g. -D mouth_h=27)
	mkdir -p out
	for v in vertical horizontal; do \
	  $(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D "variant=\"$$v\"" -o out/car-phone-mount-$$v.stl $(CPM) || exit 1; \
	  $(MBS_PNG) -D "variant=\"$$v\"" -o out/car-phone-mount-$$v-part.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(CPM) || exit 1; \
	  $(MBS_PNG) -D "variant=\"$$v\"" -D 'part="assembly"' -o out/car-phone-mount-$$v-assembly.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,60,0,205,0 $(CPM) || exit 1; \
	  $(MBS_PNG) -D "variant=\"$$v\"" -D 'part="side"' -o out/car-phone-mount-$$v-side.png --imgsize=1200,800 --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,270,0 $(CPM) || exit 1; \
	  $(PY) -I scripts/mesh_info.py out/car-phone-mount-$$v.stl || exit 1; done
	$(MBS_PNG) -o out/car-phone-mount-top.png --imgsize=1200,600 --projection=ortho --autocenter --viewall --camera=0,0,0,0,0,0,0 $(CPM)

phone-mount-fit: build ## build out/car-phone-mount-fit.stl, three flat templates of the plug outline for a fit test in the slot
	mkdir -p out
	$(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D 'part="fit"' -o out/car-phone-mount-fit.stl $(CPM)
	$(PY) -I scripts/mesh_info.py out/car-phone-mount-fit.stl

phone-mount-save: phone-mount ## rebuild both phone holder variants and copy the STLs to models/
	cp out/car-phone-mount-vertical.stl out/car-phone-mount-horizontal.stl models/
	ls -l models/car-phone-mount-*.stl

TBC := scripts/tube_clip.scad

tube-clip: build ## build out/tube-clip.stl, two tape-on clips for a 20 mm tube, and previews (SCAD_ARGS passes -D overrides, e.g. -D tube_d=25)
	mkdir -p out
	$(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -o out/tube-clip.stl $(TBC)
	$(MBS_PNG) -o out/tube-clip-part.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(TBC)
	$(MBS_PNG) -D 'part="assembly"' -o out/tube-clip-assembly.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,115,0,35,0 $(TBC)
	$(MBS_PNG) -D 'part="side"' -o out/tube-clip-side.png --imgsize=1200,700 \
	  --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,0,0 $(TBC)
	$(MBS_PNG) -o out/tube-clip-below.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,60,0,205,0 $(TBC)
	$(PY) -I scripts/mesh_info.py out/tube-clip.stl

tube-clip-save: tube-clip ## rebuild the tube clips and copy the STL to models/
	cp out/tube-clip.stl models/
	ls -l models/tube-clip.stl

TEC := scripts/tube_edge_clip.scad

tube-edge-clip: build ## build out/tube-edge-clip.stl, two clips for a 20 mm tube that push onto the shelf edge, tube at 90 degrees to the edge, and previews (SCAD_ARGS passes -D overrides, e.g. -D shelf_t=10)
	mkdir -p out
	$(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -o out/tube-edge-clip.stl $(TEC)
	$(MBS_PNG) -o out/tube-edge-clip-part.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(TEC)
	$(MBS_PNG) -D 'part="assembly"' -o out/tube-edge-clip-assembly.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,70,0,330,0 $(TEC)
	$(MBS_PNG) -D 'part="assembly"' -o out/tube-edge-clip-below.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,115,0,215,0 $(TEC)
	$(MBS_PNG) -D 'part="side"' -o out/tube-edge-clip-side.png --imgsize=1200,500 \
	  --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,270,0 $(TEC)
	$(MBS_PNG) -D 'part="front"' -o out/tube-edge-clip-front.png --imgsize=1000,700 \
	  --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,0,0 $(TEC)
	$(PY) -I scripts/mesh_info.py out/tube-edge-clip.stl

tube-edge-clip-save: tube-edge-clip ## rebuild the shelf-edge tube clips and copy the STL to models/
	cp out/tube-edge-clip.stl models/
	ls -l models/tube-edge-clip.stl

DAP := scripts/deco_arm_platform.scad

deco-platform: build ## build out/deco-arm-platform-{tray,rim}.stl, the Deco platform for the swivel link of the monitor arm, and previews (SCAD_ARGS passes -D overrides, e.g. -D link_w=27)
	mkdir -p out
	for p in tray rim; do \
	  $(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D "part=\"$$p\"" -o out/deco-arm-platform-$$p.stl $(DAP) || exit 1; \
	  $(PY) -I scripts/mesh_info.py out/deco-arm-platform-$$p.stl || exit 1; done
	$(MBS_PNG) -o out/deco-arm-platform-part.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(DAP)
	$(MBS_PNG) -D 'part="assembly"' -o out/deco-arm-platform-assembly.png --imgsize=1200,900 --autocenter --viewall --camera=0,0,0,65,0,150,0 $(DAP)
	$(MBS_PNG) -D 'part="side"' -o out/deco-arm-platform-side.png --imgsize=1200,900 --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,0,0 $(DAP)
	$(MBS_PNG) -D 'part="below"' -o out/deco-arm-platform-below.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,125,0,30,0 $(DAP)

deco-platform-fit: build ## build out/deco-arm-platform-fit.stl, the saddle of the Deco platform on a small plate, for a fit test on the arm
	mkdir -p out
	$(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D 'part="fit"' -o out/deco-arm-platform-fit.stl $(DAP)
	$(PY) -I scripts/mesh_info.py out/deco-arm-platform-fit.stl

deco-platform-save: deco-platform ## rebuild the Deco platform and copy both STLs to models/
	cp out/deco-arm-platform-tray.stl out/deco-arm-platform-rim.stl models/
	ls -l models/deco-arm-platform-*.stl

LCS := scripts/lamp_charger_stand.scad

lamp-stand: build ## build out/lamp-charger-stand-{cone,top}.stl, the round kumiko stand for a Belkin 3-in-1 charger over the Qi pad of the NYMANE lamp base, and previews (SCAD_ARGS passes -D overrides, e.g. -D bracket_r=58)
	mkdir -p out
	for p in cone top; do \
	  $(OPENSCAD) --backend=manifold -q --hardwarnings --export-format binstl $(SCAD_ARGS) -D "part=\"$$p\"" -o out/lamp-charger-stand-$$p.stl $(LCS) || exit 1; \
	  $(PY) -I scripts/mesh_info.py out/lamp-charger-stand-$$p.stl || exit 1; \
	  $(MBS_PNG) -D "part=\"$$p\"" -o out/lamp-charger-stand-$$p.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,55,0,25,0 $(LCS) || exit 1; done
	$(MBS_PNG) -D 'part="assembly"' -o out/lamp-charger-stand-assembly.png --imgsize=1200,900 --autocenter --viewall --camera=0,0,0,65,0,330,0 $(LCS)
	$(MBS_PNG) -D 'part="assembly"' -o out/lamp-charger-stand-rear.png --imgsize=1200,900 --autocenter --viewall --camera=0,0,0,65,0,150,0 $(LCS)
	$(MBS_PNG) -D 'part="side"' -o out/lamp-charger-stand-side.png --imgsize=1200,900 --projection=ortho --autocenter --viewall --camera=0,0,0,90,0,90,0 $(LCS)
	$(MBS_PNG) -D 'part="below"' -o out/lamp-charger-stand-below.png --imgsize=1200,800 --autocenter --viewall --camera=0,0,0,120,0,30,0 $(LCS)

lamp-stand-save: lamp-stand ## rebuild the lamp charger stand and copy both STLs to models/
	cp out/lamp-charger-stand-cone.stl out/lamp-charger-stand-top.stl models/
	ls -l models/lamp-charger-stand-*.stl

clean: ## remove build output
	rm -rf out __pycache__ scripts/__pycache__
