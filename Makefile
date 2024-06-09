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
vcs = false # true, false (setting to true will add new/modified devcontainer files to the working tree)

export project_name
export flavor
export runtime
export editor
export infra
export container_name
export optimized
export vcs

all:

# action: generate, create, start, enter, stop, destroy, purge, clean
devcontainer: action =
devcontainer:
ifeq ($(strip $(action)),)
	echo "Invalid/empty action '$(action)'. Please specify one out of create, start, enter, stop, destroy, purge, clean"
	exit 1
else
ifeq ($(strip $(action)), generate)
	$(MAKE) -C .devcontainer -f Makefile.dev Makefile
	exit 0
endif
endif
ifeq ($(optimized), true)
	touch .devcontainer/.optimized
	$(MAKE) -C .devcontainer -f Makefile.dev baseimage
endif
ifneq ($(strip $(action)), generate)
	$(MAKE) -C .devcontainer env$(action)
endif

build:

test:

run:
