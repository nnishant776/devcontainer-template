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
  $ git fetch --prune --all
  ```
- Import files from this repository in your repository
  ```shell
  $ git checkout devcont/main -- .
  ```
  >NOTE: Given that most repositories have `README.md` at the project root, running above command could modify the original `README.md` file. To avoid that use the command below
  ```
  $ git checkout devcont/main -- .devcontainer Makefile.devcontainer
  ```

## Configuration
To configure this for a particular repository, some changes must be made.

> [!NOTE]
> The configurations mentioned below could also be passed at the time of invocation of the `make` command, but the optimal/recommended way is to edit the defaults for a given project. This would help in creating consistent, reproducible builds for the devcontainer.

### Change the default project name
In the root `Makefile.devcontainer` file, make the changes at the indicated position
```make
# Either edit below variables to their desired value or provide these in the command line
# Recommended to edit the variables to get reproducible builds
_project_name = project-name      <---- Change this to the project name of your choice
_runtime = podman # podman, docker
_editor = cli # cli, vscode
...
```

### Change the default container runtime
Once the project name is updated, the next step is to update the container runtime you want to work with. The default is set to `podman` here but docker is also supported.
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

> [!NOTE]
> If the choice for the editor is `vscode`, the user is expected to have a valid, updated installation of `@devcontainers/cli` (npm package required for creating the devcontainer). If the `devcontainer` cli application is not discoverable in the PATH, the devcontainer creation using this workflow will fail. To avoid this, the other option is to just generate the devconatainer.json file (see below) for your project and let VSCode handle it. Currently, this project doesn't support installation of nodejs/npm, and there are no such plans in the future.

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

> [!NOTE]
> Currrently, choosing `pod` for container management requires that you choose the runtime as `podman` as `docker` doesn't support launching containers through pod specification.

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
After you have modified the `Makefile.devcontainer` based on your preferences, follow below steps to create and use the devcontainer.

- Generate devcontainer configuration
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=generate
  ```

- Create the devcontainer
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=create
  ```

- Start the container
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=start
  ```

- Enter the container
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=enter
  ```

- Stop the container
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=stop
  ```

- Remove the container
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=destroy
  ```

- Remove the container and cleanup images
  ```
  $ make -f Makefile.devcontainer devcontainer action=purge
  ```

- Restore the devcontainer configuration back to its original state
  ```shell
  $ make -f Makefile.devcontainer devcontainer action=clean
  ```
