# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
project_name = project-name
flavor = full # full, minimal
runtime = podman # podman, docker
editor = cli # cli, vscode
infra = pod # pod, compose (pod is only supported with podman)
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

build:

test:

run:
