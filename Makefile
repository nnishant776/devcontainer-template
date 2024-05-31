# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_flavor = full # full, minimal
_runtime = podman # podman, docker
_editor = cli # cli, vscode
_infra = pod # pod, compose (pod is only supported with podman)

project_name = $(strip $(_project_name))
flavor = $(strip $(_flavor))
runtime = $(strip $(_runtime))
editor = $(strip $(_editor))
infra = $(strip $(_infra))
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
	sed -i "/.devcontainer/d" .git/info/exclude
	test -d .git && echo "/.devcontainer" >> .git/info/exclude
	test -f .git && echo "/.devcontainer" >> $(shell cat .git | cut -d ':' -f 2)/../../info/exclude
	# sed -i '1,25d' Makefile
	# sed -i 's/devcontainer: gendevenv/devcontainer:/g' Makefile

gendevenv: .devcontainer/Makefile

devcontainer: action = create  # create, start, enter, stop, destroy, purge
devcontainer: gendevenv
ifeq ($(action), create)
	$(MAKE) -C .devcontainer envcreate
endif
ifeq ($(action), start)
	$(MAKE) -C .devcontainer envstart
endif
ifeq ($(action), enter)
	$(MAKE) -C .devcontainer enventer
endif
ifeq ($(action), stop)
	$(MAKE) -C .devcontainer envstop
endif
ifeq ($(action), destroy)
	$(MAKE) -C .devcontainer envdestroy
endif
ifeq ($(action), purge)
	$(MAKE) -C .devcontainer envpurge
endif

build:

test:

run:
