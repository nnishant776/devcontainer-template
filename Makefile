# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
project_name = project-name
flavor = full # full, minimal
runtime = podman # podman, docker
editor = cli # cli, vscode
infra = pod # pod, compose (pod is only supported with podman)
container_name = ${project_name}-dev
optimized = true # If set to true, this will look for existing image localhost/project-name:dev and use it for the new image

export project_name
export flavor
export runtime
export editor
export infra
export container_name
export optimized

gendevenv:
	$(MAKE) -C .devcontainer gendevenv
all:

devcontainer: action = create  # create, start, enter, stop, destroy, purge
devcontainer:
ifeq ($(strip $(action)), create)
	$(MAKE) -C .devcontainer envcreate
endif
ifeq ($(strip $(action)), start)
	$(MAKE) -C .devcontainer envstart
endif
ifeq ($(strip $(action)), enter)
	$(MAKE) -C .devcontainer enventer
endif
ifeq ($(strip $(action)), stop)
	$(MAKE) -C .devcontainer envstop
endif
ifeq ($(strip $(action)), destroy)
	$(MAKE) -C .devcontainer envdestroy
endif
ifeq ($(strip $(action)), purge)
	$(MAKE) -C .devcontainer envpurge
endif
