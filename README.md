# OpenAPI

Simple API Gradle project with friendly CI/Ops scripts

## Environments

The set of scripts is meant to target different environments ( could be dev, prod, remote, or what you prefer ). By default the `local` environment is provided. In order to extend it, you can create your own script in `.ops/deploy`.

In order to trigger that script, all you need to do is running the make goal + the name of the environment. For example, suppose you want to trigger a `dev` deployment, all you need to run is `make deploy_dev`.

## Requirements

- [GNU make](https://www.gnu.org/software/make/)
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)
- [docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/#install-compose)

### Windows

- [MSYS2](https://www.msys2.org/) required to run bash scripts, see [Why Unix oriented toolings?](#why-unix-oriented-toolings)

### Mac

- [Homebrew](https://brew.sh/) required to obtain some of the required tools, see [Why Unix oriented toolings?](#why-unix-oriented-toolings)

## How to run

By default this CI solution is meant to target your local environment.

The first goal you may want to run, if you wish to build, deploy and test this solution in one shot, is:

```sh
$ make deploy
```

Otherwise, you can run each goal separately. Feel free to continue reading the documentation to know more.

## Available commands

### `start`

> This command is an alias of `start_local`

This command will build the code and start the API environment.

How to use:

```sh
$ make start
```

### `stop`

> This command is an alias of `stop_local`

This command will stop the API environment.

How to use:

```sh
$ make stop
```

### `restart`

> This command is an alias of `restart_local`

This command will restart the API environment.

How to use:

```sh
$ make restart
```

### `inspect`

> This command is an alias of `inspect_local`

This command will show logs coming from the API environment. In order to stop following logs, you can use `Ctrl+C`.

How to use:

```sh
$ make inspect
```

### `test`

> This command is an alias of `test_local`

This command will run some basic integrity tests on the API environment.

How to use:

```sh
$ make test
```

### `deploy`

> This command is an alias of `deploy_local`

This command will build the code, start and test the API environment.

How to use:

```sh
$ make deploy
```

### `redeploy`

> This command is an alias of `redeploy_local`

This command will force the rebuild of the API code and it will deploy the result in your current Docker environment.

How to use:

```sh
$ make redeploy
```

### `clean`

> This command is an alias of `clean_local`

This command will cleanup your Docker environment like nothing was ever deployed. Useful if you want to start from scratch.

How to use:

```sh
$ make clean
```

## Available APIs

### Health API

http://localhost:8080/health

### OpenAPI

http://localhost:8080/openapi

### Swagger UI

http://localhost:3000/?url=http://localhost:8080/openapi

## FAQ

### Why Unix oriented toolings?

The preference for `make`, `curl` and `jq` is set because most of the times those tools do already come preinstalled or they are already installed, as a dependency of other packages in your system ( if working on Unix-like environments like Linux or Mac ). Setting the bar low also means providing an easy access to the workflow to every developer, as well as maintainer of this repository. Less languages to learn, less tools to learn.

Despite `make` being known to be used to build C/C++ projects, can be easily used to build custom workflows. The tool is pretty much universal, well supported and rock solid.

Finally, on Windows this flow is fully supported by installing `MSYS2` ( which does come also partially bundled with Git for Windows when installed, despite missing the package manager ), and through `pacman` is easy to obtain the required depdendencies as simple as running:

```sh
$ pacman -S make curl jq
```

On Mac, if not already present, dependencies can be easily obtained through `homebrew` as simple as:

```sh
$ brew install make
$ brew install curl
$ brew install jq
```

Docker and Docker-Compose do themself expose the binary to either the native Command line or Bash Command line, which makes them transparently supported, on all the OS where it is supported.

### Why Bash unit tests?

Unit Tests must usually be provided by the development team in charge of working on the microservice ( in this case the API REST service ). This project provides a basic set of tests which would ensure the quality of a freshed deployed environment in your own local workstation. It should not be considered as a fully fledged framework, despite being easy to use ( see [.ops/deploy/local.sh](.ops/deploy/local.sh#L54) for examples ).
