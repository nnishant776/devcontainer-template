all:

devcontainer:
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	$(MAKE) _setup_pod
else
	$(MAKE) _setup_compose
endif
else
	$(MAKE) _setup_vscode
endif

_prebuild:
	-mv project-name $(project_name)
	sed -i "s/project-name/$(project_name)/g" $(project_name)/*
	sed -i "s/project-name/$(project_name)/g" docker-compose.yaml
	sed -i "s/project-name/$(project_name)/g" pod.yaml
	sed -i "s/project-name/$(project_name)/g" devcontainer.json
	sed -i "s/container-name/$(container_name)/g" devcontainer.json
	sed -i "s/container-name/$(container_name)/g" pod.yaml
	sed -i "s/container-name/$(container_name)/g" docker-compose.yaml
	cp $(project_name)/Dockerfile.template $(project_name)/Dockerfile

ifeq ($(strip $(flavor)), full)
	cp $(project_name)/Dockerfile.full.base $(project_name)/Dockerfile.base
	cp $(project_name)/Dockerfile.full.dev $(project_name)/Dockerfile.dev
	cp $(project_name)/Makefile.full $(project_name)/Makefile
else
	cp $(project_name)/Dockerfile.minimal.base $(project_name)/Dockerfile.base
	cp $(project_name)/Dockerfile.minimal.dev $(project_name)/Dockerfile.dev
	cp $(project_name)/Makefile.minimal $(project_name)/Makefile
endif

baseimage: _prebuild
	$(runtime) build -f $(project_name)/Dockerfile.base -t localhost/$(project_name):base .
	$(runtime) build -f $(project_name)/Dockerfile.dev -t localhost/$(project_name):dev .

_setup_vscode: baseimage
	devcontainer up --docker-path $(runtime) --workspace-folder .. # Ensure that devcontainer cli is installed (sudo npm install -g @devcontainers/cli)

_setup_pod: baseimage
ifeq ($(strip $(runtime)), podman)
	sed -i "s/$(project_name)\///g" $(project_name)/Dockerfile
	podman kube play --replace pod.yaml # Ensure that the podman cli is installed
else
	echo "Invalid runtime and infra combination"
	exit 1
endif

_setup_compose: baseimage
	$(runtime) compose up -d # Ensure that either of podman-compose or docker compose is installed

.PHONY: list
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
	awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
   	sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

envstart:
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	podman pod start $(project_name) && \
	podman exec -it -w /workspace $(project_name)-$(container_name) bash
else
	$(runtime) compose up -d && \
	$(runtime) compose exec -w /workspace development bash
endif
else
	devcontainer up --docker-path $(runtime) && devcontainer open
endif

enventer: envstart
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	podman exec -it -w /workspace $(project_name)-$(container_name) bash
else
	$(runtime) compose exec -w /workspace development bash
endif
else
	devcontainer open ..  # Ensure that vscode binary is discoverable in $PATH
endif

envstop:
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	podman pod stop $(project_name)
else
	$(runtime) compose stop
endif
else
	$(runtime) stop vscode-$(container_name)
endif

envdestroy: envstop
ifeq ($(strip $(editor)), cli)
ifeq ($(strip $(infra)), pod)
	podman kube play --down pod.yaml
else
	$(runtime) compose down
endif
else
	$(runtime) container rm vscode-$(container_name)
endif
