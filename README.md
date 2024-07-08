# devcontainer-template

This project aims to provide a very (opinionated) generic, initial configuration and file structure to do container based development. It can be either the initial starting point for any repository or it could be imported later in an existing repository (see below).

## Setup
### For using this as a template for a new repository
To use this to configure a new repository, follow below steps.
- Clone the repository
  ```shell
  $ git clone --recursive https://github.com/nnishant776/devcontainer-template <directory>
  $ cd <directory>
  ```

- After cloning, change the default origin remote to point to your own repository
  ```shell
  $ git remote rename origin devcont   # Just an example. Use any name of your choice
  $ git remote add origin <your-remote-repository-url>
  ```

### For using this in an existing repository
To use this in an existing repository, follow below steps.
- Add a new remote for this repository in the local copy of __your__ repository
  ```shell
  $ git remote add devcont https://github.com/nnishant776/devcontainer-template
  ```
- Import files from this repository in your repository
  ```shell
  $ git checkout devcont/main -- .
  ```

## Configuration
This is Makefile based workflow. So, to configure this for a particular repository, some changes must be made.

Do note that since this is `Makefile` based, the configurations mentioned below could also be passed at the time of invocation of the `make` command, but the optimal way would be to edit the defaults here in case you want to share the configuration for a given project. This would help with consistent, reproducible builds for the devcontainer.

### Change the default project name
In the root `Makefile` file, make the changes at the indicated position
```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name      <---- Change this to the project name of your choice
_runtime = podman # podman, docker
_editor = cli # cli, vscode
...
```

### Change the default container runtime
Once the project name is updated, the next step is to update the container runtime you want to work with. The default is set to `podman` here but docker is also supported. So, you can change this to `docker` as well.
```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_runtime = podman # podman, docker   <---- Change this to either docker or podman
_editor = cli # cli, vscode
_infra = pod # pod, compose (pod is only supported with podman)
_optimized = false # true or false (use if for multi stage builds)
```

### Change the mode of editing
After runtime configuration, you also have the option to choose your mode of code editing. The options available are `cli` (terminal based) and `vscode` (GUI based). Selecting either will configure and create the devcontainers and the associated configuration depending on the respective choice.

**NOTE**:
> If the choice for the editor is `vscode`, the user is expected to have a valid, updated installation of `@devcontainers/cli` (required for creating the devcontainer). If you don't want this, the other option is to just generate the devconatainer.json file (see below) for your project and let VSCode handle it from there. Currently, this project doesn't support installation of nodejs/npm, and there are no such plans in the future.

```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_runtime = podman # podman, docker
_editor = cli # cli, vscode   <---- Change this to either cli or vscode
_infra = pod # pod, compose (pod is only supported with podman)
_optimized = false # true or false (use if for multi stage builds)
```

### Change the default container manager
After the editor choice selection, we need to decide how the created containers will be managed. The available options to do so are through either `pod` or `compose`. As the name implies, `compose` would manage containers through a `docker-compose.yaml` file, whereas `pod` would manage the containers via a Kubernetes pod specification.
```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_runtime = podman # podman, docker
_editor = cli # cli, vscode
_infra = pod # pod, compose (pod is only supported with podman)   <---- Change this to either docker or podman
_optimized = false # true or false (use if for multi stage builds)
```
Given that `docker` is the most prevalant choice for most user, container oschestration through `docker-compose.yaml` is readily supported.

**NOTE**:
> Currrently, choosing `pod` for container management requires that you choose the runtime as `podman` as the `docke` runtime doesn't support launching containers through pod specification.

### Enable build optimization
If you plan to use this template for multiple projects on the same machine, changing the `_optimized` setting to `true` would be helpful with the container build times. This option allows the runtimes to do multi-stage builds as it creates separate layered base and development images. As long as the steps are not modified, the existing base and dev images should drastically reduce the time to bring up new devcontainers in different projects
```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name
_runtime = podman # podman, docker
_editor = cli # cli, vscode
_infra = pod # pod, compose (pod is only supported with podman)
_optimized = false # true or false (use if for multi stage builds) <---- Change this to true to help with caching
```
### Check the generated files into VCS
You can select to add the generated files and the modified configuration to be tracked in vcs by default. To enable this, set the `vcs` option to `true`. This is off by default, i.e., the generated configuration will not be tracked by vcs
```make
_infra = compose # pod, compose (pod is only supported with podman)
_optimized = false # true or false (use if for multi stage builds)

project_name = $(strip $(_project_name))
runtime = $(strip $(_runtime))
editor = $(strip $(_editor))
infra = $(strip $(_infra))
optimized = $(strip $(_optimized))
container_name = ${project_name}-dev
vcs = false # true, false (setting to true will add new/modified devcontainer files to the working tree)  <----
```

## Devcontainer operations
- Config generation

  After all the configuration is done, we can generate the devcontainer configuration. To do so, run the following command.
  ```shell
  $ make devcontainer action=generate
  ```

- Creatig the devcontainer

  To create the devcontainers, run the following command
  ```shell
  $ make devcontainer action=create
  ```

- Starting the container

  Once the container is create, we can start the container with the command below
  ```shell
  $ make devcontainer action=start
  ```

- Entering the container

  As a shortcut to avoid starting and entering separately, the `enter` action first starts the container and then enters it
  ```shell
  $ make devcontainer action=enter
  ```

- Stopping the container

  To stop the containers (without destroying), run the following command
  ```shell
  $ make devcontainer action=stop
  ```

- Removing the container

  To remote (destroy) the containers, run the following command
  ```shell
  $ make devcontainer action=destroy
  ```

- Cleaning the devcontainer

  To restore the devcontainer configuration back to its original state, run the following command
  ```shell
  $ make devcontainer action=clean
  ```

## Customization
You can edit the exising devcontainer configuration or the root `Makefile` to customize this and suit to your needs to have a unified `Makefile` based workflow for development, build, testing, etc...
