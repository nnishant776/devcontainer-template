project_name = project-name
flavor = full # full,minimal
runtime = podman # podman, docker
editor = cli # cli, vscode
infra = pod # pod, compose
root = $(realpath $(shell dirname $(firstword $(MAKEFILE_LIST))))

devcontainer:
	-mv $(root)/.devcontainer/project-name $(root)/.devcontainer/$(project_name)
	-sed -i "s/project-name/$(project_name)/g" $(root)/.devcontainer/$(project_name)/*
	-sed -i "s/project-name/$(project_name)/g" $(root)/.devcontainer/docker-compose.yaml
	-sed -i "s/project-name/$(project_name)/g" $(root)/.devcontainer/pod.yaml
	-sed -i "s/project-name/$(project_name)/g" $(root)/.devcontainer/devcontainer.json
ifeq ($(strip $(flavor)), full)
	ln -sf $(root)/.devcontainer/$(project_name)/Dockerfile.full $(root)/.devcontainer/$(project_name)/Dockerfile
	ln -sf $(root)/.devcontainer/$(project_name)/Makefile.full $(root)/.devcontainer/$(project_name)/Makefile
else
	ln -sf $(root)/.devcontainer/$(project_name)/Dockerfile.minimal $(root)/.devcontainer/$(project_name)/Dockerfile
	ln -sf $(root)/.devcontainer/$(project_name)/Makefile.minimal $(root)/.devcontainer/$(project_name)/Makefile
endif
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	$(MAKE) setup_pod
else
	$(MAKE) setup_compose
endif
else
	$(MAKE) setup_vscode
endif

setup_vscode:
	devcontainer up --docker-path $(runtime) # Ensure that devcontainer cli is installed (sudo npm install -g @devcontainers/cli)

setup_pod:
ifeq ($(strip $(runtime)), podman)
	podman kube play -f .devcontainer/pod.yaml --replace # Ensure that the podman cli is installed
else
	echo "Invalid runtime and infra combination"
	exit 1
endif

setup_compose:
ifeq ($(strip $(runtime)), podman)
	podman-compose -f .devcontainer/docker-compose.yaml up --build -d # Ensure that podman-compose is installed (python3 -m pip install podman-compose)
else
	docker compose -f .devcontainer/docker-compose.yaml up --build -d # Ensure that the compose plugin is installed
endif
