# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_flavor = full # full, minimal
_runtime = podman # podman, docker
_editor = cli # cli, vscode
_infra = pod # pod, compose (pod is only supported with podman)
_optimized = false # true or false (use if for multi stage builds)

project_name = $(strip $(_project_name))
flavor = $(strip $(_flavor))
runtime = $(strip $(_runtime))
editor = $(strip $(_editor))
infra = $(strip $(_infra))
optimized = $(strip $(_optimized))
container_name = ${project_name}-dev

export project_name
export flavor
export runtime
export editor
export infra
export container_name
export optimized

all:

.devcontainer/Makefile:
	$(MAKE) -C .devcontainer -f Makefile.dev gendevenv

# action: create, start, enter, stop, destroy, purge, clean
# vcs: true, false (setting to true (default: false) will add it to the VCS working tree)
devcontainer: action =, vcs = 
devcontainer: .devcontainer/Makefile
ifeq ($(strip $(vcs)), false)
	-test -d .git && sed -i "/.devcontainer/d" .git/info/exclude && echo "/.devcontainer" >> .git/info/exclude
	-test -d .git && sed -i "/Makefile/d" .git/info/exclude && echo "/Makefile" >> .git/info/exclude
	-test -f .git && sed -i "/.devcontainer/d" $(shell cat .git | cut -d ':' -f 2)/../../info/exclude && echo "/.devcontainer" >> $(shell cat .git | cut -d ':' -f 2)/../../info/exclude
	-test -f .git && sed -i "/Makefile/d" $(shell cat .git | cut -d ':' -f 2)/../../info/exclude && echo "/Makefile" >> $(shell cat .git | cut -d ':' -f 2)/../../info/exclude
endif
ifeq ($(optimized), true)
	touch .devcontainer/.optimized
	$(MAKE) -C .devcontainer -f Makefile.dev baseimage
endif
ifeq ($(strip $(action)),)
	echo "Invalid/empty action '$(action)'. Please specify one out of create, start, enter, stop, destroy, purge, clean"
	exit 1
endif
	$(MAKE) -C .devcontainer env$(action)

build:

test:

run:
