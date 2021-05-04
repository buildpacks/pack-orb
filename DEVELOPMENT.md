## Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop)
* [`circleci` CLI](https://circleci.com/docs/2.0/local-cli/#installation)
* Make (and build tools)
    * macOS: `xcode-select --install`
    * Windows:
        * `choco install cygwin make -y`
        * `[Environment]::SetEnvironmentVariable("PATH", "C:\tools\cygwin\bin;$ENV:PATH", "MACHINE")`

### Linting

```
make lint
```

### Testing

Tests are structured as recommended by the [Orb Project Template](https://github.com/CircleCI-Public/Orb-Project-Template/tree/master/src/tests). They use [shunit2](https://github.com/kward/shunit2) instead of [BATS-Core](https://github.com/bats-core/bats-core).

```
make test
```
