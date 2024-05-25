project_name = project-name
flavor = full # full,minimal
runtime = podman # podman, docker
editor = cli # cli, vscode
infra = pod # pod, compose

devcontainer:
	-mv .devcontainer/project-name .devcontainer/$(project_name)
	-sed -i "s/project-name/$(project_name)/g" .devcontainer/$(project_name)/*
	-sed -i "s/project-name/$(project_name)/g" .devcontainer/docker-compose.yaml
	-sed -i "s/project-name/$(project_name)/g" .devcontainer/pod.yaml
	-sed -i "s/project-name/$(project_name)/g" .devcontainer/devcontainer.json
ifeq ($(strip $(flavor)), full)
	cp .devcontainer/$(project_name)/Dockerfile.full .devcontainer/$(project_name)/Dockerfile
	cp .devcontainer/$(project_name)/Makefile.full .devcontainer/$(project_name)/Makefile
else
	cp .devcontainer/$(project_name)/Dockerfile.minimal .devcontainer/$(project_name)/Dockerfile
	cp .devcontainer/$(project_name)/Makefile.minimal .devcontainer/$(project_name)/Makefile
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
	podman kube play --context-dir=.devcontainer --build --replace .devcontainer/pod.yaml # Ensure that the podman cli is installed
else
	echo "Invalid runtime and infra combination"
	exit 1
endif

setup_compose:
ifeq ($(strip $(runtime)), podman)
	podman-compose -f .devcontainer/docker-compose.yaml up --build -d # Ensure that podman-compose is installed (python3 -m pip install podman-compose)
else
	docker compose --progress plain -f .devcontainer/docker-compose.yaml up --build -d # Ensure that the compose plugin is installed
endif
