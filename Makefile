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

all:

devcontainer:
	$(MAKE) -C .devcontainer devcontainer

list:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
	awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

envstart:
	$(MAKE) -C .devcontainer envstart

enventer:
	$(MAKE) -C .devcontainer enventer

envstop:
	$(MAKE) -C .devcontainer envstop

envdestroy:
	$(MAKE) -C .devcontainer envdestroy
