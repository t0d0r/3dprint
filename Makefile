# 3dprint - scripts and models for 3D printing
# Python 3.12 is required: compiled packages have no wheels for newer versions.

PYTHON ?= /opt/homebrew/opt/python@3.12/bin/python3.12
VENV    := .venv
PY      := $(VENV)/bin/python
PIP     := $(VENV)/bin/pip
OPENSCAD ?= openscad
MODEL   ?= models/drawer-20cm.stl

.DEFAULT_GOAL := help
.PHONY: help build test lint check run clean info printcheck preview sections drawer-swap

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

clean: ## remove build output
	rm -rf out __pycache__ scripts/__pycache__
